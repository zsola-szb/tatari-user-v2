import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutTermsAgreementBox extends StatefulWidget {
  const CheckoutTermsAgreementBox({super.key});

  @override
  State<CheckoutTermsAgreementBox> createState() => _CheckoutTermsAgreementBoxState();
}

class _CheckoutTermsAgreementBoxState extends State<CheckoutTermsAgreementBox> {
  late final TapGestureRecognizer _privacyTap;
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _refundTap;

  @override
  void initState() {
    super.initState();
    _privacyTap = TapGestureRecognizer()
      ..onTap = () => Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
    _termsTap = TapGestureRecognizer()
      ..onTap = () => Get.toNamed(RouteHelper.getTermsAndConditionsRoute());
    _refundTap = TapGestureRecognizer()
      ..onTap = () => Get.toNamed(RouteHelper.getRefundPolicyRoute());
  }

  @override
  void dispose() {
    _privacyTap.dispose();
    _termsTap.dispose();
    _refundTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle linkStyle = context.heading.small.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: context.customThemeColors.textColor,
    );

    return CheckoutInfoBox(
      child: Text.rich(
        TextSpan(
          style: context.subHeading.small,
          children: <InlineSpan>[
            TextSpan(text: '${'i_agree_with_the'.tr.trim()} '),
            TextSpan(text: 'privacy_policy'.tr,
              style: linkStyle,
              recognizer: _privacyTap,
            ),
            const TextSpan(text: ', '),
            TextSpan(text: 'terms_and_conditions'.tr,
              style: linkStyle,
              recognizer: _termsTap,
            ),
            TextSpan(text: ' ${'and'.tr} '),
            TextSpan(text: 'refund_policy'.tr,
              style: linkStyle,
              recognizer: _refundTap,
            ),
          ],
        ),
      ),
    );
  }
}
