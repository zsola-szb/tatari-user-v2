import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceBottomCartBar extends StatelessWidget {
  final Service service;
  const ServiceBottomCartBar({super.key, required this.service});

  bool get _hasVariations => service.variations?.isNotEmpty ?? false;

  String get _serviceId => service.id ?? '';

  Future<void> _addSelectedVariationsToCart(CartController cartController, bool isAlreadyInCart) async {
    await cartController.addSelectionsToCart(
      serviceId: _serviceId,
      fromServiceCenterDialog: false,
      providerId: cartController.selectedProvider?.id ?? "",
    );

    if(isAlreadyInCart){
      customSnackBar("successfully_added_to_cart".tr, type: ToasterMessageType.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      final bool isAlreadyInCart = cartController.itemsForService(_serviceId).isNotEmpty;
      final bool hasSelectedVariation = _hasVariations && cartController.hasSelectedQuantityForService(_serviceId);
      final bool showSelectVariationsButton = _hasVariations && !hasSelectedVariation;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor.withValues(alpha: 0.05),
              Theme.of(context).cardColor,
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(Dimensions.padding20, Dimensions.padding12, Dimensions.padding20, Dimensions.padding20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!showSelectVariationsButton) ...[
                _hasVariations
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '${'total'.tr} ',
                              style: context.heading.large.strong,
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              PriceConverter.convertPrice(cartController.selectionTotalForService(_serviceId), isShowLongPrice: true),
                              style: context.heading.extraOverLarge,
                            ),
                          ),
                        ],
                      )
                    : Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: Dimensions.padding6,
                          children: _simplePriceChildren(context),
                        ),
                      ),
                const SizedBox(height: Dimensions.padding12),
              ],

              Row(
                spacing: Dimensions.padding10,
                children: [
                  // if (Get.find<SplashController>().configModel.content?.directProviderBooking == 1 &&
                  //     cartController.selectedProvider != null)
                  //   SelectedProviderChip(providerData: cartController.selectedProvider),

                  if (Get.find<SplashController>().configModel.content?.biddingStatus == 1)
                    ServiceBiddingButton(
                      service: service,
                      popBeforeOpen: false,
                      isDisabled: cartController.isCartUpdatingForService(_serviceId),
                    ),

                  Expanded(
                    child: CustomButton(
                      height: 45,
                      isLoading: cartController.isCartUpdatingForService(_serviceId),
                      buttonText: showSelectVariationsButton
                          ? 'select_variations'.tr
                          : (isAlreadyInCart ? 'update_cart'.tr : 'add_to_cart'.tr),
                      onPressed: showSelectVariationsButton
                          ? null
                          : _hasVariations
                              ? () => _addSelectedVariationsToCart(cartController, isAlreadyInCart)
                              : () => showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ServiceCenterDialog(
                                      service: service,
                                      isFromDetails: true,
                                 //     minPurchasePrice: discount?.minPurchase,
                                    ),
                                  ),
                      backgroundColor:
                          showSelectVariationsButton ? Theme.of(context).disabledColor.withValues(alpha: 0.12) : null,
                      textColor: showSelectVariationsButton ? context.customThemeColors.textColor : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _simplePriceChildren(BuildContext context) {
    bool showDiscountedPrice = false;
    showDiscountedPrice = (service.lowestPrice ?? 0) > (service.discountedLowestPrice ?? 0);

    return [
      if (showDiscountedPrice)
        Text(
          PriceConverter.convertPrice(service.lowestPrice, isShowLongPrice: true),
          style: context.body.small.overrideWith(color: context.customThemeColors.error).copyWith(decoration: TextDecoration.lineThrough),
        ),
      Text(
        showDiscountedPrice
            ? PriceConverter.convertPrice(
                service.discountedLowestPrice,

                isShowLongPrice: true,
              )
            : PriceConverter.convertPrice(service.lowestPrice, isShowLongPrice: true),
        style: context.heading.large.strong.overrideWith(color: Theme.of(context).primaryColor),
      ),
    ];
  }
}
