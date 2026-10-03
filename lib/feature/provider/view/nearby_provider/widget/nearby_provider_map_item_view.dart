import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderMapItemView extends StatelessWidget {
  final ProviderData providerData;
  final int index;
  final GoogleMapController? googleMapController;
  const NearbyProviderMapItemView({super.key,  required this.providerData, required this.index, this.googleMapController}) ;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<NearbyProviderController>(builder: (exploreProviderController){
      return Padding(padding: const EdgeInsets.all(5.0),
        child: OnHover(
          isItem: true,
          borderRadius: 15,
          child: Stack(
            children: [

              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radius12),
                  border: Border.all(
                    color: exploreProviderController.selectedProviderIndex == index ?
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.all(Dimensions.padding16),
                child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                      child: CustomImage(height: 60, width: 60, fit: BoxFit.cover,
                        image: providerData.logoFullPath ??"",
                        placeholder: Images.userPlaceHolder,
                      ),
                    ),

                    const SizedBox(width: Dimensions.padding16),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(
                            children: [
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
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.padding3),

                        Row(children: [
                          SizedBox(height: 20,
                            child: Row(children: [

                              Image(image: AssetImage(Images.starIcon)),
                              Gaps.horizontalGapOf(3),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  providerData.rating!.toStringAsFixed(2),
                                  style: context.subHeading.small,
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

                        const SizedBox(height: Dimensions.padding3),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(children: [
                            Image.asset(Images.distance, height:12),
                            const SizedBox(width: Dimensions.padding6,),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Flexible(
                                child: Text("${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                                  style: context.subHeading.small.copyWith(fontWeight: AppWeight.medium, fontSize: Dimensions.fontSizeSmall - 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ]),
                        )
                      ],),
                    ),


                  ],),

                  const SizedBox(height: Dimensions.padding10,),

                  Row(children: [
                    Expanded(child: ProviderInfoButton(title: "${providerData.categoryNames.length}", subtitle: "categories".tr,)),
                    const SizedBox(width: Dimensions.padding10,),
                    Expanded(child: ProviderInfoButton(title: "${providerData.totalCompletedServices}", subtitle: "services_provided".tr,)),

                  ],)

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () async {
                if(index != exploreProviderController.selectedProviderIndex){
                  exploreProviderController.selectedProviderIndex = index;
                  exploreProviderController.update();
                  _animateCamera(googleMapController,providerData);

                  await exploreProviderController.scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
                  await exploreProviderController.scrollController!.highlight(index);

                }else{
                  Get.toNamed(RouteHelper.getProviderDetails(providerData.id!));
                }
              }, borderRadius: 15,),),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: providerData.isFavorite,
                  providerId:  providerData.id,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _animateCamera(GoogleMapController? googleMapController, ProviderData providerData){
    googleMapController?.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(providerData.coordinates?.latitude ?? 23.00, providerData.coordinates?.longitude ?? 90.00), zoom: 16),
    ));
    googleMapController?.showMarkerInfoWindow(MarkerId("$index"));
  }
}





class ProviderInfoButton extends StatelessWidget {
  final String? title;
  final String subtitle;
  const ProviderInfoButton({super.key, this.title, required this.subtitle}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        color: Theme.of(context).hintColor.withValues(alpha: 0.05),
      ),
      padding: const EdgeInsets.all(Dimensions.padding3 ),
      child: Column(children: [
        Text("$title", style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),),
        Text(subtitle, style: context.body.small.copyWith(fontSize: Dimensions.fontSizeSmall - 2)),
        const SizedBox(height: 3,)
      ],),
    );
  }
}

