import 'package:tatarigigs_user/feature/booking/widget/common/booking_pro_badge.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_billing_row.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CartBottomBar extends StatelessWidget {
  final VoidCallback onConfirm;

  const CartBottomBar({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (CartController controller) {
        final CartTotals totals = controller.visibleTotals;
        final Color primary = Theme.of(context).colorScheme.primary;
        final bool isDisabled = controller.isUpdating;

        return Container(
          decoration: BoxDecoration(
            color: context.customThemeColors.backGroundColor,
            boxShadow: Theme.of(context).brightness == Brightness.light ? cardShadow : null,
          ),
          padding: EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding12, Dimensions.padding16,
            MediaQuery.of(context).padding.bottom + Dimensions.padding12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: controller.isBillingExpanded
                    ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: _BillingBreakdown(totals: totals),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(Dimensions.radius8),
                onTap: controller.toggleBillingExpanded,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
                  child: Row(
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          text: '${'total'.tr} ',
                          style: context.heading.large,
                          children: <InlineSpan>[
                            TextSpan(text: 'inc_vat_tax'.tr, style: context.subHeading.small
                                .overrideWith(color: context.customThemeColors.secondaryTextColor , fontWeight: AppWeight.regular)),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding4),

                      AnimatedRotation(
                        turns: controller.isBillingExpanded ? 1 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          height: 18, width: 18,
                          padding: EdgeInsets.all(Dimensions.padding4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle
                          ),
                          child: SvgPicture.asset(
                            Images.chevronDownArrowIcon, width: 9, height: 9,
                            colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                          ),
                        ),
                      ),

                      const Spacer(),

                      if (totals.hasDiscount) ...<Widget>[
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            PriceConverter.convertPrice(totals.originalTotal, isShowLongPrice: true),
                            style: context.subHeading.small.copyWith(
                              fontWeight: AppWeight.regular,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: context.customThemeColors.secondaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding6),
                      ],
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          PriceConverter.convertPrice(totals.grandTotal, isShowLongPrice: true),
                          style: context.heading.overLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.padding10),
              CustomButton(
                width: double.infinity,
                height: 50,
                radius: Dimensions.radius12,
                buttonText: 'confirm_booking'.tr,
                backgroundColor: isDisabled ? primary.withValues(alpha: 0.5) : primary,
                onPressed: isDisabled ? null : onConfirm,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BillingBreakdown extends StatelessWidget {
  final CartTotals totals;

  const _BillingBreakdown({required this.totals});

  @override
  Widget build(BuildContext context) {
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    final String? chargeLabel = config?.additionalChargeLabelName;
    final bool showAdditionalCharge =
        config?.additionalCharge == 1 && totals.additionalCharge > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CheckoutBillingRow(label: 'service_price'.tr, amount: totals.subTotal),
        if (totals.discount > 0) ...<Widget>[
          const SizedBox(height: Dimensions.padding10),
          CheckoutBillingRow(
            label: 'discount'.tr,
            amount: totals.discount,
            sign: BillingRowSign.minus,
            labelBadge: totals.isProCouponBenefit ? const BookingProBadge() : null,
          ),
        ],
        if (totals.showProDiscountRow) ...<Widget>[
          const SizedBox(height: Dimensions.padding10),
          CheckoutBillingRow(
            label: 'pro_discount'.tr,
            amount: totals.proDiscount,
            sign: BillingRowSign.minus,
            labelBadge: const BookingProBadge(),
          ),
        ],
        if (totals.vat > 0) ...<Widget>[
          const SizedBox(height: Dimensions.padding10),
          CheckoutBillingRow(
            label: 'vat'.tr,
            amount: totals.vat,
            sign: BillingRowSign.plus,
          ),
        ],
        if (showAdditionalCharge) ...<Widget>[
          const SizedBox(height: Dimensions.padding10),
          CheckoutBillingRow(
            label: chargeLabel != null && chargeLabel.isNotEmpty
                ? chargeLabel : 'additional_charge'.tr,
            amount: totals.isProServiceFeeBenefit
                ? totals.additionalChargeAfterProDiscount : totals.additionalCharge,
            originalAmount: totals.isProServiceFeeBenefit ? totals.additionalCharge : null,
            sign: BillingRowSign.plus,
            labelBadge: totals.isProServiceFeeBenefit ? const BookingProBadge() : null,
          ),
        ],
        Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
      ],
    );
  }
}
