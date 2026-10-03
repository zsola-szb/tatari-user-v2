import 'package:tatarigigs_user/feature/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginWidget extends StatelessWidget {
  final String? redirectUrl;
  const SocialLoginWidget({super.key,  this.redirectUrl});

  @override
  Widget build(BuildContext context) {

    var config = Get.find<SplashController>().configModel.content?.customerLogin;

    List<SocialLoginType> socialLoginOption = [
      if(config?.socialMediaLoginOptions?.google == 1) SocialLoginType.google,
      if(config?.socialMediaLoginOptions?.facebook == 1) SocialLoginType.facebook,
      if(config?.socialMediaLoginOptions?.apple == 1 && !GetPlatform.isAndroid) SocialLoginType.apple,
    ];

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: socialLoginOption.map((element){
      return Expanded(
        child: _SocialLoginButton(
          socialLoginType: element,
          redirectUrl: redirectUrl,
          showPadding: (socialLoginOption.length-1) != socialLoginOption.indexOf(element),
        ),
      );
    }).toList());
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String ? redirectUrl;
  final SocialLoginType socialLoginType;
  final bool showPadding;
  const _SocialLoginButton({required this.socialLoginType, required this.redirectUrl, required this.showPadding});

  @override
  Widget build(BuildContext context) {
    return  Padding( padding:  EdgeInsets.only(
      right : showPadding && Get.find<LocalizationController>().isLtr ? Dimensions.padding10 : 2,
      left : showPadding && !Get.find<LocalizationController>().isLtr ? Dimensions.padding10 : 2 ,
    ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius8)),
        onTap: ()=> _onTap(socialLoginType: socialLoginType),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius8)),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3), width: 1),
          ),
          child: Image.asset(
            socialLoginType == SocialLoginType.google ? Images.google :
            socialLoginType == SocialLoginType.facebook ? Images.facebook : Images.apple,
            height: ResponsiveHelper.isTab(context) ? 24 : 20,
            width: ResponsiveHelper.isTab(context) ? 24 : 20,
          ),
        ),
      ),
    );
  }

  void route(bool isRoute, String? token, String errorMessage, String? tempToken, UserInfoModel? userInfoModel, String? socialLoginMedium, String? userName, String? email) async {
    if (isRoute) {
      if(token != null){
        final bool canRedirectToRedirectUrl = redirectUrl != null && redirectUrl != RouteHelper.initial;

        if(canRedirectToRedirectUrl) {
          final redirectRoute = RouteHelper.parseRedirectRouteToNavigate(redirectUrl!);
          Get.offAllNamed(redirectRoute.path);

        }else {
          if(Get.find<LocationController>().getUserAddress() !=null){
            Get.offAllNamed(RouteHelper.getMainRoute("home"));

          }else{
            Get.offAllNamed(RouteHelper.pickMap);
          }
        }


      }else if(tempToken != null){
        Get.toNamed(RouteHelper.getUpdateProfileRoute(
          email: email ?? "",
          tempToken: tempToken,
          userName: userName ?? "",
          redirectUrl: redirectUrl,
        ));

      }else if(userInfoModel != null){
        showModalBottomSheet(
          context: Get.context!,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => ExistingAccountBottomSheet(
            userInfoModel: userInfoModel,
            socialLoginMedium: socialLoginMedium!,
            redirectUrl: redirectUrl,
          ),
          backgroundColor: Colors.transparent,
        );
      }
      else {
        customSnackBar(errorMessage, type: ToasterMessageType.error);
      }

    } else {
      customSnackBar(errorMessage, type: ToasterMessageType.error);

    }
  }



  Future<void> _onTap ({required SocialLoginType socialLoginType}) async {

    if(socialLoginType == SocialLoginType.google){

      final SocialLogInBody? socialLoginModel = await Get.find<AuthController>().googleLogin();


      if(socialLoginModel != null) {
        Get.find<AuthController>().loginWithSocialMedia(
          socialLoginModel, route,
        );
      }
    }

    else if(socialLoginType == SocialLoginType.facebook){
      final SocialLogInBody? socialLoginModel =  await Get.find<AuthController>().facebookLogin();

      if(socialLoginModel != null) {
        Get.find<AuthController>().loginWithSocialMedia(socialLoginModel, route);
      }
    } else if(socialLoginType == SocialLoginType.apple){
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
          email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: "apple",
        guestId: Get.find<SplashController>().getGuestId(),
        userName: credential.givenName ?? credential.familyName
      ),route);
    }
  }
}
