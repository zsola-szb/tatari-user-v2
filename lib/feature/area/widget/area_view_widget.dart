import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AreaViewWidget extends StatelessWidget {
  const AreaViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String? zoneId = Get.find<LocationController>().getUserAddress()?.zoneId!;
    return GetBuilder<ServiceAreaController>(
        builder: (serviceAreaController) {
          return serviceAreaController.zoneList == null  ? const AvailableAreaShimmer() :

          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: serviceAreaController.zoneList?.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(height: Dimensions.padding10),
            itemBuilder: (context, index) {
              ZoneModel zone = serviceAreaController.zoneList![index];
              bool isCurrentZone = zoneId == zone.id;

              return AreaListItem(
                zone: zone,
                isCurrentZone: isCurrentZone,
                onTap: () {
                  Get.toNamed(RouteHelper.getPickMapRoute("", true, 'false', zone, Get.find<LocationController>().getUserAddress()));
                },
              );
            },
          );
        }
    );
  }
}

class AreaListItem extends StatelessWidget {
  final ZoneModel zone;
  final bool isCurrentZone;
  final Function() onTap;

  const AreaListItem({super.key, required this.zone, required this.isCurrentZone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: onTap,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(zone.name ??"", style: isCurrentZone ? context.heading.defaultSize : context.subHeading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: Dimensions.padding4),

                Text('${zone.providersCount} ${'providers'.tr}', style: context.body.small),
              ]),
            ),
            const SizedBox(width: Dimensions.padding10),

            Text('view_on_map'.tr, style: context.body.small.overrideWith(color: Theme.of(context).colorScheme.primary)),
          ]),
        ),

        if(isCurrentZone) Positioned(
          top: -8, right: -4,
          child: Container(
            height: 24, width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.customThemeColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).cardColor, width: 2),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 13),
          ),
        ),
      ]),
    );
  }
}


class AvailableAreaShimmer extends StatelessWidget {
  const AvailableAreaShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: Dimensions.padding10),
        itemBuilder: (context, index) {
          return Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              color: Theme.of(context).cardColor,
              boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
            ),
          );
        },
      ),
    );
  }
}
