import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SubscriptionExpireReminderWidget extends StatelessWidget {
  const SubscriptionExpireReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webMaxWidth,
      padding: const EdgeInsets.all(Dimensions.padding20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  height: 24, width: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70.withValues(alpha: 0.6),
                    boxShadow: Get.isDarkMode ? null : [
                      BoxShadow(color: Colors.grey[300]!, blurRadius: 2, spreadRadius: 1),
                    ],
                  ),
                  child: Icon(Icons.close, color: Theme.of(context).hintColor, size: 18),
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.padding16),

          Text(
            '\u{1F514}',
            style: const TextStyle(fontSize: 60),
          ),

          const SizedBox(height: Dimensions.padding24),

          Text(
            'renew_your_subscription'.tr,
            style: context.heading.extraLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: Dimensions.padding10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Text(
              'subscription_expire_reminder_body'.tr,
              style: context.body.defaultSize,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: Dimensions.padding10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Text(
              'subscription_expire_skip_hint'.tr,
              style: context.body.small,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: Dimensions.padding24),

          CustomButton(
            buttonText: 'renew_subscription'.tr,
            onPressed: () {
              Get.back();
              Get.toNamed(RouteHelper.getSubscriptionRoute());
            },
          ),

          const SizedBox(height: Dimensions.padding16),
        ],
      ),
    );
  }
}
