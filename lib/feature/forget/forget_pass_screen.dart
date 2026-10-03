import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ForgetPassScreen extends StatefulWidget {
  final String? redirectUrl;
  const ForgetPassScreen({super.key, this.redirectUrl});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {

  final TextEditingController _identityController = TextEditingController();


  String countryDialCode = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode _identityFocus = FocusNode();

  bool _isNumberLogin = false;

  String _forgetPasswordMethod = "phone";

  @override
  void initState() {
    super.initState();

    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content!.countryCode!).dialCode?? "+880";
    var config = Get.find<SplashController>().configModel.content;
    if(config?.forgetPasswordVerificationMethod?.phone == 1 && config?.forgetPasswordVerificationMethod?.email == 1){
      _forgetPasswordMethod = "both";
    }else if(config?.forgetPasswordVerificationMethod?.phone == 1){
      _forgetPasswordMethod = "phone";
    }else{
      _forgetPasswordMethod = "email";
    }

    toggleIsNumberLogin(value: false,isUpdate: false);

  }

  String get _identityTitle => _isNumberLogin ? 'phone_number'.tr : 'email_address'.tr;
  String get _identityHint => _isNumberLogin ? 'please_enter_phone_number'.tr : 'enter_email_address'.tr;
  bool get _isPhoneIdentity => _forgetPasswordMethod != "email" && _isNumberLogin;
  TextInputType get _identityInputType => _isPhoneIdentity ? TextInputType.number : TextInputType.emailAddress;
  String get _identityNoun {
    if(_forgetPasswordMethod == "both"){
      return _isNumberLogin ? 'phone_number'.tr.toLowerCase() : 'email_address'.tr.toLowerCase();
    }
    return _forgetPasswordMethod == "email" ? 'email_address'.tr.toLowerCase() : 'phone_number'.tr.toLowerCase();
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
                  key: formKey,
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

                      Text('forgot_your_password'.tr, textAlign: TextAlign.center,
                        style: context.heading.extraLarge,
                      ),
                      const SizedBox(height: Dimensions.padding6),

                      Text('${"please_enter_your".tr} $_identityNoun ${"to_receive_a_verification_code".tr}', textAlign: TextAlign.center,
                        style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                      ),
                      const SizedBox(height: Dimensions.padding24),

                      if(_forgetPasswordMethod == "both") ...[
                        LoginMediumTabs(
                          isNumberLogin: _isNumberLogin,
                          onChanged: (value){
                            _identityController.clear();
                            toggleIsNumberLogin(value: value);
                          },
                        ),
                      ],

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
                              onCountryChanged: (countryCode) => countryDialCode = countryCode.dialCode!,
                              countryDialCode: _isPhoneIdentity ? countryDialCode : null,
                              title: _identityTitle,
                              hintText: _identityHint,
                              controller: _identityController,
                              focusNode: _identityFocus,
                              isShowBorder: true,
                              inputType: _identityInputType,
                              onChanged: (String text){
                                final numberRegExp = RegExp(r'^-?[0-9]+$');

                                if(text.isEmpty && _isNumberLogin){
                                  toggleIsNumberLogin();
                                }
                                if(text.startsWith(numberRegExp) && !_isNumberLogin ){
                                  toggleIsNumberLogin();
                                }
                                final emailRegExp = RegExp(r'@');
                                if(text.contains(emailRegExp) && _isNumberLogin){
                                  toggleIsNumberLogin();
                                }

                              },
                              onValidate: (String? value){

                                if(_isNumberLogin && (_forgetPasswordMethod == "phone" || _forgetPasswordMethod == "both") &&  PhoneVerificationHelper.getValidPhoneNumber(countryDialCode+value!) == ""){
                                  return "enter_valid_phone_number".tr;
                                }
                                if(_forgetPasswordMethod == "email" && !GetUtils.isEmail(value!)){
                                  return "enter_valid_email_address".tr;
                                }
                                return (GetUtils.isPhoneNumber(value!.tr) || GetUtils.isEmail(value.tr)) ? null : 'enter_email_or_phone'.tr;
                              },
                            ),
                            const SizedBox(height: Dimensions.padding20),

                            GetBuilder<AuthController>(builder: (authController) {
                              return CustomButton(
                                buttonText: 'get_otp'.tr,
                                isLoading: authController.isLoading,
                                onPressed: ()=> formKey.currentState!.validate() ? _forgetPass(countryDialCode,authController) : null,
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.padding20),
                    ]),
                  ),
                ),
              ),
            ]);
          });
        }),
      ),
    );
  }

  void _forgetPass(String countryDialCode,AuthController authController) async {
    String phone = PhoneVerificationHelper.getValidPhoneNumber(countryDialCode + _identityController.text.trim(), withCountryCode: true);
    String identity = phone !="" ? phone : _identityController.text.trim();

    var config = Get.find<SplashController>().configModel.content;
    SendOtpType  type = config?.firebaseOtpVerification == 1 && phone != "" ? SendOtpType.firebase : SendOtpType.forgetPassword;

    authController.sendVerificationCode(
      identity: identity,
      identityType: phone !="" ? "phone" : "email",
      type: type,
      fromPage: "forget-password",
      redirectUrl: widget.redirectUrl,
    ).then((status){

      if(status != null){
        if(status.isSuccess!){
          Get.toNamed(RouteHelper.getVerificationRoute(
            identity: identity,identityType: phone !="" ? "phone" : "email",
            fromPage: "forget-password",
            firebaseSession: type == SendOtpType.firebase ? status.message : null,
            redirectUrl: widget.redirectUrl,
          ));
        }else{
          customSnackBar(status.message.toString().capitalizeFirst ?? "" );
        }
      }
    });

    }

  void toggleIsNumberLogin ({bool? value, bool isUpdate = true}){
    if(_forgetPasswordMethod == "both"){
      if(isUpdate){
        setState(() {
          if(value == null){
            _isNumberLogin = !_isNumberLogin;
          }else{
            _isNumberLogin = value;
          }
        });
      }else{
        if(value == null){
          _isNumberLogin = !_isNumberLogin;
        }else{
          _isNumberLogin = value;
        }
      }
    } else if(_forgetPasswordMethod == "phone"){
      _isNumberLogin= true;
    }
  }
}
