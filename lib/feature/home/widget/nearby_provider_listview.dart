import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderListview extends StatelessWidget {
  final double height;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const NearbyProviderListview({super.key, required this.height, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(
        builder: (providerBookingController){
          final int providerCount = providerBookingController.providerList?.length ?? 0;
          final bool showSeeAll = providerCount > 7;

          return providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ? Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Get.isDarkMode
                    ? [context.customThemeColors.secondaryBackGroundColor, Theme.of(context).scaffoldBackgroundColor]
                    : const [Color(0xFFF1F6FD), Color(0xFFFFFFFF)],
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding32, Dimensions.padding16, Dimensions.padding10),
                child: TitleWidget(
                  title:'providers_near_you'.tr,
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
                        onTap: () => Get.toNamed(RouteHelper.getNearByProviderScreen(tabIndex: 0)),
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
