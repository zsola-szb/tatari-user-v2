import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutBillingRow extends StatelessWidget {
  final String label;
  final double amount;
  final BillingRowSign sign;
  final double? originalAmount;
  final bool isEmphasised;
  final Widget? labelBadge;

  const CheckoutBillingRow({
    super.key,
    required this.label,
    required this.amount,
    this.sign = BillingRowSign.none,
    this.originalAmount,
    this.isEmphasised = false,
    this.labelBadge,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = isEmphasised
        ? context.heading.defaultSize : context.subHeading.defaultSize;
    final TextStyle valueStyle = isEmphasised
        ? context.heading.defaultSize : context.subHeading.defaultSize;

    final double? original = originalAmount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(label, style: labelStyle, overflow: TextOverflow.ellipsis),
              ),
              if (labelBadge != null) ...<Widget>[
                const SizedBox(width: Dimensions.padding6),
                labelBadge!,
              ],
            ],
          ),
        ),
        const SizedBox(width: Dimensions.padding10),
        if (original != null && original > amount) ...<Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${sign.prefix}${PriceConverter.convertPrice(original, isShowLongPrice: true)}',
              style: context.body.defaultSize.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).hintColor.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.padding6),
        ],
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text('${sign.prefix}${PriceConverter.convertPrice(amount, isShowLongPrice: true)}', style: valueStyle),
        ),
      ],
    );
  }
}
