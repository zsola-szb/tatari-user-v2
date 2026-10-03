import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';



class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final String? redirectRoute;
   const SignInScreen({super.key,required this.exitFromApp, this.redirectRoute}) ;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  var signInPhoneController = TextEditingController();
  var signInPasswordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final GlobalKey<FormState> customerSignInKey = GlobalKey<FormState>();

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
        resizeToAvoidBottomInset: false,

        body: GetBuilder<SplashController>(builder: (splashController){
          return GetBuilder<AuthController>(builder: (authController) {

            final horizontalPadding = ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.padding20;

            return Column(children: [
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: customerSignInKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column( children: [
                      const SizedBox(height: Dimensions.padding32),

                      AuthScreenHeader(exitFromApp: widget.exitFromApp),
                      const SizedBox(height: Dimensions.padding12),

                      Text('login_with_password'.tr, textAlign: TextAlign.center,
                        style: context.heading.extraLarge,
                      ),
                      const SizedBox(height: Dimensions.padding6),

                      Text('use_your_registered_email_phone_number_to_login'.tr, textAlign: TextAlign.center,
                        style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                      ),
                      const SizedBox(height: Dimensions.padding24),

                      LoginMediumTabs(
                        isNumberLogin: authController.isNumberLogin,
                        onChanged: (value){
                          signInPhoneController.clear();
                          authController.toggleIsNumberLogin(value: value);
                        },
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimensions.padding20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius16),
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            authController.isNumberLogin ? CustomTextField(
                              key: const ValueKey('sign_in_phone_field'),
                              onCountryChanged: (countryCode) => authController.countryDialCode = countryCode.dialCode!,
                              countryDialCode: authController.countryDialCode,
                              title: 'phone'.tr,
                              hintText: 'please_enter_phone_number'.tr,
                              controller: signInPhoneController,
                              focusNode: _phoneFocus,
                              nextFocus: _passwordFocus,
                              isShowBorder: true,
                              inputType: TextInputType.phone,
                              onValidate: (String? value){
                                return PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+signInPhoneController.text.trim(), withCountryCode: true) == ""
                                    ? 'enter_valid_phone_number'.tr : null;
                              },
                            ) : CustomTextField(
                              key: const ValueKey('sign_in_email_field'),
                              title: 'email'.tr,
                              hintText: 'enter_valid_email_address'.tr,
                              controller: signInPhoneController,
                              focusNode: _phoneFocus,
                              nextFocus: _passwordFocus,
                              isShowBorder: true,
                              inputType: TextInputType.emailAddress,
                              capitalization: TextCapitalization.none,
                              onValidate: (String? value){
                                return GetUtils.isEmail(value ?? "") ? null : 'enter_valid_email_address'.tr;
                              },
                            ),
                            const SizedBox(height: Dimensions.padding16),

                            CustomTextField(
                              key: ValueKey('sign_in_password_field_${authController.isNumberLogin}'),
                              title: 'password'.tr,
                              hintText: '************'.tr,
                              controller: signInPasswordController,
                              focusNode: _passwordFocus,
                              inputType: TextInputType.visiblePassword,
                              isPassword: true,
                              isShowBorder: true,
                              inputAction: TextInputAction.done,
                              onValidate: (String? value){
                                return FormValidation().isValidPassword(value!.tr);
                              },
                            ),
                            const SizedBox(height: Dimensions.padding12),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              InkWell(
                                onTap: () => authController.toggleRememberMe(),
                                child: Row( children: [
                                  SizedBox( width: 16,
                                    child: Checkbox(
                                      activeColor: Theme.of(context).colorScheme.primary,
                                      value: authController.isActiveRememberMe,
                                      onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.radius4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.padding6),
                                  Text('remember_me'.tr, style: context.subHeading.small),
                                ]),
                              ),
                              TextButton(
                                onPressed: () {
                                  var config = splashController.configModel.content;
                                  if(config?.forgetPasswordVerificationMethod?.phone == 0 && config?.forgetPasswordVerificationMethod?.email == 0){
                                    customSnackBar('no_verification_method_found'.tr);
                                  }else{
                                    Get.toNamed(RouteHelper.getForgotPasswordScreen(redirectUrl: widget.redirectRoute));
                                  }
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text('forgot_password'.tr, style: context.heading.small.overrideWith(color: context.customThemeColors.info)),
                              ),
                            ]),
                            const SizedBox(height: Dimensions.padding20),

                            CustomButton(
                              buttonText: 'continue_to_login'.tr,
                              onPressed:  ()  {
                                if(customerSignInKey.currentState!.validate()) {
                                  _login(authController);
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
                              signInPhoneController.clear();
                              signInPasswordController.clear();

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
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const TermsAndPrivacyText(),
              ),
              const SizedBox(height: Dimensions.padding16),
            ]);
          });
        }),
      ),
    );
  }

  void _initializeController(){
    var authController  = Get.find<AuthController>();
    String phoneWithoutCountryCode = PhoneVerificationHelper.getValidPhoneNumber(authController.getUserNumber());
    String countryCode = PhoneVerificationHelper.getCountryCode(authController.getUserNumber());

    WidgetsBinding.instance.addPostFrameCallback((_){
      var loginOption = Get.find<SplashController>().configModel.content?.customerLogin?.loginOption;
      if((loginOption?.manualLogin ?? 1) == 0 && loginOption?.otpLogin == 1){
        Get.offNamed(RouteHelper.getOtpLoginRoute(redirectUrl: widget.redirectRoute));
        return;
      }

      if(countryCode != "" && phoneWithoutCountryCode !=""){
        authController.toggleIsNumberLogin(value: true);
      }else{
        authController.toggleIsNumberLogin(value: false);
      }
      authController.toggleSelectedLoginMedium(loginMedium: LoginMedium.manual);
      authController.initCountryCode(countryCode: countryCode !="" ? countryCode : null);

      signInPhoneController.text = phoneWithoutCountryCode != "" ? phoneWithoutCountryCode : authController.isNumberLogin ? "" : authController.getUserNumber();
      signInPasswordController.text = authController.getUserPassword();

      if(signInPasswordController.text.isEmpty){
        signInPhoneController.text = "";
        authController.initCountryCode();
        authController.toggleIsNumberLogin(value: false);
      }
    });
    authController.toggleRememberMe(value: false, shouldUpdate: false);
  }

  void _login(AuthController authController) {
    if(customerSignInKey.currentState!.validate()){
      String phone = PhoneVerificationHelper.getValidPhoneNumber(authController.countryDialCode+signInPhoneController.text.trim(), withCountryCode: true);

      authController.login(
        redirectRoute: widget.redirectRoute,
        emailPhone: phone !="" ? phone : signInPhoneController.text.trim(),
        password : signInPasswordController.text,
        type : phone !="" ? "phone" : "email",
      );
    }
  }
}
