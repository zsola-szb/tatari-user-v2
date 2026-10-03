import 'package:tatarigigs_user/feature/booking/widget/common/booking_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_expandable_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_info_box.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/payment/booking_digital_payment_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/payment/booking_offline_update_sheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingPaymentCard extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;

  const BookingPaymentCard({super.key, required this.booking, required this.controller});

  @override
  Widget build(BuildContext context) {
    final BookingPaymentState payment = booking.payment;

    return BookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('payment_method'.tr, style: context.heading.large),
              ),
              _PaidStatusChip(isPaid: payment.isPaid),
            ],
          ),
          const SizedBox(height: Dimensions.padding16),
          Row(
            children: <Widget>[
              Icon(_methodIcon(payment.method), size: 20, color: context.customThemeColors.secondaryTextColor),
              const SizedBox(width: Dimensions.padding8),
              Expanded(
                child: Text(
                  payment.methodLabelKey.tr,
                  style: context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(payment.displayAmount, isShowLongPrice: true),
                  style: context.subHeading.large,
                ),
              ),
            ],
          ),
          if (payment.showDeniedNote) ...<Widget>[
            const SizedBox(height: Dimensions.padding12),
            BookingInfoBox(
              tone: BookingInfoTone.error,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '# ${'denied_note'.tr} :',
                    style: context.heading.small.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: Dimensions.padding4),
                  Text(payment.deniedNote ?? '', style: context.body.small.overrideWith(color: context.customThemeColors.textColor)),
                ],
              ),
            ),
          ],
          if (payment.showTransactionId) ...<Widget>[
            const SizedBox(height: Dimensions.padding10),
            Row(
              children: <Widget>[
                Text('transaction_id'.tr, style: context.body.small),
                const SizedBox(width: Dimensions.padding6),
                Expanded(
                  child: Text(
                    ': ${payment.transactionId}',
                    style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (payment.showOfflineFieldList) ...<Widget>[
            const SizedBox(height: Dimensions.padding12),
            BookingInlineDisclosure(
              title: '${'payment_info'.tr}  •  ${payment.offlineMethodName ?? ''}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: payment.offlineFields
                    .map((BookingOfflinePaymentField field) => Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.padding4),
                          child: Text(
                            '${field.label} : ${field.value}',
                            style: context.body.small,
                          ))).toList(growable: false),
              ),
            ),
          ],
          if (controller.canSwitchToDigital && Get.find<AuthController>().isLoggedIn()) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            _SwitchToDigitalPanel(booking: booking),
          ],
          if (controller.canManageOfflinePayment) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            _OfflineActions(booking: booking),
          ],
          if (controller.mustCompleteOfflinePayment) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            _IncompleteOfflinePanel(booking: booking),
          ],
          if (controller.canPayIndividually) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            CustomButton(
              buttonText: 'make_payment'.tr,
              height: 44,
              radius: Dimensions.radius8,
              onPressed: () => BookingDigitalPaymentSheet.open(booking: booking),
            ),
          ],
        ],
      ),
    );
  }

  IconData _methodIcon(BookingPaymentMethod method) {
    switch (method) {
      case BookingPaymentMethod.cashAfterService:
        return Icons.payments_outlined;
      case BookingPaymentMethod.walletPayment:
        return Icons.account_balance_wallet_outlined;
      case BookingPaymentMethod.offlinePayment:
        return Icons.account_balance_outlined;
      case BookingPaymentMethod.digital:
      case BookingPaymentMethod.unknown:
        return Icons.credit_card_outlined;
    }
  }
}

class _PaidStatusChip extends StatelessWidget {
  final bool isPaid;

  const _PaidStatusChip({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final Color color =
        isPaid ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding8,
        vertical: Dimensions.padding2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius6),
      ),
      child: Text(
        isPaid ? 'paid'.tr : 'unpaid'.tr,
        style: context.subHeading.small.medium.copyWith(color: color),
      ),
    );
  }
}

class _SwitchToDigitalPanel extends StatelessWidget {
  final BookingDetailModel booking;

  const _SwitchToDigitalPanel({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        border: Border.all(color: context.customThemeColors.backGroundColor)
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('no_cash_in_your_hand'.tr, style: context.heading.defaultSize),
                const SizedBox(height: 2),
                Text(
                  'select_any_digital_gateways_to_pay'.tr,
                  style: context.body.small,
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          CustomButton(
            buttonText: 'digital_payment'.tr,
            width: 100, height: 38,
            textStyle: context.subHeading.small.overrideWith(color: Theme.of(context).cardColor, fontWeight: AppWeight.medium),
            radius: Dimensions.radius8,
            fontSize: Dimensions.fontSizeSmall,
            onPressed: () => BookingDigitalPaymentSheet.open(booking: booking),
          ),
        ],
      ),
    );
  }
}

class _OfflineActions extends StatelessWidget {
  final BookingDetailModel booking;

  const _OfflineActions({required this.booking});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (BookingDetailsController controller) {
        return Row(
          children: <Widget>[
            Expanded(
              child: CustomButton(
                buttonText: 'switch_to_cas_short'.tr,
                height: 42,
                radius: Dimensions.radius8,
                fontSize: Dimensions.fontSizeSmall,
                backgroundColor: Colors.transparent,
                showBorder: true,
                textColor: Theme.of(context).colorScheme.primary,
                isLoading: controller.isProcessing,
                onPressed: () => _confirmSwitchToCash(context, controller),
              ),
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: CustomButton(
                buttonText: 'update_payment_info'.tr,
                height: 42,
                radius: Dimensions.radius8,
                fontSize: Dimensions.fontSizeSmall,
                onPressed: () => BookingOfflineUpdateSheet.open(booking: booking),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmSwitchToCash(BuildContext context, BookingDetailsController controller) {
    showBookingBottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.warning,
        title: 'switch_to_cas'.tr,
        description: 'are_you_sure_to_change_payment_offline_to_cas'.tr,
        noButtonText: 'cancel'.tr,
        yesButtonText: 'yes_continue'.tr,
        yesButtonColor: Theme.of(context).colorScheme.primary,
        onYesPressed: () {
          Get.back<void>();
          controller.switchToCashAfterService();
        },
      ),
    );
  }
}

class _IncompleteOfflinePanel extends StatelessWidget {
  final BookingDetailModel booking;

  const _IncompleteOfflinePanel({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: BookingInfoBox(
            tone: BookingInfoTone.error,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding12,
              vertical: Dimensions.padding8,
            ),
            child: Text(
              'payment_incomplete'.tr,
              style: context.heading.small.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
        const SizedBox(width: Dimensions.padding12),
        CustomButton(
          buttonText: 'pay_now'.tr,
          width: 120,
          height: 40,
          radius: Dimensions.radius8,
          fontSize: Dimensions.fontSizeSmall,
          onPressed: () => BookingDigitalPaymentSheet.open(booking: booking),
        ),
      ],
    );
  }
}
