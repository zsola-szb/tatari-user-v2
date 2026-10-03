import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderItemView extends StatelessWidget {
  final  bool fromHomePage;
  final ProviderData providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final int index;
  const ProviderItemView({super.key, this.fromHomePage = true, required this.providerData, required this.index, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    final String companyAddress = providerData.address ?? '';

    return GetBuilder<ProviderBookingController>(builder: (providerBookingController){
      return Padding(padding:EdgeInsets.symmetric(
          horizontal: Dimensions.padding8,
          vertical: fromHomePage?0:Dimensions.padding8),

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
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                      child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                        image: providerData.logoFullPath ?? "" , placeholder: Images.userPlaceHolder,
                      ),
                    ),

                    const SizedBox(width: Dimensions.padding10),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                        Row(children: [
                          Flexible(
                            child: Text(providerData.name??"", style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          if(providerData.isVerified ?? false)...[
                            const SizedBox(width: Dimensions.padding10),

                            Image.asset(Images.verified, height: 15, width: 15),
                          ],


                          const SizedBox(width: Dimensions.padding24,)
                        ]),

                        Row(children: [
                          RatingBar(rating: providerData.rating, color: Theme.of(context).colorScheme.secondary),
                          Gaps.horizontalGapOf(5),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: context.subHeading.defaultSize.overrideWith(
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                          ),
                        ],
                        ),
                      ],),
                    ),
                  ],),

                  const SizedBox(height: Dimensions.padding10),
                  if(companyAddress.isNotEmpty) Text(companyAddress,
                    style: context.body.small,
                    overflow: TextOverflow.ellipsis, maxLines: 1,
                  ),
                  const SizedBox(height: Dimensions.padding3),

                  Row(children: [
                    Image.asset(Images.distance, height:12,),
                    const SizedBox(width: Dimensions.padding6),
                    Flexible(
                      child: Text("${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                        style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ])
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