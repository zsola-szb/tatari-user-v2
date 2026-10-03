import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class OtpLoginScreen extends StatefulWidget {
  final bool exitFromApp;
  final String? redirectRoute;
  const OtpLoginScreen({super.key, required this.exitFromApp, this.redirectRoute});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {

  var otpPhoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  final GlobalKey<FormState> otpLoginKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,

        body: SafeArea(child: GetBuilder<AuthController>(builder: (authController) {

          return Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: otpLoginKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.padding20,
              ),
              child: Column( children: [

                AuthScreenHeader(exitFromApp: widget.exitFromApp),
                const SizedBox(height: Dimensions.padding24),

                Text('get_otp'.tr, textAlign: TextAlign.center,
                  style: context.heading.extraLarge,
                ),
                const SizedBox(height: Dimensions.padding6),
                Text('use_your_registered_phone_number_to_get_otp'.tr, textAlign: TextAlign.center,
                  style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                ),
                const SizedBox(height: Dimensions.padding24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius16),
                    border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomTextField(
                        onCountryChanged: (countryCode) => authController.countryDialCode = countryCode.dialCode!,
                        countryDialCode: authController.countryDialCode,
                        title: 'phone_number'.tr,
                        hintText: 'please_enter_phone_number'.tr,
                        controller: otpPhoneController,
                        focusNode: _phoneFocus,
                        isShowBorder: true,
                        inputType: TextInputType.phone,
                        inputAction: TextInputAction.done,
                        onValidate: (String? value){
                          return PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+otpPhoneController.text.trim(), withCountryCode: true) == ""
                              ? 'enter_valid_phone_number'.tr : null;
                        },
                      ),
                      const SizedBox(height: Dimensions.padding20),

                      CustomButton(
                        buttonText: 'get_otp'.tr,
                        onPressed: () {
                          if(otpLoginKey.currentState!.validate()) {
                            _getOtp(authController);
                          }
                        },
                        isLoading: authController.isLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.padding20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${'new_to'.tr} ${AppConstants.appName}?',
                      style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
                    ),

                    TextButton(
                      onPressed: (){
                        otpPhoneController.clear();
                        Get.toNamed(RouteHelper.getSignUpRoute(redirectUrl: widget.redirectRoute));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('sign_up'.tr, style: context.heading.small.overrideWith(color: context.customThemeColors.info)),
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.padding16,),

              ]),
            ),
          );
        })),
      ),
    );
  }

  void _initializeController(){
    var authController = Get.find<AuthController>();
    String phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(authController.getUserNumber());
    String countryCode = PhoneVerificationHelper.getCountryCode(authController.getUserNumber());

    WidgetsBinding.instance.addPostFrameCallback((_){
      authController.toggleIsNumberLogin(value: true);
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.otp);
      authController.initCountryCode(countryCode: countryCode != "" ? countryCode : null);
      otpPhoneController.text = phoneWithoutCountryCode;
    });
  }

  void _getOtp(AuthController authController) {
    if(otpLoginKey.currentState!.validate()){
      var config = Get.find<SplashController>().configModel.content;
      SendOtpType type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;

      String phone = PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+otpPhoneController.text.trim(), withCountryCode: true);

      authController.sendVerificationCode(
        identity: phone,
        identityType : "phone",
        type: type, checkUser: 0,
        redirectUrl: widget.redirectRoute,
      ).then((status) {

        if(status != null){
          if(status.isSuccess!){
            Get.toNamed(RouteHelper.getVerificationRoute(
              identity: phone,identityType: "phone",
              fromPage: config?.firebaseOtpVerification == 1 ? "firebase-otp" : "otp-login",
              firebaseSession: type == SendOtpType.firebase ? status.message : null,
              redirectUrl: widget.redirectRoute,
            ));
          }else{
            customSnackBar(status.message.toString().capitalizeFirst);
          }
        }
      });
    }
  }
}
