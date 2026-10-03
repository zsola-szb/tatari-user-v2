import 'package:tatarigigs_user/feature/booking/widget/common/booking_pro_badge.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_billing_row.dart';
import 'package:tatarigigs_user/feature/checkout/widget/summary/repeat_view_toggle_row.dart';
import 'package:tatarigigs_user/feature/checkout/widget/summary/terms_agreement_box.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BillingSummarySection extends StatelessWidget {
  const BillingSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        final CheckoutTotals totals = controller.displayTotals;
        final ConfigContent? config = Get.find<SplashController>().configModel.content;
        final bool showAdditionalCharge =
            config?.additionalCharge == 1 && totals.additionalCharge > 0;
        final String? configuredChargeLabel = config?.additionalChargeLabelName;
        final String additionalChargeLabel =
            (configuredChargeLabel != null && configuredChargeLabel.isNotEmpty) ? configuredChargeLabel : 'additional_charge'.tr;

        return Padding(
          padding: const EdgeInsets.all(Dimensions.padding4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('billing_summary'.tr, style: context.heading.defaultSize),
              const SizedBox(height: Dimensions.padding16),

              if (controller.totals.occurrenceCount > 1) ...<Widget>[
                RepeatViewToggleRow(
                  bookingCount: controller.totals.occurrenceCount,
                  showSingleBookingView: controller.showSingleBookingView,
                  onToggle: controller.toggleBookingView,
                ),
                const SizedBox(height: Dimensions.padding10),
              ],

              CheckoutBillingRow(label: 'sub_total'.tr, amount: totals.subTotal),

              if (totals.discount > 0) ...<Widget>[
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'discount'.tr,
                  amount: totals.discount,
                  sign: BillingRowSign.minus,
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

              if (totals.campaignDiscount > 0) ...<Widget>[
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'campaign_discount'.tr,
                  amount: totals.campaignDiscount,
                  sign: BillingRowSign.minus,
                ),
              ],

              if (totals.couponDiscount > 0) ...<Widget>[
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'coupon_discount'.tr,
                  amount: totals.couponDiscount,
                  sign: BillingRowSign.minus,
                  labelBadge: totals.isProCouponBenefit ? const BookingProBadge() : null,
                ),
              ],

              if (totals.referralDiscount > 0) ...<Widget>[
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'referral_discount'.tr,
                  amount: totals.referralDiscount,
                  sign: BillingRowSign.minus,
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
                  label: additionalChargeLabel,
                  amount: totals.isProServiceFeeBenefit
                      ? totals.additionalChargeAfterProDiscount : totals.additionalCharge,
                  originalAmount: totals.isProServiceFeeBenefit ? totals.additionalCharge : null,
                  sign: BillingRowSign.plus,
                  labelBadge: totals.isProServiceFeeBenefit ? const BookingProBadge() : null,
                ),
              ],

              if (controller.isWalletApplied && totals.walletPaid > 0) ...<Widget>[
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'paid_by_wallet'.tr,
                  amount: totals.walletPaid,
                  sign: BillingRowSign.minus,
                ),
                const SizedBox(height: Dimensions.padding10),
                CheckoutBillingRow(
                  label: 'due_amount'.tr,
                  amount: totals.dueAmount,
                  isEmphasised: true,
                ),
              ],

              const SizedBox(height: Dimensions.padding16),
              const CheckoutTermsAgreementBox(),
            ],
          ),
        );
      },
    );
  }
}

