import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ExploreProviderCard extends StatelessWidget {
  final bool showShimmer;
  const ExploreProviderCard({super.key, required this.showShimmer});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (providerBookingController){
      return (showShimmer || providerBookingController.providerList == null ) ? const ExploreProviderCardShimmer() :

      providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ? ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        child: Material(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: Get.isDarkMode ? 0.15 : 0.08),
          child: InkWell(
            onTap: () => Get.toNamed(RouteHelper.getNearByProviderScreen(tabIndex: 1)),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                    child: Image.asset(Images.exploreProvider, height: 50, width: 50, fit: BoxFit.cover,),
                  ),
                  const SizedBox(width: Dimensions.padding12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("explore_nearby_providers".tr, style: context.heading.defaultSize,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimensions.padding4),
                        Text("find_services_just_near_you".tr, style: context.body.defaultSize,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding8),
                  Icon(Get.find<LocalizationController>().isLtr ? Icons.arrow_forward : Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary, size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ) : const SizedBox();
    });
  }
}

class ExploreProviderCardShimmer extends StatelessWidget {
  const ExploreProviderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 15, width: 150, color: Theme.of(context).shadowColor),
                  const SizedBox(height: Dimensions.padding4),
                  Container(height: 12, width: 120, color: Theme.of(context).shadowColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

