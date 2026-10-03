import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderListItemView extends StatelessWidget {
  final  bool fromHomePage;
  final ProviderData providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final int index;
  const NearbyProviderListItemView({super.key, this.fromHomePage = true, required this.providerData, required this.index, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    final String companyAddress = providerData.address ?? '';

    return GetBuilder<NearbyProviderController>(builder: (providerBookingController){
      return Padding(padding:EdgeInsets.symmetric(
          horizontal: Dimensions.padding8,
          vertical: fromHomePage ? 0:Dimensions.padding8),

        child: OnHover(
          isItem: true,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radius12),
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.all(Dimensions.padding16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                      child: Stack( children: [
                        CustomImage(height: 70, width: 70, fit: BoxFit.cover,
                          image: providerData.logoFullPath ?? "" , placeholder: Images.userPlaceHolder,
                        ),
                        if(providerData.isAvailable == false) Positioned.fill(child: Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'unavailable'.tr, style: context.subHeading.small.copyWith(
                                fontSize: Dimensions.fontSizeSmall -1,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ))
                      ]),
                    ),

                    const SizedBox(width: Dimensions.padding16),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                        Row(children: [
                          Flexible(
                            child: Text(providerData.name ?? "", style: context.subHeading.defaultSize.copyWith(
                              fontWeight: AppWeight.medium,
                              fontSize: Dimensions.fontSizeDefault + 1,
                            ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if(providerData.isVerified ?? false)...[
                            const SizedBox(width: Dimensions.padding10),
                            Image.asset(Images.verified, height: 15, width: 15),
                          ],

                          const SizedBox(width: Dimensions.padding24,)
                        ]),
                        Row(children: [
                          SizedBox(height: 20,
                            child: Row(children: [

                              Image(image: AssetImage(Images.starIcon), color: Theme.of(context).colorScheme.secondary),
                              Gaps.horizontalGapOf(3),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  providerData.rating!.toStringAsFixed(2),
                                  style: context.body.small,
                                ),
                              ),
                            ]),
                          ),
                          Gaps.horizontalGapOf(5),
                          Directionality(textDirection: TextDirection.ltr,
                            child: Text(
                              "(${providerData.ratingCount})",
                              style: context.body.small,
                            ),
                          )],
                        ),
                        if(companyAddress.isNotEmpty) Text(companyAddress,
                          style: context.body.small,
                          overflow: TextOverflow.ellipsis, maxLines: 1,
                        ),

                        const SizedBox(height: Dimensions.padding3),

                        Row(children: [
                          Image.asset(Images.distance, height:12),
                          const SizedBox(width: Dimensions.padding6),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Flexible(
                              child: Text("${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                                style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                        ],)
                      ]),
                    ),
                  ]),
                ]),
              ),

              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(RouteHelper.getProviderDetails(providerData.id!));
              })),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: providerData.isFavorite,
                  providerId: providerData.id,
                  signInShakeKey: signInShakeKey,
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}