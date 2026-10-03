import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoginOrSignupBottomSheet extends StatelessWidget {
  final String? redirectUrl;
  const LoginOrSignupBottomSheet({super.key, this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    var config = Get.find<SplashController>().configModel.content?.customerLogin;
    var otpLogin = config?.loginOption?.otpLogin;
    var manualLogin = config?.loginOption?.manualLogin ?? 1;
    var socialLogin = config?.loginOption?.socialMediaLogin;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radius20),
          topRight: Radius.circular(Dimensions.radius20),
        ),
      ),
      child: SizedBox(width: Dimensions.webMaxWidth / 2.5, child: Stack(
        clipBehavior: Clip.none,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: Dimensions.padding32),

              Text('login_or_signup'.tr, textAlign: TextAlign.center,
                style: context.heading.extraLarge,
              ),
              const SizedBox(height: Dimensions.padding6),

              Text('login_signup_bottom_sheet_subtitle'.tr, textAlign: TextAlign.center,
                style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
              ),
              const SizedBox(height: Dimensions.padding20),

              manualLogin == 1 ? CustomButton(
                buttonText: 'password_login'.tr,
                onPressed: () {
                  Get.back();
                  Get.toNamed(RouteHelper.getSignInRoute(redirectUrl: redirectUrl));
                },
              ) : const SizedBox.shrink(),

              manualLogin == 1 && otpLogin == 1 ? const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
                child: _OrDivider(),
              ) : const SizedBox.shrink(),

              otpLogin == 1 ? CustomButton(
                buttonText: 'otp_login'.tr,
                backgroundColor: context.customThemeColors.secondaryBackGroundColor,
                textColor: context.customThemeColors.textColor,
                onPressed: () {
                  Get.back();
                  Get.toNamed(RouteHelper.getOtpLoginRoute(redirectUrl: redirectUrl));
                },
              ) : const SizedBox.shrink(),

              (manualLogin == 1 || otpLogin == 1) && socialLogin == 1 ? const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.padding16),
                child: _OrDivider(),
              ) : const SizedBox.shrink(),

              socialLogin == 1 ? SocialLoginWidget() : const SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.only(top: Dimensions.padding16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${'new_to'.tr} ${AppConstants.appName}?',
                      style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
                    ),
                    TextButton(
                      onPressed: (){
                        Get.back();
                        Get.toNamed(RouteHelper.getSignUpRoute(redirectUrl: redirectUrl));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('sign_up'.tr, style: context.heading.small.overrideWith(color: context.customThemeColors.info)),
                    )
                  ],
                ),
              ),

              socialLogin == 1 ? const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.padding20),
                child: TermsAndPrivacyText(),
              ) : const SizedBox.shrink(),

              const SizedBox(height: Dimensions.padding16),
            ]),
          ),

          Positioned(
            top: 10,
            right: 0,
            child: InkWell(
              onTap: () => Get.back(),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.customThemeColors.backGroundColor
                ),
                padding: const EdgeInsets.all(Dimensions.padding3),
                child: Icon(Icons.close, size: 16, color: context.customThemeColors.secondaryTextColor),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final lineColor = Theme.of(context).hintColor.withValues(alpha: 0.3);
    return Row(children: [
      Expanded(child: Divider(color: lineColor, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
        child: Text('or'.tr.toUpperCase(), style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
      ),
      Expanded(child: Divider(color: lineColor, thickness: 1)),
    ]);
  }
}
