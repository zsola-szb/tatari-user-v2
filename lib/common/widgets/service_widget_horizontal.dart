import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class ServiceWidgetHorizontal extends StatelessWidget {
  final List<Service> serviceList;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;
  final bool showIsFavoriteButton;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;

  const  ServiceWidgetHorizontal({super.key,
    required this.serviceList,
    required this.index,
    required this.discountAmount,
    required this.discountAmountType,
    this.showIsFavoriteButton = true, this.signInShakeKey,
  }) ;

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice = false;
    showDiscountedPrice = ((serviceList[index].lowestPrice ?? 0) > (serviceList[index].discountedLowestPrice ?? 0));


    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:  Dimensions.padding8, vertical: Dimensions.padding6),
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return OnHover(
          isItem: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor ,
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                  boxShadow:  Get.find<ThemeController>().darkTheme ? null : cardShadow,
                  border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal : Dimensions.padding16, vertical: 10),
                child: Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius6),
                        child: CustomImage(
                          image: '${serviceList[index].thumbnailFullPath}',
                          height: 100, width: 100, fit: BoxFit.cover,
                        ),
                      ),

                      showDiscountedPrice ? Align(alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius6),
                              bottomRight: Radius.circular(Dimensions.radius12),
                            ),
                          ),
                          child: Text('${serviceList[index].maximumDiscount}',
                            style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ) : const SizedBox(),
                    ],
                  ),

                  const SizedBox(width: Dimensions.padding10,),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              serviceList[index].name ?? "",
                              style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Dimensions.padding24,),
                        ],
                      ),
                      const SizedBox(height: Dimensions.padding6),
                      RatingBar(
                        rating: double.parse(serviceList[index].avgRating.toString()), size: 15,
                        ratingCount: serviceList[index].ratingCount,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: Dimensions.padding6),
                      Text(serviceList[index].shortDescription ?? "",
                        style: context.body.small,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Dimensions.padding6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("starts_from".tr,style: context.body.small,),

                          Column(
                              children: [
                                if(showDiscountedPrice)
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${PriceConverter.convertPrice(serviceList[index].lowestPrice)} ",
                                      style: context.subHeading.small.copyWith(
                                        color: Theme.of(context).colorScheme.error.withValues(alpha: .8),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),

                                showDiscountedPrice ?
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(PriceConverter.convertPrice(serviceList[index].discountedLowestPrice,
                                      discount: discountAmount!.toDouble(),
                                      discountType: discountAmountType
                                  ),
                                    style: context.heading.large.overrideWith(
                                        color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                  ),
                                ): Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(PriceConverter.convertPrice(serviceList[index].lowestPrice),
                                    style: context.heading.large.overrideWith(
                                        color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ]
                          ),


                        ],
                      ),
                    ]),
                  ),

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(
                  RouteHelper.getServiceRoute(serviceController.recommendedServiceList![index].slug!),
                  arguments: ServiceDetailsScreen(serviceID: serviceController.recommendedServiceList![index].slug!),
                );
              })),

              if(showIsFavoriteButton)Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: serviceList[index].isFavorite,
                  serviceId: serviceList[index].id!,
                  signInShakeKey: signInShakeKey,

                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}





