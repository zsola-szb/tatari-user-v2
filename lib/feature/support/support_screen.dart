import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SupportScreen extends StatelessWidget {

  const SupportScreen({super.key}) ;
  @override
  Widget build(BuildContext context) {

    final String phone = Get.find<SplashController>().configModel.content!.businessPhone.toString();
    final String emailAddress = Get.find<SplashController>().configModel.content!.businessEmail.toString();

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: 'help_&_support'.tr),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20, horizontal: Dimensions.padding20),
          child: Column(children: [
            Image.asset(Images.helpAndSupport, width: 140, height: 120),
            const SizedBox(height: Dimensions.padding16),

            Text('contact_for_support'.tr, style: context.heading.large),
            const SizedBox(height: Dimensions.padding8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: Text(
                'we_are_here_to_help_contact_our_support'.tr,
                textAlign: TextAlign.center,
                style: context.body.small,
              ),
            ),
            const SizedBox(height: Dimensions.padding24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.padding16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Column(children: [
                SupportContactSection(
                  title: 'call_our_customer_support'.tr,
                  subtitle: 'contact_us_through_our_customer_care_number'.tr,
                  contactInfo: phone,
                  icon: Icons.call,
                  onTap: () async => await launchUrl(Uri(scheme: 'tel', path: phone)),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
                  child: Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
                ),

                SupportContactSection(
                  title: 'send_us_email_through'.tr,
                  subtitle: 'typically_the_support_team_send_you_any_feedback'.tr,
                  contactInfo: emailAddress,
                  icon: Icons.email_outlined,
                  onTap: () async => await launchUrl(Uri(scheme: 'mailto', path: emailAddress)),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}


class SupportContactSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String contactInfo;
  final IconData icon;
  final VoidCallback onTap;

  const SupportContactSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.contactInfo,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: context.heading.defaultSize.overrideWith(fontWeight: FontWeight.w500)),
      const SizedBox(height: Dimensions.padding4),

      Text(subtitle, style: context.body.small),
      const SizedBox(height: Dimensions.padding12),

      Row(children: [
        Icon(icon, size: 16, color: context.customThemeColors.textColor),
        const SizedBox(width: Dimensions.padding8),

        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(contactInfo, style: context.heading.defaultSize),
          ),
        ),
        const SizedBox(width: Dimensions.padding10),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
          child: Container(
            width: 36, height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
      ]),
    ]);
  }
}
