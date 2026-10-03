import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointTopCard extends StatelessWidget {
  const LoyaltyPointTopCard({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyPointController>(builder: (loyaltyPointController){
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(Dimensions.padding16),
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.85)],
          ),
        ),
        child: Row(children: [
          Image.asset(Images.myPoint, width: 32, height: 32),
          const SizedBox(width: Dimensions.padding12),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('your_loyalty_point'.tr, style: context.body.small.overrideWith(color: Theme.of(context).cardColor)),
              const SizedBox(height: Dimensions.padding4),

              Directionality(textDirection: TextDirection.ltr,
                child: Text(loyaltyPointController.loyaltyPointModel?.content?.loyaltyPoint?.toStringAsFixed(0) ?? "0",
                  style: context.heading.large.overrideWith(color: Theme.of(context).cardColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),

          const SizedBox(width: Dimensions.padding10),

          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radiusFull),
            onTap: (){
              Get.bottomSheet(
                const ConvertLoyaltyPointBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(Dimensions.padding10),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radius8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Images.convertPoint, width: 16, height: 16, color: context.customThemeColors.textColor),
                const SizedBox(width: Dimensions.padding6),

                Text('convert_point'.tr, style: context.subHeading.small),
              ]),
            ),
          ),
        ]),
      );
    });
  }
}
