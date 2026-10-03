import 'package:tatarigigs_user/feature/booking/widget/common/booking_expandable_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_inset_panel.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_pro_badge.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_summary_row.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingBillingSummarySection extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;

  const BookingBillingSummarySection({super.key, required this.booking, required this.controller});

  @override
  Widget build(BuildContext context) {
    final BookingBillingTotals totals = booking.billing;

    return BookingExpandableSection(
      title: 'billing_summary'.tr,
      child: Column(
        children: <Widget>[
          BookingSummaryRow(label: 'sub_total'.tr, amount: totals.subTotal),
          BookingSummaryRow(
            label: 'service_discount'.tr,
            amount: totals.serviceDiscount,
            sign: BillingRowSign.minus,
          ),
          if (controller.showProDiscountRow)
            BookingSummaryRow(
              label: 'pro_discount'.tr,
              amount: totals.proDiscount,
              sign: BillingRowSign.minus,
              labelBadge: const BookingProBadge(),
            ),
          BookingSummaryRow(
            label: 'coupon_discount'.tr,
            amount: totals.couponDiscount,
            sign: BillingRowSign.minus,
            labelBadge: controller.isProCouponBenefit ? const BookingProBadge() : null,
          ),
          BookingSummaryRow(
            label: 'campaign_discount'.tr,
            amount: totals.campaignDiscount,
            sign: BillingRowSign.minus,
          ),
          if (controller.showReferralDiscount)
            BookingSummaryRow(
              label: 'referral_discount'.tr,
              amount: totals.referralDiscount,
              sign: BillingRowSign.minus,
            ),
          if (controller.showExtraFee)
            BookingSummaryRow(
              label: Get.find<SplashController>().configModel.content?.additionalChargeLabelName ??
                  'service_charge'.tr,
              amount: totals.extraFee,
              sign: BillingRowSign.plus,
              originalAmount:
                  controller.isProServiceFeeBenefit ? controller.extraFeeBeforeProDiscount : null,
              labelBadge: controller.isProServiceFeeBenefit ? const BookingProBadge() : null,
            ),
          BookingSummaryRow(
            label: 'service_vat'.tr,
            amount: totals.vat,
            sign: BillingRowSign.plus,
          ),
          if (controller.showRefund)
            BookingSummaryRow(label: 'refund'.tr, amount: totals.additionalCharge),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
            child: Divider(height: 1, thickness: 2, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
          ),
          _GrandTotal(totals: totals, controller: controller),
        ],
      ),
    );
  }
}

class _GrandTotal extends StatelessWidget {
  final BookingBillingTotals totals;
  final BookingDetailsController controller;

  const _GrandTotal({required this.totals, required this.controller});

  @override
  Widget build(BuildContext context) {
    final Widget totalRow = BookingSummaryRow(
      label: 'grand_total'.tr,
      amount: totals.grandTotal,
      isEmphasised: true,
    );

    switch (controller.billingLayout) {
      case BookingTotalLayout.simple:
        return totalRow;

      case BookingTotalLayout.withDueAmount:
        return Column(
          children: <Widget>[
            totalRow,
            const SizedBox(height: Dimensions.padding8),
            BookingInsetPanel(child: _OutstandingRow(controller: controller)),
          ],
        );

      case BookingTotalLayout.walletPaid:
        return Column(
          children: <Widget>[
            totalRow,
            const SizedBox(height: Dimensions.padding8),
            BookingInsetPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    controller.walletHeadlineKey.tr,
                    style: context.heading.defaultSize.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  BookingSummaryRow(label: 'via_wallet'.tr, amount: totals.paidAmount),
                  if (controller.showOutstandingRow) _OutstandingRow(controller: controller),
                ],
              ),
            ),
          ],
        );

      case BookingTotalLayout.partialPayments:
        return BookingInsetPanel(
          child: Column(
            children: <Widget>[
              totalRow,
              ...totals.partialPayments.map((BookingPartialPayment payment) => BookingSummaryRow(
                    label: payment.labelFor(totals.method),
                    amount: payment.paidAmount,
                  )),
              if (controller.showOutstandingRow) _OutstandingRow(controller: controller),
            ],
          ),
        );
    }
  }
}

class _OutstandingRow extends StatelessWidget {
  final BookingDetailsController controller;

  const _OutstandingRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BookingSummaryRow(
      label: '${controller.outstandingLabelKey.tr} (${'cash_after_service'.tr})',
      amount: controller.outstandingAmount,
    );
  }
}
