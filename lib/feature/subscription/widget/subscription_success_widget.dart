import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SubscriptionSuccessWidget extends StatelessWidget {
  const SubscriptionSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding20).copyWith(top: 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: Dimensions.padding16),

          Image.asset(
            Images.subscriptionIcon,
            height: 70,
            width: 70,
          ),
          const SizedBox(height: Dimensions.padding20),

          Text(
            "${'you_are_now_a_pro_member'.tr} \u{1F389}",
            style: context.heading.large,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.padding8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
            child: Text(
              'welcome_to_exclusive_benefits_and_savings'.tr,
              style: context.body.small,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.padding20)
        ]),
      ),
    );
  }
}
