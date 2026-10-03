import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class NewPassScreen extends StatefulWidget {
  final ForgetPasswordBody? forgetPasswordBody;
  final String? redirectUrl;
  const NewPassScreen({super.key, this.forgetPasswordBody, this.redirectUrl});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final GlobalKey<FormState> newPassKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  String _identity='';

  @override
  void initState() {

    AuthController authController = Get.find();

    authController.newPasswordController.clear();
    authController.confirmNewPasswordController.clear();

    super.initState();
    _identity = widget.forgetPasswordBody?.identity ?? "";

    if(widget.forgetPasswordBody?.fromUrl == 1){
      authController.verifyOtpForForgetPasswordScreen(widget.forgetPasswordBody?.identity ?? "", widget.forgetPasswordBody?.identityType ?? "" , widget.forgetPasswordBody?.otp ??"", fromOutsideUrl: true, shouldUpdate: false).then((status) async {
        if (status.isSuccess!) {
         if (kDebugMode) {
           print("Session Available");
         }
        }else {
          if (kDebugMode) {
            print("Session Expired");
          }
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.padding20;

    return CustomPopWidget(
      onPopInvoked: () => Get.find<AuthController>().updateVerificationCode(''),
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,

        body: GetBuilder<AuthController>(builder: (controller){
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(children: [
              const SizedBox(height: Dimensions.padding32),

              const AuthScreenHeader(exitFromApp: false),
              const SizedBox(height: Dimensions.padding24),

              controller.forgetPasswordUrlSessionExpired && controller.isLoading ?
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ) :
              controller.forgetPasswordUrlSessionExpired && !controller.isLoading ?
              Column(children: [
                Text("url_session_expired".tr, textAlign: TextAlign.center,
                  style: context.heading.extraLarge,
                ),
                const SizedBox(height: Dimensions.padding20),
                CustomButton(buttonText: "go_back".tr,
                  onPressed: (){Get.offAllNamed(RouteHelper.getSignInRoute());
                  },
                )
              ]) : Form(key: newPassKey, child: Column(children: [
                Text('set_your_new_password'.tr, textAlign: TextAlign.center,
                  style: context.heading.extraLarge,
                ),
                const SizedBox(height: Dimensions.padding6),

                Text('enter_your_new_password_and_confirm_it_to_secure_your_account'.tr, textAlign: TextAlign.center,
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
                        title: 'password'.tr,
                        hintText: 'ex_8_plus_character'.tr,
                        controller: controller.newPasswordController,
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
                        hintText: 'ex_8_plus_character'.tr,
                        controller: controller.confirmNewPasswordController,
                        inputAction: TextInputAction.done,
                        focusNode: _confirmPasswordFocus,
                        isShowBorder: true,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        onValidate: (String? value) {
                          if(value == null || value.isEmpty){
                            return 'this_field_can_not_empty'.tr;
                          }else{
                            return FormValidation().isValidConfirmPassword(
                              controller.newPasswordController.text,
                              value,
                            );
                          }
                        },
                        onSubmit: null,
                      ),
                      const SizedBox(height: Dimensions.padding20),

                      GetBuilder<UserController>(builder: (userController) {
                        return GetBuilder<AuthController>(builder: (authBuilder) {
                          return ListenableBuilder(
                            listenable: Listenable.merge([
                              controller.newPasswordController,
                              controller.confirmNewPasswordController,
                            ]),
                            builder: (context, child) {
                              final String password = controller.newPasswordController.text;
                              final String confirmPassword = controller.confirmNewPasswordController.text;
                              final bool canSubmit = password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword;

                              return CustomButton(
                                buttonText: 'done'.tr,
                                isLoading: authBuilder.isLoading,
                                onPressed: canSubmit ? () {
                                  if(isRedundentClick(DateTime.now())){
                                    return;
                                  }
                                  else{
                                    _resetPassword(
                                      newPassword: password,
                                      confirmNewPassword: confirmPassword,
                                    );
                                  }
                                } : null,
                              );
                            },
                          );
                        });
                      }),
                    ],
                  ),
                ),
              ])),
              const SizedBox(height: Dimensions.padding20),
            ]),
          );
        }),
      ),
    );
  }

  void _resetPassword({required String newPassword, required String confirmNewPassword}) {
    if(newPassKey.currentState!.validate()){
      if(newPassword != confirmNewPassword){
        customSnackBar('confirm_password_not_matched'.tr);
      }else{
        Get.find<AuthController>().resetPassword(
          identity: _identity,
          identityType:  widget.forgetPasswordBody?.identityType ?? "",
          otp:  widget.forgetPasswordBody?.otp ?? "",
          password:  newPassword,
          confirmPassword:  confirmNewPassword,
          isFirebaseOtp:  widget.forgetPasswordBody?.isFirebaseOtp ?? 0,
          redirectUrl: widget.redirectUrl,
        );
      }
    }
  }
}
