import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AcceptProviderRequestView extends StatelessWidget {
 final ProviderOfferData providerOfferData;
 final String postId;
 final int length;
  const AcceptProviderRequestView({super.key, required this.providerOfferData, required this.postId, required this.length}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController){
      return GestureDetector(
        onTap: (){
          Get.bottomSheet(
            ProviderOfferDetailsSheet(postId: postId, providerOfferData: providerOfferData),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        },
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius16),
          ),
          padding: const EdgeInsets.all(Dimensions.padding16),
          margin: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipOval(
                child: CustomImage(
                  height: 40, width: 40, fit: BoxFit.cover,
                  image: providerOfferData.provider?.logoFullPath??"",
                ),
              ),
              const SizedBox(width: Dimensions.padding10),

              Expanded(
                child: Column(children: [
                  Row(children: [
                    Expanded(
                      child: Row(children: [
                        Flexible(child: Text(
                          providerOfferData.provider?.name ?? "",
                          style: context.heading.defaultSize,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),

                        if(providerOfferData.provider?.isVerified ?? false)...[
                          const SizedBox(width: Dimensions.padding6),
                          Image.asset(Images.verified, height: 14, width: 14),
                        ],
                      ])
                    ),

                    ProviderChatButton(provider: providerOfferData.provider, buttonSize: 24, iconSize: 18),
                  ]),
                  const SizedBox(height: Dimensions.padding6),

                  Row(
                    children: [
                      Image.asset(Images.starIcon, height: 14, width: 14),
                      const SizedBox(width: Dimensions.padding4,),
                      Directionality(textDirection: TextDirection.ltr,
                        child: Text((providerOfferData.provider?.rating ?? 0).toStringAsFixed(1), style: context.body.small.overrideWith(fontWeight: FontWeight.w600, color: context.customThemeColors.textColor)),
                      ),
                      const SizedBox(width: Dimensions.padding4,),
                      Text('(${providerOfferData.provider?.ratingCount??0}+ ${'review'.tr})', style: context.body.small),
                    ],
                  ),
                  const SizedBox(height: Dimensions.padding12),
                ]),
              ),
            ]),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("offer_price".tr, style: context.body.extraSmall),
                      const SizedBox(height: Dimensions.padding4),

                      Text(PriceConverter.convertPrice(double.tryParse(providerOfferData.offeredPrice.toString())),
                        style: context.heading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.padding8),

                CustomButton(
                  buttonText: 'decline'.tr,
                  height: 32, width: 78,
                  radius: Dimensions.radius6,
                  fontSize: Dimensions.fontSizeSmall,
                  backgroundColor: context.customThemeColors.secondaryBackGroundColor,
                  textColor: context.customThemeColors.textColor,
                  onPressed:() async {
                    Get.bottomSheet(
                      ConfirmationBottomsheet(
                        icon: Images.ignore,
                        title: 'decline'.tr,
                        description: 'do_you_want_to_decline_this_request'.tr,
                        yesButtonText: 'decline',
                        onYesPressed: () async {

                          Get.back();
                          Get.dialog(const CustomLoader(), barrierDismissible: false,);
                          await createPostController.updatePostStatus(postId, providerOfferData.provider!.id!, 'deny');

                          if(length>1){
                            await createPostController.getProvidersOfferList(1, postId, reload: false);
                            Get.back();
                          }else{
                            Get.back();
                            Get.offNamed(RouteHelper.getMyPostScreen());
                          }
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                ),

                const SizedBox(width: Dimensions.padding10),

                CustomButton(
                  buttonText: 'accept'.tr,
                  height: 32, width: 78,
                  radius: Dimensions.radius6,
                  fontSize: Dimensions.fontSizeSmall,
                  onPressed:() async {

                          if(createPostController.checkProviderAvailability(providerOfferData: providerOfferData)){
                            Get.toNamed(RouteHelper.getBidCheckoutRoute(
                                postId: postId, providerId: providerOfferData.provider!.id!,
                                amount: providerOfferData.offeredPrice!, bidId: providerOfferData.id!
                            ));
                          }else{
                            customSnackBar("your_selected_provider_is_unavailable_right_now".tr);
                          }

                  },
                ),
              ],
            ),
          ]),
        ),
      );
    });
  }
}
