import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/profile/widget/update_additional_field_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key}) ;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> updateProfileKey = GlobalKey<FormState>();

  final FocusNode _firstName = FocusNode();
  final FocusNode _lastName = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneWithCountry = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<UserController>().removeProfileImage();
    Get.find<UserController>().loadAdditionalFields();
    _setControllerValue();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'edit_profile'.tr,
          centerTitle: false,
          bgColor: Theme.of(context).cardColor,
          isBackButtonExist: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: Dimensions.padding16),

              GetBuilder<AuthController>(builder: (authController){
                return GetBuilder<UserController>(builder: (userController){

                  var userInfo = userController.userInfoModel;
                  var config = Get.find<SplashController>().configModel.content;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                    child: Form(
                      key: updateProfileKey,
                      child: Column(
                        children: [
                         Container(
                           decoration: BoxDecoration(
                             color: Theme.of(context).cardColor,
                             borderRadius: BorderRadius.circular(Dimensions.radius16)
                           ),
                           padding: EdgeInsets.all(Dimensions.padding16),
                           child: Column(children: [
                             Align(
                               alignment: Alignment.centerLeft,
                               child: Text('general_info'.tr, style: context.heading.defaultSize),
                             ),
                             const SizedBox(height: Dimensions.padding16),

                             const ProfileImageSection(),
                             const SizedBox(height: Dimensions.padding16),

                             CustomTextField(
                               title: 'first_name'.tr,
                               hintText: 'first_name'.tr,
                               controller: firstNameController,
                               inputType: TextInputType.name,
                               isShowBorder: true,
                               focusNode: _firstName,
                               nextFocus: _lastName,
                               capitalization: TextCapitalization.words,
                               onValidate: (String? value){
                                 return FormValidation().isValidFirstName(value!);
                               },
                             ),
                             const SizedBox(height: Dimensions.padding16),

                             CustomTextField(
                               title: 'last_name'.tr,
                               hintText: 'last_name'.tr,
                               focusNode: _lastName,
                               isEnabled: true,
                               isShowBorder: true,
                               nextFocus: _phoneWithCountry,
                               controller: lastNameController,
                               inputType: TextInputType.name,
                               capitalization: TextCapitalization.words,
                               onValidate: (String? value){
                                 return FormValidation().isValidLastName(value!);
                               },
                             ),
                             const SizedBox(height: Dimensions.padding16),

                             Tooltip(
                               preferBelow: false,
                               triggerMode: TooltipTriggerMode.manual,
                               message: config?.emailVerification == 1 ? userInfo?.isEmailVerified == 1 ? "email_is_verified".tr : 'email_not_verified'.tr : "",
                               child: CustomTextField(
                                 title: 'email'.tr,
                                 hintText: 'email'.tr,
                                 focusNode: _emailFocus,
                                 controller: emailController,
                                 isShowBorder: true,
                                 inputType: TextInputType.name,
                                 capitalization: TextCapitalization.words,
                                 suffixIconUrl:  emailController.text != "" ? userInfo?.isEmailVerified == 1 ? Images.verified : config?.emailVerification == 1 ? Images.error : null : null,
                                 onSuffixTap: userInfo?.isEmailVerified == 0 && config?.emailVerification == 1 ? () async {
                                   SendOtpType  type = SendOtpType.verification ;
                                   Get.dialog(const CustomLoader(), barrierDismissible: false);
                                   await authController.sendVerificationCode(identity: emailController.text, identityType: "email", type: type).then((status){
                                     Get.back();
                                     if(status != null){
                                       if(status.isSuccess!){
                                         Get.toNamed(RouteHelper.getVerificationRoute(
                                           identity: emailController.text, identityType: "email",
                                           fromPage: "profile",
                                           firebaseSession: type == SendOtpType.firebase ? status.message : null,
                                         ));
                                       }else{
                                         customSnackBar(status.message.toString().capitalizeFirst ?? "" );
                                       }
                                     }
                                   });
                                 } : null ,
                                 onValidate: (String? value){
                                   return FormValidation().isValidEmail(value);
                                 },
                               ),
                             ),
                             const SizedBox(height: Dimensions.padding16),

                             Tooltip(
                               preferBelow: false,
                               triggerMode: TooltipTriggerMode.manual,
                               message: config?.phoneVerification == 1 ? userInfo?.isPhoneVerified == 1 ? 'cant_update_phone_number'.tr : 'phone_number_not_verified'.tr : "",
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: userInfo?.isPhoneVerified == 1 ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : null,
                                 ),
                                 child: CustomTextField(
                                   onCountryChanged: (CountryCode countryCode) {
                                     userController.countryDialCode = countryCode.dialCode!;
                                   },
                                   countryDialCode: userController.countryDialCode,
                                   title: 'phone'.tr,
                                   isShowBorder: true,
                                   hintText: 'enter_phone_number'.tr,
                                   isEnabled: userInfo?.isPhoneVerified == 1 ? false : true,
                                   inputType: TextInputType.phone,
                                   focusNode: _phoneWithCountry,
                                   nextFocus: _passwordFocus,
                                   controller: phoneController,
                                   suffixIconUrl: userInfo?.isPhoneVerified == 1 ? Images.verified : config?.phoneVerification == 1 ? Images.error : null,

                                   onSuffixTap: userInfo?.isPhoneVerified == 0 && config?.phoneVerification == 1 ? () async {
                                     Get.dialog(const CustomLoader(), barrierDismissible: false);
                                     SendOtpType  type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase :  SendOtpType.verification ;
                                     await authController.sendVerificationCode(identity: userController.countryDialCode + phoneController.text, identityType: "phone", type: type, fromPage: "profile").then((status){

                                       if(status != null){
                                         Get.back();
                                         if(status.isSuccess!){
                                           Get.toNamed(RouteHelper.getVerificationRoute(
                                             identity: userController.countryDialCode + phoneController.text,identityType: "phone",
                                             fromPage: "profile",
                                             firebaseSession: type == SendOtpType.firebase ? status.message : null,
                                           ));
                                         }else{
                                           customSnackBar(status.message.toString().capitalizeFirst ?? "" );
                                         }
                                       }
                                     });


                                   } : null ,

                                   onValidate: (String? value) {
                                     if(value == null || value.isEmpty){
                                       return 'enter_phone_number'.tr;
                                     }else{
                                       return FormValidation().isValidPhone(userController.countryDialCode+value,fromAuthPage: true
                                       );
                                     }
                                   },
                                 ),
                               ),
                             ),

                             if(userController.additionalFields.isNotEmpty)...[
                               const SizedBox(height: Dimensions.padding32),

                               Align(
                                 alignment: Alignment.centerLeft,
                                 child: Text('provide_additional_info'.tr, style: context.heading.large.overrideWith(fontWeight: AppWeight.semiBold)),
                               ),

                               ListView.builder(
                                 shrinkWrap: true,
                                 padding: EdgeInsets.zero,
                                 physics: const NeverScrollableScrollPhysics(),
                                 itemCount: userController.additionalFields.length,
                                 itemBuilder: (context, index) {
                                   return UpdateAdditionalFieldWidget(
                                     fieldModel: userController.additionalFields[index],
                                     index: index,
                                   );
                                 },
                               )
                             ],
                           ]),
                         ),
                          const SizedBox(height: Dimensions.padding16),

                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radius16)
                            ),
                            padding: EdgeInsets.all(Dimensions.padding16),
                            child: Column(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('account_information'.tr, style: context.heading.defaultSize),
                              ),
                              const SizedBox(height: Dimensions.padding16),

                              CustomTextField(
                                title: 'new_password'.tr,
                                hintText: '**************',
                                controller: passwordController,
                                focusNode: _passwordFocus,
                                isShowBorder: true,
                                nextFocus: _confirmPasswordFocus,
                                inputType: TextInputType.visiblePassword,
                                isPassword: true,
                                onValidate: (String? value){
                                  if(value == null || value.isEmpty){
                                    return null;
                                  }
                                  return FormValidation().isValidPassword(value);
                                },
                              ),
                              const SizedBox(height: 35),

                              CustomTextField(
                                title: 'confirm_new_password'.tr,
                                hintText: '**************',
                                controller: confirmPasswordController,
                                focusNode: _confirmPasswordFocus,
                                isShowBorder: true,
                                inputType: TextInputType.visiblePassword,
                                isPassword: true,
                                onValidate: (String? value) {
                                  if(passwordController.text.isEmpty){
                                    return null;
                                  }
                                  if(value == null || value.isEmpty){
                                    return 'this_field_can_not_empty'.tr;
                                  }
                                  return FormValidation().isValidConfirmPassword(passwordController.text, value);
                                },
                              )
                            ]),
                          ),

                          const SizedBox(height: Dimensions.padding24),

                          CustomButton(
                            isLoading: userController.isLoading,
                            fontSize: Dimensions.fontSizeDefault,
                            width: Get.width,
                            radius: Dimensions.radius12,
                            buttonText: 'update_information'.tr,
                            onPressed: () {
                              if (updateProfileKey.currentState!.validate()) {
                                UserInfoModel userInfoModel = UserInfoModel(
                                  fName: firstNameController.text.trim(),
                                  lName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: userController.countryDialCode + phoneController.value.text.trim(),
                                  password: passwordController.text.isNotEmpty ? passwordController.text.trim() : null,
                                  confirmPassword: passwordController.text.isNotEmpty ? confirmPasswordController.text.trim() : null,
                                );

                                final String? invalidField = userController.validateAdditionalFields();
                                if (invalidField != null) {
                                  customSnackBar('${titleFormatedName(invalidField)} ${'is_required'.tr}');
                                  return;
                                }

                                userController.updateUserProfile(userInfoModel: userInfoModel);
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.padding24),
                        ],
                      ),
                    ),
                  );
                });
              }),

              const SizedBox(height: Dimensions.padding16),
            ],
          ),
        ),
      ),
    );
  }

  void _setControllerValue(){
    UserController userController = Get.find<UserController>();
    firstNameController.text = userController.userInfoModel?.fName ?? "";
    lastNameController.text = userController.userInfoModel?.lName ?? "";
    emailController.text = userController.userInfoModel?.email ?? "";
    phoneController.text = PhoneVerificationHelper.updateCountryAndNumberInEditProfilePage(
        userController.userInfoModel?.phone != null ? Get.find<UserController>().userInfoModel!.phone! :'');
  }
}

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController){
      return Container(
        height: 120,
        width: Get.width,
        margin: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Center(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .2),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: userController.pickedProfileImageFile == null ?
                CustomImage(
                  placeholder: Images.placeholder,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  image: userController.userInfoModel?.imageFullPath ?? "",
                ) :
                Image.file(File(userController.pickedProfileImageFile!.path)),
              ),
            ),

            InkWell(
              child: Icon(
                Icons.camera_enhance_rounded,
                color: Theme.of(context).cardColor,
              ),
              onTap: () {
                userController.pickProfileImage();
              },
            )
          ]),
        ),
      );
    });
  }
}
