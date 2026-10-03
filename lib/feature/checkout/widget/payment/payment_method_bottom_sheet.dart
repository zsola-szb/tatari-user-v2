import 'package:tatarigigs_user/feature/checkout/widget/payment/digital_gateway_list.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutPaymentMethodSheet extends StatelessWidget {
  const CheckoutPaymentMethodSheet({super.key});

  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints.expand(),
      builder: (BuildContext _) => const CheckoutPaymentMethodSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        final double walletBalance = CheckoutHelper.currentWalletBalance;
        final bool hasWallet = controller.otherMethodList.any((CheckoutPaymentOption o) => o.method == CheckoutPaymentMethod.wallet);

        final bool walletSettlesAll = controller.isWalletApplied && !controller.isPartialPayment;

        return Container(
          height: double.infinity,
          color: Theme.of(context).cardColor,
          child: Column(
            children: <Widget>[
              const _PaymentSheetHeader(),
              Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.30)),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (hasWallet) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.padding16),
                          child: _WalletBalanceCard(
                            balance: walletBalance,
                            totals: controller.totals,
                            isApplied: controller.isWalletApplied,
                            onApply: () => controller.toggleWallet(value: true),
                            onRemove: () => controller.toggleWallet(value: false),
                          ),
                        ),
                        Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
                      ],

                      _PaymentMethodList(
                        controller: controller,
                        isDisabled: walletSettlesAll,
                      ),
                    ],
                  ),
                ),
              ),

              _PaymentSheetBottomBar(
                total: controller.totals.dueAmount,
                isDisabled: controller.hasIncompletePartialSelection,
                onConfirm: () {
                  if (controller.hasIncompletePartialSelection) {
                    customSnackBar(
                      'select_another_payment_method_to_pay_remaining_bill'.tr,
                      type: ToasterMessageType.info,
                      showDefaultSnackBar: false,
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentSheetHeader extends StatelessWidget {
  const _PaymentSheetHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.padding20,
        Dimensions.padding20,
        Dimensions.padding16,
        Dimensions.padding16,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'choose_payment_methods'.tr,
              style: context.heading.extraLarge,
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          CustomInkWell(
            radius: Dimensions.radius20,
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20, color: context.customThemeColors.textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  final double balance;
  final CheckoutTotals totals;
  final bool isApplied;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _WalletBalanceCard({
    required this.balance,
    required this.totals,
    required this.isApplied,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final double headline = isApplied ? balance - totals.walletPaid : balance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: context.heading.large,
                    children: <InlineSpan>[
                      TextSpan(text: 'wallet_balance'.tr),
                      if (isApplied)
                        TextSpan(
                          text: ' (${'applied'.tr})',
                          style: context.heading.defaultSize.copyWith(color: primary),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.padding10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(headline < 0 ? 0 : headline),
                  style: context.heading.extraOverLarge.copyWith(color: primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding4),
          Text(
            'use_your_wallet_balance_to_pay_for_this_booking'.tr,
            style: context.subHeading.small.regular.overrideWith(color: context.customThemeColors.secondaryTextColor),
          ),
          const SizedBox(height: Dimensions.padding16),

          if (isApplied)
            _AppliedWalletBreakdown(totals: totals, onRemove: onRemove)
          else
            CustomButton(
              buttonText: 'use_your_wallet'.tr,
              textStyle: context.subHeading.small.medium.overrideWith(color: Colors.white),
              width: double.infinity,
              height: 44,
              radius: Dimensions.radius8,
              onPressed: onApply,
            ),
        ],
      ),
    );
  }
}

class _AppliedWalletBreakdown extends StatelessWidget {
  final CheckoutTotals totals;
  final VoidCallback onRemove;

  const _AppliedWalletBreakdown({required this.totals, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding12,
        vertical: Dimensions.padding10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _BreakdownRow(
                  label: 'wallet_payment'.tr,
                  amount: totals.walletPaid,
                  isEmphasised: false,
                ),
                const SizedBox(height: Dimensions.padding4),
                _BreakdownRow(
                  label: 'remaining_bill'.tr,
                  amount: totals.dueAmount,
                  isEmphasised: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          CustomInkWell(
            radius: Dimensions.radius20,
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding4),
              child: Icon(
                Icons.close,
                size: 20,
                color: context.customThemeColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isEmphasised;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.isEmphasised,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle style = isEmphasised
        ? context.heading.small : context.body.small;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
        const SizedBox(width: Dimensions.padding10),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(PriceConverter.convertPrice(amount), style: style),
        ),
      ],
    );
  }
}

class _PaymentMethodList extends StatelessWidget {
  final CheckoutController controller;
  final bool isDisabled;

  const _PaymentMethodList({required this.controller, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[];

    final bool hasCash = controller.otherMethodList.any(
      (CheckoutPaymentOption o) => o.method == CheckoutPaymentMethod.cashAfterService,
    );
    if (hasCash) {
      rows.add(
        PaymentMethodTile(
          label: 'pay_after_service'.tr,
          description: 'pay_the_balance_once_your_service_is_complete'.tr,
          isSelected: controller.paymentMethod == CheckoutPaymentMethod.cashAfterService,
          onTap: () => controller.selectPaymentMethod(
            method: CheckoutPaymentMethod.cashAfterService,
          ),
        ),
      );
    }

    final bool hasOffline = controller.digitalMethodList.any((DigitalPaymentMethod m) => m.gateway == 'offline');
    final bool isOfflineSelected = controller.paymentMethod == CheckoutPaymentMethod.offline;

    if (hasOffline) {
      rows.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PaymentMethodTile(
              label: 'offline_payment'.tr,
              description: 'make_your_payment_using_an_offline_method'.tr,
              isSelected: isOfflineSelected,
              onTap: () => controller.selectOfflinePayment(),
            ),
            if (isOfflineSelected)
              _OfflineMethodList(
                methods: controller.offlineMethodList,
                selectedId: controller.selectedOfflineMethod?.id,
                onSelected: (CheckoutOfflineMethodModel method) =>
                    controller.selectPaymentMethod(offlineMethod: method),
              ),
          ],
        ),
      );
    }

    // Added only when non-empty so the `rows.isEmpty` check below keeps
    // meaning "no payment method at all" now that the gateways are one child.
    final List<DigitalPaymentMethod> gateways =
        DigitalGatewayList.gatewaysOf(controller.digitalMethodList);
    if (gateways.isNotEmpty) {
      rows.add(
        DigitalGatewayList(
          methods: gateways,
          selectedGateway: controller.paymentMethod == CheckoutPaymentMethod.digital
              ? controller.selectedDigitalMethod?.gateway
              : null,
          onSelected: (DigitalPaymentMethod method) =>
              controller.selectPaymentMethod(digitalMethod: method),
        ),
      );
    }

    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.padding20),
        child: Text(
          'no_payment_method_available'.tr,
          style: context.subHeading.defaultSize.copyWith(
            color: context.customThemeColors.error,
          ),
        ),
      );
    }

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: Column(
          children: <Widget>[
            for (int i = 0; i < rows.length; i++) ...<Widget>[
              rows[i],
              if (i != rows.length - 1)
                Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
            ],
          ],
        ),
      ),
    );
  }
}

