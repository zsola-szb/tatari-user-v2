import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class HomeRecommendProvider extends StatelessWidget {
  final double height;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const HomeRecommendProvider({super.key, required this.height, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
      builder: (providerBookingController){
        final int providerCount = providerBookingController.providerList?.length ?? 0;
        final bool showSeeAll = providerCount > 7;

        return providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ? SizedBox(
          height: height,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding10, Dimensions.padding16, Dimensions.padding10),
              child: TitleWidget(
                title:'recommended_experts_for_you'.tr,
                isShowSeeAllButton: false,
              ),
            ),

            Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                itemCount: providerCount + (showSeeAll ? 1 : 0),
                separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding16),
                itemBuilder: (context, index){
                  if(showSeeAll && index == providerCount){
                    return SeeAllCircularListItem(
                      padding: EdgeInsets.zero,
                      onTap: () => Get.toNamed(RouteHelper.getAllProviderRoute()),
                    );
                  }
                  ProviderData providerData = providerBookingController.providerList![index];
                  return SizedBox(
                    width: ResponsiveHelper.isTab(context) ? Get.width / 2.5 : Get.width / 1.3,
                    child: ProviderCard(
                      coverImage: providerData.coverImageFullPath,
                      providerImage: providerData.logoFullPath,
                      companyName: providerData.name ?? '',
                      isVerified: providerData.isVerified ?? false,
                      serviceTypeTags: providerData.categoryNames,
                      avgRating: providerData.rating ?? 0,
                      ratingCount: providerData.ratingCount ?? 0,
                      distanceKm: providerData.distance,
                      totalServiceServed: providerData.totalCompletedServices,
                      isAvailable: providerData.serviceAvailability == 1,
                      isFavorite: providerData.isFavorite == 1,
                      providerId: providerData.id,
                      onTap: () => Get.toNamed(RouteHelper.getProviderDetails(providerData.id!)),
                    ),
                  );
                },
              ),
            ),
          ]),
        ) :  providerBookingController.providerList != null && providerBookingController.providerList!.isEmpty ? const SizedBox() :
         HomeRecommendedProviderShimmer(height: height,);

    });
  }
}

class HomeRecommendedProviderShimmer extends StatelessWidget {
  final double height;
  const HomeRecommendedProviderShimmer({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding10, Dimensions.padding16, Dimensions.padding10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Container(height: 15, width: 180, color: Theme.of(context).shadowColor),
              Container(height: 15, width: 60, color: Theme.of(context).shadowColor),
            ],),
          ),

          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              itemCount: 6,
              separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding10),
              itemBuilder: (context, index){
                return SizedBox(
                  width: ResponsiveHelper.isTab(context) ? Get.width / 2.5 : Get.width / 1.5,
                  child: Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(seconds: 1),
                    enabled: true,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        height: 160, width: double.infinity,
                        decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(Dimensions.radius12)),
                      ),
                      const SizedBox(height: Dimensions.padding10),
                      Container(height: 15, width: 150, color: Theme.of(context).shadowColor),
                      const SizedBox(height: Dimensions.padding6),
                      Container(height: 12, width: 180, color: Theme.of(context).shadowColor),
                      const SizedBox(height: Dimensions.padding10),
                      Container(height: 12, width: 120, color: Theme.of(context).shadowColor),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
