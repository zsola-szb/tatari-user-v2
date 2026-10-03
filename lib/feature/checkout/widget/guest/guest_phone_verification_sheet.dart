import 'package:tatarigigs_user/common/widgets/confirmation_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class GuestPhoneVerificationSheet extends StatelessWidget {
  final SignUpBody userInfo;

  const GuestPhoneVerificationSheet({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return ConfirmationWidget(
      icon: Images.otp,
      iconSize: 100,
      title: 'need_to_verify_your_phone',
      subtitleWidget: Text.rich(
        TextSpan(
          style: context.body.defaultSize,
          children: <InlineSpan>[
            TextSpan(text: 'account_created_successfully_verify_your_phone'.tr),
            TextSpan(
              text: StringParser.obfuscateMiddle('${userInfo.phone}'),
              style: context.heading.defaultSize,
            ),
            TextSpan(text: 'you_can_skip_now_but_later'.tr),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      yesButtonColor: Theme.of(context).colorScheme.primary,
      yesButtonText: 'verify_now'.tr,
      noButtonText: 'not_now'.tr,
      onYesPressed: () => _sendVerificationCode(),
    );
  }

  Future<void> _sendVerificationCode() async {
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    final String identity = userInfo.phone ?? '';
    final SendOtpType type = config?.firebaseOtpVerification == 1 ? SendOtpType.firebase : SendOtpType.verification;

    final ResponseModel? status = await Get.find<AuthController>().sendVerificationCode(
      identity: identity,
      identityType: 'phone',
      type: type,
    );
    if (status == null) {
      return;
    }
    if (status.isSuccess != true) {
      customSnackBar(status.message.toString().capitalizeFirst);
      return;
    }

    Get.toNamed(
      RouteHelper.getVerificationRoute(
        identity: identity,
        identityType: 'phone',
        fromPage: config?.phoneVerification == 1 && config?.firebaseOtpVerification == 1 ? 'firebase-otp' : 'verification',
        firebaseSession: type == SendOtpType.firebase ? status.message : null,
      ),
    );
  }
}
