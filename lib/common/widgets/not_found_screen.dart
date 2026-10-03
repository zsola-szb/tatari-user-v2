import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    String currentUrl = _saveErrorUrlIntoServer();

    Future.delayed( const Duration(milliseconds: 500),() {
      setState(() {
        isLoading = false;
      });
      if(_hasRedirectionUrl(currentUrl) != ""){
        String url = _hasRedirectionUrl(currentUrl);
        if(_checkExternalRedirection(url)){
          _launchURL(url);
        }else{
          Get.offAllNamed(url);
        }
      }
    });
  }

  String _saveErrorUrlIntoServer(){
    String currentURL = Get.currentRoute;
    Get.find<SplashController>().addError404UrlToServer(currentURL);
    return currentURL;
  }

  String _hasRedirectionUrl(String currentUrl){
    var config = Get.find<SplashController>().configModel.content;
    String redirectUrl = "";
    if( config !=null && config.errorLogs !=null && config.errorLogs!.isNotEmpty){
      config.errorLogs!.any((element){
        redirectUrl = element.url == currentUrl ? element.redirectUrl! : "";
        return element.url == currentUrl;
      });
    }
    if (kDebugMode) {
      print("Redirect Url : $redirectUrl");
    }
    return redirectUrl;
  }

  bool _checkExternalRedirection(String url){
    return url.startsWith('http://') || url.startsWith('https://');
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "page_not_found".tr),
      endDrawer: null,
      body: FooterBaseView(
        isCenter: true,
        child: isLoading ? const Center(child: CustomLoader()) : Center(child: Column(children: [
            Image.asset(Images.error404, width: 200),
            const SizedBox(height: Dimensions.padding20,),
            Text('oops_page_not_found'.tr, style: context.heading.extraLarge),
            const SizedBox(height: Dimensions.padding10),

            Text("the_page_you_entered".tr,
              style:  context.body.defaultSize,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.height * 0.1),

            CustomButton(buttonText: "back_to_home".tr, width: 250, onPressed: (){
              Get.offAllNamed(RouteHelper.getMainRoute('home'));
            })
          ]),
          ) ,
      ),
    );
  }
}
