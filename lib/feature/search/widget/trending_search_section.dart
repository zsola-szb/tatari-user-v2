import 'dart:math';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class TrendingSearchSection extends StatefulWidget {
  const TrendingSearchSection({super.key});

  @override
  State<TrendingSearchSection> createState() => _TrendingSearchSectionState();
}

class _TrendingSearchSectionState extends State<TrendingSearchSection> {
  @override
  void initState() {
    super.initState();
    Get.find<ServiceController>().getRecommendedSearchList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      builder: (serviceController){

        if(serviceController.recommendedSearchList != null && serviceController.recommendedSearchList!.isEmpty){
          return const SizedBox();
        }

        return GetBuilder<AllSearchController>(builder: (searchController){
          final bool hasRecentSearch = searchController.historyList != null && searchController.historyList!.isNotEmpty;


          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.padding16).copyWith(top: hasRecentSearch ? Dimensions.padding16 : Dimensions.padding6),
            decoration: BoxDecoration(
              color: context.customThemeColors.backGroundColor,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('trending_searches'.tr, style: heading.extraLarge.strong),
              const SizedBox(height: Dimensions.padding16,),

              serviceController.recommendedSearchList == null ? const TrendingSearchShimmer() :
              Wrap(
                spacing: Dimensions.padding10,
                runSpacing: Dimensions.padding10,
                children: [for (int index = 0; index < serviceController.recommendedSearchList!.length; index++)
                  InkWell(
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      Get.toNamed(RouteHelper.getSearchResultRoute(queryText: serviceController.recommendedSearchList?[index].name??''));
                      Get.find<AllSearchController>().populatedSearchController(serviceController.recommendedSearchList?[index].name??'');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
                        color: Theme.of(context).cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
                      child: Text(
                        serviceController.recommendedSearchList?[index].name??"",
                        style: context.subHeading.small,
                      ),
                    ),
                  ),
                ],
              ),

            ]),
          );
        });
    });
  }
}

class TrendingSearchShimmer extends StatelessWidget {
  const TrendingSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Dimensions.padding10,
      runSpacing: Dimensions.padding10,
      children: List.generate(8, (index) {
        return Shimmer(
          duration: const Duration(seconds: 3),
          interval: const Duration(seconds: 5),
          color: Theme.of(context).colorScheme.surface,
          colorOpacity: 0,
          enabled: true,
          child: Container(
            width: (Random().nextInt(80) + 70),
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: context.customThemeColors.backGroundColor,
            ),
          ),
        );
      }),
    );
  }
}
