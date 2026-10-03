import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class VerificationScreen extends StatefulWidget {
  final String? identity;
  final String fromPage;
  final String identityType;
  final String? firebaseSession;
  final String? redirectRoute;
  const VerificationScreen({super.key, this.identity, required this.fromPage, required this.identityType, this.firebaseSession, this.redirectRoute});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {

  String? _identity;
  Timer? _timer;
  int? _seconds = 0;
  final pinCodeController = PinInputController();

  @override
  void initState() {
    super.initState();
    if(widget.identityType == "phone" && !widget.identity!.startsWith('+')){
      _identity = '+${widget.identity!.substring(1, widget.identity!.length)}';
    } else{
      _identity = widget.identity;
    }

    // Reset wrong OTP status when screen initializes
    Get.find<AuthController>().setWrongOtpSubmitted(false);

    _startTimer();
  }

  void _startTimer() {
    _seconds = Get.find<SplashController>().configModel.content?.resentOtpTime?? 60 ;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  String _formatDuration(int totalSeconds) {
    return totalSeconds >= 60 ? '${(totalSeconds / 60).ceil()} min' : '$totalSeconds sec';
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    final horizontalPadding = ResponsiveHelper.isTab(context) ? Dimensions.webMaxWidth / 5.5 : Dimensions.padding20;

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,

        body: GetBuilder<AuthController>(builder: (authController) {

          final isDemo = Get.find<SplashController>().configModel.content?.appEnvironment == "demo";

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.padding32),

                const AuthScreenHeader(exitFromApp: false),
                const SizedBox(height: Dimensions.padding24),

                Text('verification'.tr, textAlign: TextAlign.center,
                  style: context.heading.extraLarge,
                ),
                const SizedBox(height: Dimensions.padding6),

                isDemo ? Text('for_demo_purpose'.tr, textAlign: TextAlign.center,
                  style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                ) : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                    children: [
                      TextSpan(text: 'we_have_sent_a_verification_code_to'.tr),
                      TextSpan(text: StringParser.obfuscateMiddle(_identity??""), style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor)),

                      // TextSpan(text: ' ${'otp_will_be_expire'.tr} ${_formatDuration(Get.find<SplashController>().configModel.content?.resentOtpTime ?? 60)}.'),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.padding24),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius16),
                      color: Theme.of(context).cardColor
                  ),
                  padding: EdgeInsets.all(Dimensions.padding20),
                  child: Column(children: [
                    Center(
                      child: MaterialPinField(
                        length: 6,
                        keyboardType: TextInputType.number,
                        pinController: pinCodeController,
                        theme: MaterialPinTheme(
                            cellSize: Size(ResponsiveHelper.isMobile(context) ? width/9 : 60, ResponsiveHelper.isMobile(context) ? width/9 : 60),
                            borderWidth: 0.5,
                            animationDuration: const Duration(milliseconds: 300),
                            textStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),
                            errorBorderWidth: 0.5,
                            borderRadius: BorderRadius.circular(Dimensions.radius6),
                            focusedFillColor: Get.isDarkMode ? Colors.grey.withValues(alpha: 0.6) : Colors.white,
                            borderColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            focusedBorderColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            filledBorderColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            followingBorderColor: authController.isWrongOtpSubmitted ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            errorBorderColor: Theme.of(context).colorScheme.error
                        ),
                        onChanged: authController.updateVerificationCode,
                      ),
                    ),

                    authController.isWrongOtpSubmitted ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.padding10),
                      child: Text('incorrect_otp'.tr,
                        style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ) : const SizedBox(),
                    const SizedBox(height: Dimensions.padding20),

                    CustomButton(
                      buttonText: 'verify_and_continue'.tr,
                      isLoading: authController.isLoading,
                      onPressed: (authController.verificationCode.length == 6 && !authController.isResendLoading) ? (){
                        _otpVerify(_identity!,widget.identityType, authController.verificationCode,authController);
                      } : null,
                    ),
                    const SizedBox(height: Dimensions.padding16),

                    (widget.identity != null && widget.identity!.isNotEmpty) ? Center(
                      child: authController.isResendLoading ?
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('resending'.tr, style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).primaryColor.withValues(alpha: 0.8))),
                        const SizedBox(width: Dimensions.padding10),

                        SizedBox(
                          height: Dimensions.fontSizeDefault,
                          width: Dimensions.fontSizeDefault,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ]) :
                      _seconds! < 1 ?
                      Column(children: [
                        Text('did_not_receive_the_code'.tr, style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),

                        TextButton(
                          onPressed: () {
                            var config = Get.find<SplashController>().configModel.content;
                            SendOtpType  type = config?.firebaseOtpVerification == 1 && widget.identityType == "phone"
                                ? SendOtpType.firebase : (widget.fromPage == "verification" || widget.fromPage == "otp-login") ? SendOtpType.verification : SendOtpType.forgetPassword;

                            authController.sendVerificationCode(identity: _identity!, identityType: widget.identityType, type: type, isResend: true, checkUser: widget.fromPage == "otp-login" ? 0 : 1).then((status){
                              if(status !=null){
                                if (status.isSuccess!) {
                                  _startTimer();
                                  customSnackBar('resend_code_successful'.tr, type : ToasterMessageType.success);
                                } else {
                                  customSnackBar(status.message);
                                }
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('resend_code'.tr, style: context.heading.small.overrideWith(color: context.customThemeColors.info)),
                        )
                      ]) :
                      Text(
                        '${'resend_code_in'.tr} ${_formatDuration(_seconds!)}',
                        style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
                      ),
                    ) : const SizedBox(),
                  ]),
                )
              ],
            ),
          );
        }),
      ),
    );
  }


  void _otpVerify(String identity,String identityType,String otp, AuthController authController) async {

    if(widget.fromPage == "verification" || widget.fromPage == "profile"){
      authController.verifyOtpForVerificationScreen(
        identity: identity,
        identityType: identityType,
        otp: otp,
        fromPage: widget.fromPage,
        redirectUrl: widget.redirectRoute,
      );
    }else if(widget.fromPage == "otp-login"){
      authController.verifyOtpForPhoneOtpLogin(phone:  identity, otp: otp, redirectUrl: widget.redirectRoute);
    }
    else if(widget.fromPage == "firebase-otp" || (widget.fromPage == "forget-password" && identityType == "phone") && (widget.firebaseSession ?? '').isNotEmpty){
      authController.verifyOtpForFirebaseOtp(
        session: widget.firebaseSession,
        phone: identity,
        code: otp,
        fromPage: widget.fromPage,
        redirectUrl: widget.redirectRoute,
      );
    }else{
      authController.updateForgetPasswordUrlSessionExpiredStatus(status: false);
      authController.verifyOtpForForgetPasswordScreen(identity,identityType,otp).then((status) async {
        if (status.isSuccess!) {
          Get.offNamed(RouteHelper.getChangePasswordRoute(body: ForgetPasswordBody(
            identity: identity,
            identityType: identityType,
            otp: otp,
            fromUrl: 0,
          ), redirectUrl: widget.redirectRoute));
        }else {
          pinCodeController.triggerError();
          customSnackBar(status.message.toString().capitalizeFirst);
        }
      });
    }
  }
}
