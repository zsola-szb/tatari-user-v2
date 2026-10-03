import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String url;
  final double amount;
  final bool createdAccount;

  const PaymentWebviewScreen({
    super.key,
    required this.url,
    this.amount = 0,
    this.createdAccount = false,
  });

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final CheckoutInAppBrowser _browser;

  @override
  void initState() {
    super.initState();
    _browser = CheckoutInAppBrowser(
      amount: widget.amount,
      createdAccount: widget.createdAccount,
    );
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

class CheckoutInAppBrowser extends InAppBrowser {
  final double amount;
  final bool createdAccount;

  CheckoutInAppBrowser({required this.amount, required this.createdAccount});

  bool _canRedirect = true;

  @override
  Future<void> onLoadStart(WebUri? url) async => _handleRedirect(url.toString());

  @override
  Future<void> onLoadStop(WebUri? url) async => _handleRedirect(url.toString());

  @override
  void onExit() {
    if (_canRedirect) {
      _canRedirect = false;
      Get.offNamed(RouteHelper.getDigitalPaymentFailedRoute(amount: amount));
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
    const List<String> webSchemes = <String>['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'];
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

    final bool isCallback =
        url.contains(AppConstants.baseUrl) && url.contains('flag');
    if (!isCallback) {
      return;
    }

    final bool isSuccess = url.contains('success');
    final bool isFailed = url.contains('fail') || url.contains('cancel');
    if (!isSuccess && !isFailed) {
      return;
    }

    _canRedirect = false;
    close();

    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (isSuccess) {
        Get.find<CartController>().refreshCart();
        Get.offNamed(
          RouteHelper.getBookingSuccessRoute(
            token: StringParser.parseString(url, 'token'),
            createdAccount: createdAccount,
          ),
        );
      } else {
        Get.offNamed(RouteHelper.getDigitalPaymentFailedRoute(amount: amount));
      }
    });
  }
}
