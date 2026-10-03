import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderBiddingNotificationDialog extends StatelessWidget {
  final ProviderOfferData providerOfferData;
  final String postId;
  const ProviderBiddingNotificationDialog({super.key, required this.providerOfferData, required this.postId}) ;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: Dimensions.padding20,vertical: 40),
      child: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: GestureDetector(
            onTap: (){
              Get.back();
              Get.bottomSheet(
                ProviderOfferDetailsSheet(postId: postId, providerOfferData: providerOfferData),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
            child: Column(mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radius12),
                   color: Theme.of(context).cardColor,
                 ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.padding16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(child: const Row(mainAxisAlignment: MainAxisAlignment.end,children: [Icon(Icons.highlight_remove,size: 20,)]),
                            onTap: ()=>Get.back(),
                          ),
                          Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radius6),
                              child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                                image: providerOfferData.provider?.logoFullPath??"",
                              ),
                            ),

                            const SizedBox(width: Dimensions.padding10,),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                                Text(providerOfferData.provider?.name??"", style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: Dimensions.padding6),
                                Row(
                                  children: [
                                    Icon(Icons.star,color: Theme.of(context).colorScheme.primary,size: 10,),
                                    Directionality(textDirection: TextDirection.ltr,
                                      child: Text(" ${providerOfferData.provider?.rating.toString()??"" }",style: context.subHeading.small.overrideWith(
                                        fontWeight: AppWeight.medium,
                                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
                                      ),),
                                    ),
                                    const SizedBox(width: Dimensions.padding10,),
                                    InkWell(
                                      child: Text('${providerOfferData.provider?.ratingCount??"0"} ${'reviews'.tr}', style: context.subHeading.small.overrideWith(
                                        fontWeight: AppWeight.medium,
                                        color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
                                      )),
                                    ),

                                  ],
                                ),
                                const SizedBox(height: Dimensions.padding6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("price_offered".tr,style: context.subHeading.small.overrideWith(
                                      color: Theme.of(context).colorScheme.error,
                                    ),),
                                    const SizedBox(width: Dimensions.padding10,),
                                    Text(PriceConverter.convertPrice(double.tryParse(providerOfferData.offeredPrice??"0")??0),style: context.heading.defaultSize.overrideWith(
                                        color: Theme.of(context).colorScheme.primary)),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.padding6),
                                Row(mainAxisAlignment: MainAxisAlignment.end,children: [

                                  GestureDetector(
                                    onTap:() {
                                      Get.back();
                                      Get.find<CreatePostController>().updatePostStatus(postId, providerOfferData.provider!.id!, 'deny');
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(Dimensions.radius6),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16,vertical: Dimensions.padding6),
                                      child: Center(child: Text('decline'.tr,style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.error),)),
                                    ),
                                  ),

                                  const SizedBox(width: Dimensions.padding10,),
                                  CustomButton(
                                    buttonText: 'accept'.tr,
                                    width:  80,
                                    height: 30,
                                    radius: Dimensions.radius6,
                                    onPressed: () {
                                      Get.back();
                                      Get.toNamed(RouteHelper.getBidCheckoutRoute(
                                          postId: postId, providerId: providerOfferData.provider!.id!,
                                          amount: providerOfferData.offeredPrice!, bidId: providerOfferData.id!
                                      ));
                                    },
                                  )
                                ],)

                              ],),
                            )
                          ],)
                        ],),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


