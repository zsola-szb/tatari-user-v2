import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PopularServicesInitSection extends StatefulWidget {
  const PopularServicesInitSection({super.key});

  @override
  State<PopularServicesInitSection> createState() => _PopularServicesInitSectionState();
}

class _PopularServicesInitSectionState extends State<PopularServicesInitSection> {
  @override
  void initState() {
    super.initState();
    Get.find<ServiceController>().getPopularServiceList(1, false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(builder: (serviceController){
      final List<Service>? popularServiceList = serviceController.popularServiceList;

      if(popularServiceList != null && popularServiceList.isEmpty){
        return const SizedBox();
      }

      final double itemWidth = ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.3;

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Text('popular_services'.tr, style: heading.extraLarge.strong),
        ),
        const SizedBox(height: Dimensions.padding16,),

        SizedBox(
          height: ServiceWidgetVertical.heightFor(context, itemWidth),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            itemCount: popularServiceList == null ? 6 : popularServiceList.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(right: Dimensions.padding10 + 2),
                child: SizedBox(
                  width: itemWidth,
                  child: popularServiceList == null
                      ? const ServiceShimmer(isEnabled: true, hasDivider: false)
                      : ServiceWidgetVertical(service: popularServiceList[index], fromType: '', fromPage: 'popular_services'),
                ),
              );
            },
          ),
        ),

      ]);
    });
  }
}
