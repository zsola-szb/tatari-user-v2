// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/subscription_helper.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

/// Generic payment-gateway webview for the flows that are **not** booking
/// checkout — wallet top-up (`add-fund`) and subscription purchase
/// (`subscription_plan`). Booking checkout has its own webview in
/// `feature/checkout/view/payment_webview_screen.dart`.
class GatewayWebviewScreen extends StatefulWidget {
  final String url;
  final String? fromPage;
  const GatewayWebviewScreen({super.key, required this.url, this.fromPage});

  @override
  State<GatewayWebviewScreen> createState() => _GatewayWebviewScreenState();
}

class _GatewayWebviewScreenState extends State<GatewayWebviewScreen> {
  String? selectedUrl;
  final bool _isLoading = true;
  late _GatewayBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData(widget.fromPage ?? "");

    log(widget.url);
  }

  void _initData(String fromPage) async {
    browser = _GatewayBrowser(fromPage: fromPage);

    if(GetPlatform.isAndroid){
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);

    bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl!)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(title: 'payment'.tr,),
      body: Center(
        child: Stack(
          children: [
            _isLoading ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary)),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _GatewayBrowser extends InAppBrowser {
  final String fromPage;

  _GatewayBrowser({required this.fromPage});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomPopWidget(
            child: AlertDialog(
              contentPadding: EdgeInsets.all(Dimensions.padding10),
              content: PaymentFailedDialog(isAddFound: fromPage == 'add-fund'),
            ),
          );
        },
      );

    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    Uri uri = navigationAction.request.url!;
    if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) async {
    if (kDebugMode) {
      print("inside_page_redirect");
    }
    printLog("url:$url");
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl) && url.contains("flag");
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl) && url.contains("flag");
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl) && url.contains("flag");

      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }

      if (isSuccess) {
        if(fromPage == "add-fund"){
          Get.back();
          String uuid = const Uuid().v1();
          Get.offNamed(RouteHelper.getMyWalletScreen(flag : 'success', token: uuid));
        } else if(fromPage == 'subscription_plan'){
          Get.back();
          SubscriptionHelper().showSuccessDialog();
          Get.find<UserController>().getUserInfo(reload: false);
          Get.find<CartController>().refreshCart();
          Get.find<CouponController>().getCouponList();
        }
      } else if (isFailed || isCancel) {
        if(fromPage == "add-fund"){
          Get.offNamed(RouteHelper.getMyWalletScreen(flag : 'failed'));
        } else {
          Get.back();
          customSnackBar("payment_failed_try_again".tr, type: ToasterMessageType.error, showDefaultSnackBar: false);
        }
      }
    }
  }
}
