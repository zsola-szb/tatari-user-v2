import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_add_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_header.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_row.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {

        final bool hasSelection = !controller.hasIncompletePartialSelection &&
            (controller.paymentMethod != CheckoutPaymentMethod.none || controller.isWalletApplied);

        return CheckoutSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CheckoutSectionHeader(
                title: 'payment_method'.tr,
                subtitle: 'add_payment_method_hint'.tr,
                trailing: hasSelection
                    ? CheckoutEditIconButton(onTap: () => CheckoutPaymentMethodSheet.open(context))
                    : null,
              ),
              const SizedBox(height: Dimensions.padding16),
              if (!hasSelection)
                CheckoutAddButton(
                  label: 'add_payment_method'.tr,
                  onTap: () => CheckoutPaymentMethodSheet.open(context),
                )
              else
                _SelectedPaymentRows(controller: controller),
            ],
          ),
        );
      },
    );
  }
}

class _SelectedPaymentRows extends StatelessWidget {
  final CheckoutController controller;

  const _SelectedPaymentRows({required this.controller});

  @override
  Widget build(BuildContext context) {
    final CheckoutTotals totals = controller.totals;
    final bool isSplit = controller.isWalletApplied && totals.walletPaid < totals.grandTotal;

    if (!controller.isWalletApplied) {
      return _SelectedPaymentRow(
        controller: controller,
        method: controller.paymentMethod,
        amount: totals.grandTotal,
      );
    }

    if (!isSplit) {
      return _SelectedPaymentRow(
        controller: controller,
        method: CheckoutPaymentMethod.wallet,
        amount: totals.walletPaid,
      );
    }

    return Column(
      children: <Widget>[
        _SelectedPaymentRow(
          controller: controller,
          method: CheckoutPaymentMethod.wallet,
          amount: totals.walletPaid,
        ),
        const SizedBox(height: Dimensions.padding16),
        _SelectedPaymentRow(
          controller: controller,
          // Until a second method is chosen `paymentMethod` is still `wallet`,
          // which would render the wallet row twice. Show the placeholder
          // instead so the row reads as the outstanding choice it is.
          method: controller.hasIncompletePartialSelection
              ? CheckoutPaymentMethod.none
              : controller.paymentMethod,
          amount: totals.dueAmount,
          isRemainder: true,
        ),
      ],
    );
  }
}

class _SelectedPaymentRow extends StatelessWidget {
  final CheckoutController controller;
  final CheckoutPaymentMethod method;
  final double amount;
  final bool isRemainder;

  const _SelectedPaymentRow({
    required this.controller,
    required this.method,
    required this.amount,
    this.isRemainder = false,
  });

  @override
  Widget build(BuildContext context) {
    final String suffix = isRemainder ? ' (${'remaining_amount'.tr})' : '';

    switch (method) {
      case CheckoutPaymentMethod.wallet:
        return PaymentMethodRow(
          label: 'pay_via_wallet'.tr,
          assetIcon: Images.walletMenu,
          amount: amount,
        );
      case CheckoutPaymentMethod.cashAfterService:
        return PaymentMethodRow(
          label: '${'pay_after_service'.tr}$suffix',
          assetIcon: Images.cod,
          amount: amount,
        );
      case CheckoutPaymentMethod.digital:
        return PaymentMethodRow(
          label: '${controller.selectedDigitalMethod?.label ?? 'digital_payment'.tr}$suffix',
          networkIcon: controller.selectedDigitalMethod?.gatewayImageFullPath,
          amount: amount,
        );
      case CheckoutPaymentMethod.offline:
        return PaymentMethodRow(
          label: '${controller.selectedOfflineMethod?.methodName ?? 'offline_payment'.tr}$suffix',
          assetIcon: Images.offlinePayment,
          amount: amount,
        );
      case CheckoutPaymentMethod.none:
        return PaymentMethodRow(
          label: 'select_payment_method'.tr,
          assetIcon: Images.cod,
          amount: amount,
        );
    }
  }
}
