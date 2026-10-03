import 'package:dotted_line/dotted_line.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CouponCardWidget extends StatelessWidget {
  final bool isExpired;
  final CouponModel couponModel;
  final int index;
  final bool fromCheckout;
  final Function(CouponModel couponData)? onTap;
  const CouponCardWidget({super.key, required this.couponModel, required this.isExpired, required this.index, this.fromCheckout = false, this.onTap});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: fromCheckout ? 0 : Dimensions.padding16, vertical: Dimensions.padding8),
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          onTap: () => Get.bottomSheet(
            CouponDetailsBottomSheet(
              couponModel: couponModel,
              isExpired: isExpired,
              onUseNow: isExpired ? null : () {
                if (fromCheckout) {
                  if (couponModel.isUsed != 1) {
                    onTap!(couponModel);
                  }
                } else {
                  _applyCoupon(context, couponController);
                }
              },
            ),
            backgroundColor: Colors.transparent, isScrollControlled: true,
          ),
          child: Container(
        decoration: BoxDecoration(
          color: isExpired ? context.customThemeColors.secondaryBackGroundColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),

        child: Stack(clipBehavior: Clip.none, children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.padding12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

            SizedBox(
              height: 45, width: 45,
              child: Opacity(opacity: isExpired ? 0.5 : 1, child: Image.asset(Images.voucherImage)),
            ),

            const SizedBox(width: Dimensions.padding12),

            DottedLine(
              direction: Axis.vertical,
              lineLength: 64,
              lineThickness: 2,
              dashColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
            ),

            const SizedBox(width: Dimensions.padding12),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(
                couponModel.discount?.discountTitle ?? '',
                style: context.subHeading.defaultSize.semiBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: Dimensions.padding4),

              Text(
                '${isExpired ? 'expired_on'.tr : 'valid_till'.tr} : ${couponModel.discount?.endDate ?? ''}',
                style: context.body.extraSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: Dimensions.padding10),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text(
                  PriceConverter.percentageOrAmount('${couponModel.discount?.discountAmount ?? 0}', couponModel.discount?.discountAmountType ?? 'percent'),
                  style: context.heading.large,
                ),

                const SizedBox(width: Dimensions.padding8),

                Flexible(
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(Dimensions.radius6),
                      color: isExpired ? Theme.of(context).hintColor.withValues(alpha: 0.3) : Theme.of(context).colorScheme.primary,
                      dashPattern: const [4, 3],
                      strokeWidth: 1,
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [

                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding6),
                          child: Text(
                            couponModel.couponCode ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.body.extraSmall.overrideWith(
                              color: isExpired ? Theme.of(context).hintColor : Theme.of(context).colorScheme.primary,
                              fontWeight: AppWeight.medium,
                            ),
                          ),
                        ),
                      ),

                      if (!isExpired)
                        InkWell(
                          onTap: fromCheckout ? () {
                            if (couponModel.isUsed != 1) {
                              onTap!(couponModel);
                            }
                          } : () => _applyCoupon(context, couponController),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding6),
                            decoration: BoxDecoration(
                              color: couponModel.isUsed == 1 ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius6), bottomRight: Radius.circular(Dimensions.radius6))
                            ),
                            child: Text(
                              couponModel.isUsed == 1 ? 'used'.tr : 'use'.tr,
                              style: context.body.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.medium),
                            ),
                          ),
                        ),

                    ]),
                  ),
                ),

              ]),

            ])),

            ]),
          ),

          Positioned(top: -14, left: 58,
            child: Container(width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.customThemeColors.backGroundColor,
              ),
            ),
          ),

          Positioned(bottom: -14, left: 58,
            child: Container(width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.customThemeColors.backGroundColor,
              ),
            ),
          ),

          if (couponController.isLoading && index == couponController.selectedCouponIndex && !fromCheckout)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radius16),
                ),
                child: const Center(child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator())),
              ),
            ),
        ]),
          ),
        ),
      );
    });
  }


  Future<void> _applyCoupon(BuildContext context, CouponController couponController) async {
    couponController.updateSelectedCouponIndex(index: index);
    if (Get.find<AuthController>().isLoggedIn()) {
      if (Get.find<CartController>().items.isNotEmpty) {
        bool addCoupon = false;
        for (var cart in Get.find<CartController>().items) {
          if (cart.totalCost >= (couponModel.discount?.minPurchase?.toDouble() ?? 0)) {
            addCoupon = true;
          }
        }
        if (addCoupon) {
          await Get.find<CouponController>().applyCoupon(couponModel.couponCode!).then((value) async {
            if (value.isSuccess!) {
              Get.find<CartController>().refreshCart();
              if (fromCheckout) {
                Get.back();
              }
              customSnackBar('review_your_cart_for_applied_discounts'.tr, toasterTitle: 'coupon_applied_successfully'.tr, type: ToasterMessageType.success);
            } else {
              customSnackBar('${value.message}', toasterTitle: 'can_not_apply_coupon'.tr, type: ToasterMessageType.error);
            }
          });
        } else {
          customSnackBar('${'valid_for_minimum_booking_amount_of'.tr} ${PriceConverter.convertPrice(couponModel.discount?.minPurchase ?? 0)} ', toasterTitle: 'can_not_apply_coupon'.tr, type: ToasterMessageType.error);
        }
      } else {
        customSnackBar('looks_like_no_service_is_added_to_your_cart'.tr, toasterTitle: 'oops'.tr, type: ToasterMessageType.error);
      }
    } else {
      customSnackBar('please_login_to_use_coupon'.tr, toasterTitle: 'sorry_you_can_not_use_coupon'.tr, type: ToasterMessageType.error);
    }
  }
}
