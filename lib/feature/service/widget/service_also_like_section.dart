import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceAlsoLikeSection extends StatelessWidget {
  const ServiceAlsoLikeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceDetailsController>(
      builder: (serviceDetailsController) {
        final List<Service> services = serviceDetailsController.relatedServices;

        if(services.isEmpty){
          return const SizedBox.shrink();
        }

        final double itemWidth = ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.3;

        return Container(
          color: context.customThemeColors.backGroundColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Text('services_you_will_also_like'.tr, style: context.heading.extraLarge.strong),
              ),
              Gaps.verticalGapOf(Dimensions.padding12),

              SizedBox(
                height: ServiceWidgetVertical.heightFor(context, itemWidth) + (Dimensions.padding6 * 2),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding6),
                  itemCount: services.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Dimensions.padding12),
                  itemBuilder: (context, index) => SizedBox(
                    width: itemWidth,
                    child: ServiceWidgetVertical(service: services[index], fromType: ''),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}