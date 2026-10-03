import 'package:tatarigigs_user/feature/checkout/widget/coupon/coupon_bottom_sheet_widget.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/coupon/applied_coupon_ticket.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutCouponSection extends StatelessWidget {
  const CheckoutCouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return GetBuilder<CartController>(
          builder: (CartController cartController) {
            return GetBuilder<CouponController>(
              builder: (CouponController couponController) {
                final String? code = cartController.couponCode;
                final bool isApplied = code != null && code.isNotEmpty;

                return CheckoutSectionCard(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  radius: Dimensions.radius12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomInkWell(
                        radius: Dimensions.radius12,
                        onTap: () => _openSheet(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.padding4,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('add_coupon'.tr, style: context.heading.defaultSize),
                                    const SizedBox(height: Dimensions.padding2),

                                    Text('to_save_more_use_available_coupons'.tr, style: context.body.small),
                                  ],
                                ),
                              ),
                              isApplied ? CheckoutEditIconButton(onTap: () => _openSheet(context)) :
                              Icon(Icons.add, size: 22, color:context.customThemeColors.textColor),
                            ],
                          ),
                        ),
                      ),
                      if (isApplied) ...<Widget>[
                        const SizedBox(height: Dimensions.padding16),
                        AppliedCouponTicket(
                          code: code,
                          coupon: _appliedCoupon(couponController, code),
                          discountAmount: controller.totals.couponDiscount,
                          isRemoving: couponController.isLoading,
                          onRemove: couponController.isLoading ? null : () => _removeCoupon(controller),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  CouponModel? _appliedCoupon(CouponController couponController, String code) {
    for (final CouponModel coupon in couponController.activeCouponList ?? <CouponModel>[]) {
      if (coupon.couponCode?.toLowerCase() == code.toLowerCase()) {
        return coupon;
      }
    }
    return null;
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => const CouponBottomSheetWidget(),
    ).then((_) {
      Get.find<CheckoutController>().recalculateTotals();
    });
  }

  Future<void> _removeCoupon(CheckoutController controller) async {
    await Get.find<CouponController>().removeCoupon(fromCheckout: true);
    Get.find<CartController>().refreshCart();
    Get.find<CouponController>().getCouponList();
  }
}
