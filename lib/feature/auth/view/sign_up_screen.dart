import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/auth/widgets/additional_field_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SignUpScreen extends StatefulWidget {
  final String? referralCode;
  final String? redirectRoute;

  const SignUpScreen({super.key, this.referralCode, this.redirectRoute}) ;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var referCodeController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  late final GlobalKey<FormState> customerSignUpKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().initCountryCode();
    Get.find<AuthController>().toggleTerms(value: false, shouldUpdate: false);
    final ConfigModel config = Get.find<SplashController>().configModel;
    Get.find<AuthController>().loadAdditionalFields(true);

    if (config.content?.referEarnStatus == 1 && (widget.referralCode?.isNotEmpty ?? false)) {
      referCodeController.text = widget.referralCode ?? '';
    }
  }
  @override
  void dispose() {
    super.dispose();
    _clearControllerValue();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      onPopInvoked: (){
        AuthController authController = Get.find();
        authController.acceptTerms == true ? authController.toggleTerms() :
        authController.acceptTerms ;
      },
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        resizeToAvoidBottomInset: false,

        body: GetBuilder<AuthController>(builder: (authController) {

          final horizontalPadding = ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.padding20;

          return Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: customerSignUpKey,
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(children: [
                    const SizedBox(height: Dimensions.padding32),

                    const AuthScreenHeader(exitFromApp: false),
                    const SizedBox(height: Dimensions.padding12),

                    Text('sign_up'.tr, textAlign: TextAlign.center,
                      style: context.heading.extraLarge,
                    ),
                    const SizedBox(height: Dimensions.padding6),

                    Text('sign_up_subtitle'.tr, textAlign: TextAlign.center,
                      style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                    ),
                    const SizedBox(height: Dimensions.padding24),

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
                          CustomTextField(
                            title: 'first_name'.tr,
                            hintText: 'enter_your_first_name'.tr,
                            controller: firstNameController,
                            isAutoFocus: false,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            isShowBorder: true,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            onValidate: (String? value){
                              return FormValidation().isValidFirstName(value!);
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            title: 'last_name'.tr,
                            hintText: 'enter_your_last_name'.tr,
                            controller: lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _emailFocus,
                            isShowBorder: true,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            onValidate: (String? value){
                              return FormValidation().isValidLastName(value!);
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            title: 'email'.tr,
                            hintText: 'enter_email_address'.tr,
                            controller: emailController,
                            focusNode: _emailFocus,
                            nextFocus: _phoneFocus,
                            isShowBorder: true,
                            inputType: TextInputType.emailAddress,
                            capitalization: TextCapitalization.none,
                            onValidate: (String? value){
                              return FormValidation().isValidEmail(value);
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            onCountryChanged: (CountryCode countryCode){
                              authController.countryDialCode = countryCode.dialCode!;
                            },
                            countryDialCode: authController.countryDialCode,
                            title: 'phone_number'.tr,
                            hintText: 'enter_phone_number'.tr,
                            controller: phoneController,
                            focusNode: _phoneFocus,
                            nextFocus: _passwordFocus,
                            isShowBorder: true,
                            inputType: TextInputType.phone,
                            onValidate: (String? value) {
                              if(value == null || value.isEmpty){
                                return 'enter_phone_number'.tr;
                              }else{
                                return FormValidation().isValidPhone(
                                    authController.countryDialCode+(value),
                                    fromAuthPage: true
                                );
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            title: 'password'.tr,
                            hintText: '****************'.tr,
                            controller: passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowBorder: true,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            onValidate: (String? value) {
                              return FormValidation().isValidPassword(value!);
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            title: 'confirm_password'.tr,
                            hintText: '****************'.tr,
                            controller: confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            nextFocus: _referCodeFocus,
                            isShowBorder: true,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            inputAction: TextInputAction.next,
                            onValidate: (String? value) {
                              if(value == null || value.isEmpty){
                                return 'this_field_can_not_empty'.tr;
                              }else{
                                return FormValidation().isValidConfirmPassword(
                                  passwordController.text,
                                  confirmPasswordController.text,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          CustomTextField(
                            title: 'refer_code_optional'.tr,
                            hintText: 'optional'.tr,
                            controller: referCodeController,
                            focusNode: _referCodeFocus,
                            isShowBorder: true,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            isRequired: false,
                          ),

                          if (authController.additionalFields.isNotEmpty)...[
                            const SizedBox(height: Dimensions.padding36),
                            Text('additional_info'.tr, style: context.heading.large),

                            ...List.generate(
                              authController.additionalFields.length,
                                  (index) => AdditionalFieldWidget(
                                fieldModel: authController.additionalFields[index],
                                index: index,
                              ),
                            ),
                          ],

                          const SizedBox(height: Dimensions.padding12),
                          ConditionCheckBox(
                            checkBoxValue: authController.acceptTerms,
                            onTap: (bool? value){
                              if(customerSignUpKey.currentState?.validate() == true){
                                authController.toggleTerms(value: true);
                              }else{
                                authController.toggleTerms(value: false);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding20),

                    CustomButton(
                      buttonText: 'sign_up'.tr,
                      isLoading: authController.isLoading,
                      onPressed: authController.acceptTerms
                          && customerSignUpKey.currentState?.validate() == true
                          ?  () => _register(authController)
                          : null,
                    ),
                    const SizedBox(height: Dimensions.padding20),
                  ]),
              ),
          );
        }),
      ),
    );
  }

  void _register(AuthController authController) async {
    if(customerSignUpKey.currentState!.validate()) {
      SignUpBody signUpBody;
      String numberWithCountryCode = PhoneVerificationHelper.getValidPhoneNumber(
          authController.countryDialCode + phoneController.value.text, withCountryCode: true
      );

      final String? invalidField = authController.validateAdditionalFields();
      if (invalidField != null) {
        customSnackBar('${titleFormatedName(invalidField)} ${'is_required'.tr}');
        return;
      }

      if(referCodeController.text!=""){
        signUpBody = SignUpBody(
            fName: firstNameController.value.text.trim(),
            lName: lastNameController.value.text.trim(),
            email: emailController.value.text.trim(),
            phone: numberWithCountryCode.trim(),
            password: passwordController.value.text.trim(),
            confirmPassword: confirmPasswordController.value.text.trim(),
            referCode: referCodeController.text.trim()
        );
      }else{
        signUpBody = SignUpBody(
          fName: firstNameController.value.text.trim(),
          lName: lastNameController.value.text.trim(),
          email: emailController.value.text.trim(),
          phone: numberWithCountryCode.trim(),
          password: passwordController.value.text.trim(),
          confirmPassword: confirmPasswordController.value.text.trim(),
        );
      }
      authController.registration(signUpBody: signUpBody, redirectUrl: widget.redirectRoute);

      }
    }

  void _clearControllerValue(){
    firstNameController.text = "";
    lastNameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    referCodeController.text = "";
  }
}
