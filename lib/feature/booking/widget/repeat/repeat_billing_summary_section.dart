import 'package:tatarigigs_user/feature/booking/widget/common/booking_expandable_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_summary_row.dart';
import 'package:tatarigigs_user/feature/booking/widget/repeat/repeat_edit_history_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatBillingSummarySection extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;

  const RepeatBillingSummarySection({super.key, required this.booking, required this.controller});

  @override
  Widget build(BuildContext context) {
    final RepeatBookingBillingTotals totals = booking.repeatBilling;
    final String daysSuffix = '(${totals.occurrenceCount} ${'days'.tr})';

    return BookingExpandableSection(
      title: 'billing_summary'.tr,
      child: Column(
        children: <Widget>[
          BookingSummaryRow(
            label: totals.isEdited
                ? '${'initial_sub_total'.tr} $daysSuffix' : '${'sub_total'.tr} $daysSuffix',
            amount: totals.initialSubTotal,
          ),
          if (totals.isEdited)
            BookingSummaryRow(
              label: 'updated_sub_total'.tr,
              amount: totals.updatedSubTotal,
              labelAction: _ViewEditHistory(booking: booking),
            ),
          BookingSummaryRow(
            label: 'service_discount'.tr,
            amount: totals.serviceDiscount,
            sign: BillingRowSign.minus,
          ),
          BookingSummaryRow(
            label: 'coupon_discount'.tr,
            amount: totals.couponDiscount,
            sign: BillingRowSign.minus,
          ),
          if (controller.showRepeatReferralDiscount)
            BookingSummaryRow(
              label: 'referral_discount'.tr,
              amount: totals.referralDiscount,
              sign: BillingRowSign.minus,
            ),
          if (controller.showRepeatExtraFee)
            BookingSummaryRow(
              label: Get.find<SplashController>().configModel.content?.additionalChargeLabelName ??
                  'service_charge'.tr,
              amount: totals.extraFee,
              sign: BillingRowSign.plus,
            ),
          BookingSummaryRow(
            label: 'service_vat'.tr,
            amount: totals.vat,
            sign: BillingRowSign.plus,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
            child: Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
          ),
          BookingSummaryRow(
            label: 'grand_total'.tr,
            amount: totals.grandTotal,
            isEmphasised: true,
          ),
          if (controller.showRepeatPaidRow)
            BookingSummaryRow(
              label: '${'paid'.tr} (${'for'.tr} ${totals.paidBookingCount} ${'bookings'.tr})',
              amount: totals.paidAmount,
            ),
          if (controller.showRepeatCanceledRow)
            BookingSummaryRow(
              label: '${'canceled_amount'.tr} (${totals.canceledBookingCount} ${'bookings'.tr})',
              amount: totals.canceledAmount,
              sign: BillingRowSign.minus,
            ),
          if (controller.showRepeatDueRow)
            BookingSummaryRow(label: 'due_amount'.tr, amount: controller.repeatDueAmount),
        ],
      ),
    );
  }
}

class _ViewEditHistory extends StatelessWidget {
  final BookingDetailModel booking;

  const _ViewEditHistory({required this.booking});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.bottomSheet(
        RepeatEditHistorySheet(entries: booking.editHistory),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      ),
      child: Text('(${'view_details'.tr})',
        style: context.body.small.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