class _OfflineMethodList extends StatelessWidget {
  final List<CheckoutOfflineMethodModel> methods;
  final String? selectedId;
  final ValueChanged<CheckoutOfflineMethodModel> onSelected;

  const _OfflineMethodList({
    required this.methods,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (methods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.padding36, 0, Dimensions.padding20, Dimensions.padding16),
        child: Text(
          'no_offline_payment_method_available'.tr,
          style: context.body.small,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
        child: Row(
          children: methods
              .map(
                (CheckoutOfflineMethodModel method) => _OfflineMethodTile(
                  method: method,
                  isSelected: method.id != null && method.id == selectedId,
                  onTap: () => onSelected(method),
                ),
              ).toList(),
        ),
      ),
    );
  }
}

class _OfflineMethodTile extends StatelessWidget {
  final CheckoutOfflineMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const _OfflineMethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: Dimensions.padding10),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding16,
          vertical: Dimensions.padding10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primary : Theme.of(context).hintColor.withValues(alpha: 0.30),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Text(
          method.methodName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isSelected
              ? context.heading.small.copyWith(color: primary) : context.subHeading.small,
        ),
      ),
    );
  }
}

class _PaymentSheetBottomBar extends StatelessWidget {
  final double total;

  /// Dims the action while the selection is incomplete. The button stays
  /// tappable on purpose — [onConfirm] explains what is missing rather than
  /// leaving a dead control.
  final bool isDisabled;
  final VoidCallback onConfirm;

  const _PaymentSheetBottomBar({
    required this.total,
    required this.onConfirm,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.30))),
      ),
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding20,
        Dimensions.padding16,
        Dimensions.padding20,
        MediaQuery.of(context).padding.bottom + Dimensions.padding16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: context.heading.defaultSize,
                    children: <InlineSpan>[
                      TextSpan(text: 'total'.tr),
                      // The key already carries its own parentheses.
                      TextSpan(
                        text: ' ${'inc_vat_tax'.tr}',
                        style: context.body.small,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.padding10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(total),
                  style: context.heading.overLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding16),
          CustomButton(
            buttonText: 'make_payment'.tr,
            width: double.infinity,
            height: 50,
            radius: Dimensions.radius12,
            backgroundColor: isDisabled
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.primary,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
