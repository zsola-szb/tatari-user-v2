import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderOfferDetailsSheet extends StatefulWidget {
  final ProviderOfferData providerOfferData;
  final String postId;
  const ProviderOfferDetailsSheet({super.key, required this.providerOfferData, required this.postId});

  @override
  State<ProviderOfferDetailsSheet> createState() => _ProviderOfferDetailsSheetState();
}

class _ProviderOfferDetailsSheetState extends State<ProviderOfferDetailsSheet> {
  bool _isDenying = false;

  @override
  Widget build(BuildContext context) {
    ProviderOfferData offer = widget.providerOfferData;
    String description = offer.providerNote ?? "";

    return BaseBottomSheet(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.padding18),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipOval(
                    child: CustomImage(
                      height: 44, width: 44, fit: BoxFit.cover,
                      image: offer.provider?.logoFullPath ?? "",
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding12),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(child: Text(offer.provider?.name ?? "",
                          style: context.heading.large,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),

                        if(offer.provider?.isVerified ?? false) ...[
                          const SizedBox(width: Dimensions.padding6),
                          Image.asset(Images.verified, height: 14, width: 14),
                        ],
                      ]),
                      const SizedBox(height: Dimensions.padding4),

                      Row(children: [
                        Image.asset(Images.starIcon, height: 14, width: 14),
                        const SizedBox(width: Dimensions.padding4),
                        Directionality(textDirection: TextDirection.ltr,
                          child: Text((offer.provider?.rating ?? 0).toStringAsFixed(1),
                            style: context.body.small.overrideWith(fontWeight: FontWeight.w600, color: context.customThemeColors.textColor),
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding4),
                        Text('(${offer.provider?.ratingCount ?? 0}+ ${'review'.tr})', style: context.body.small),
                      ]),
                    ]),
                  ),
                  const SizedBox(width: Dimensions.padding10),

                  ProviderChatButton(provider: offer.provider, buttonSize: 36, iconSize: 22, closesBottomSheet: true),
                ]),
                const SizedBox(height: Dimensions.padding20),

                Text('offer_price'.tr, style: context.body.defaultSize),
                const SizedBox(height: Dimensions.padding4),
                Text(PriceConverter.convertPrice(double.tryParse(offer.offeredPrice.toString())),
                  style: context.heading.extraLarge,
                ),

                if(description.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.padding20),
                  Text('description'.tr, style: context.body.defaultSize),
                  const SizedBox(height: Dimensions.padding4),
                  Text(description, style: context.subHeading.defaultSize),
                ],
              ]),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.padding20,
              Dimensions.padding24,
              Dimensions.padding20,
              MediaQuery.of(context).padding.bottom + Dimensions.padding20,
            ),
            child: Row(children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'deny'.tr,
                  height: 48,
                  radius: Dimensions.radius8,
                  backgroundColor: context.customThemeColors.secondaryBackGroundColor,
                  textColor: context.customThemeColors.textColor,
                  isLoading: _isDenying,
                  onPressed: _deny,
                ),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(
                child: CustomButton(
                  buttonText: 'accept'.tr,
                  height: 48,
                  radius: Dimensions.radius8,
                  onPressed: _accept,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> _deny() async {
    String? providerId = widget.providerOfferData.provider?.id;
    if(providerId == null){
      return;
    }
    setState(() => _isDenying = true);

    CreatePostController createPostController = Get.find<CreatePostController>();
    Response response = await createPostController.updatePostStatus(widget.postId, providerId, 'deny');

    if(!mounted){
      return;
    }
    setState(() => _isDenying = false);

    if(response.statusCode != 200){
      customSnackBar(response.statusText ?? 'something_went_wrong'.tr);
      return;
    }

    Get.back();
    await createPostController.getProvidersOfferList(1, widget.postId, reload: false);
    if(createPostController.listOfProviderOffer?.isEmpty ?? true){
      Get.offNamed(RouteHelper.getMyPostScreen());
    }
  }

  void _accept() {
    CreatePostController createPostController = Get.find<CreatePostController>();
    if(!createPostController.checkProviderAvailability(providerOfferData: widget.providerOfferData)){
      customSnackBar("your_selected_provider_is_unavailable_right_now".tr);
      return;
    }

    Get.back();
    Get.toNamed(RouteHelper.getBidCheckoutRoute(
      postId: widget.postId,
      providerId: widget.providerOfferData.provider?.id ?? "",
      amount: widget.providerOfferData.offeredPrice ?? "",
      bidId: widget.providerOfferData.id ?? "",
    ));
  }
}
