import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class BookingPaymentWebviewScreen extends StatefulWidget {
  final String url;

  const BookingPaymentWebviewScreen({super.key, required this.url});

  @override
  State<BookingPaymentWebviewScreen> createState() => _BookingPaymentWebviewScreenState();
}

class _BookingPaymentWebviewScreenState extends State<BookingPaymentWebviewScreen> {
  late final _BookingPaymentBrowser _browser;

  @override
  void initState() {
    super.initState();
    _browser = _BookingPaymentBrowser();
    _openBrowser();
  }

  Future<void> _openBrowser() async {
    if (GetPlatform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
    await _browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(widget.url)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
        ),
        browserSettings: InAppBrowserSettings(
          hideUrlBar: true,
          hideToolbarTop: GetPlatform.isAndroid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(title: 'payment'.tr),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).cardColor),
        ),
      ),
    );
  }
}

class _BookingPaymentBrowser extends InAppBrowser {
  bool _canRedirect = true;

  @override
  Future<void> onLoadStart(WebUri? url) async => _handleRedirect(url.toString());

  @override
  Future<void> onLoadStop(WebUri? url) async => _handleRedirect(url.toString());

  @override
  void onExit() {
    if (_canRedirect) {
      _canRedirect = false;
      _returnToBooking(isSuccess: false);
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
    NavigationAction navigationAction,
  ) async {
    final WebUri? uri = navigationAction.request.url;
    if (uri == null) {
      return NavigationActionPolicy.ALLOW;
    }
    const List<String> webSchemes = <String>[
      'http', 'https', 'file', 'chrome', 'data', 'javascript', 'about',
    ];
    if (!webSchemes.contains(uri.scheme)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  void _handleRedirect(String url) {
    if (!_canRedirect) {
      return;
    }
    if (!url.contains(AppConstants.baseUrl) || !url.contains('flag')) {
      return;
    }

    final bool isSuccess = url.contains('success');
    final bool isFailed = url.contains('fail') || url.contains('cancel');
    if (!isSuccess && !isFailed) {
      return;
    }

    _canRedirect = false;
    close();
    _returnToBooking(isSuccess: isSuccess);
  }

  void _returnToBooking({required bool isSuccess}) {
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (Get.currentRoute.contains('BookingPaymentWebviewScreen')) {
        Get.back<void>();
      }
      if (isSuccess) {
        customSnackBar('your_payment_confirm_successfully'.tr,
            type: ToasterMessageType.success, showDefaultSnackBar: false);
      } else {
        customSnackBar('payment_failed'.tr, showDefaultSnackBar: false);
      }
      if (Get.isRegistered<BookingDetailsController>()) {
        Get.find<BookingDetailsController>().reloadBooking();
      }
    });
  }
}
