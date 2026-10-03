import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.customThemeColors.secondaryTextColor;
    final linkColor = Theme.of(context).colorScheme.primary;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${'by_continuing_you_agree_to_our'.tr} ', style: context.subHeading.small.overrideWith(color: textColor)),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getTermsAndConditionsRoute()),
          child: Text('terms_and_conditions'.tr, style: context.heading.small.copyWith(
            color: linkColor, decoration: TextDecoration.underline,
          )),
        ),
        Text(' ${'and'.tr} ', style: context.subHeading.small.overrideWith(color: textColor)),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getPrivacyPolicyRoute()),
          child: Text('privacy_policy'.tr, style: context.heading.small.copyWith(
            color: linkColor, decoration: TextDecoration.underline,
          )),
        ),
      ],
    );
  }
}
