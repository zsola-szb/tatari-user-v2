import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BookingSummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final BillingRowSign sign;
  final double? originalAmount;
  final bool isEmphasised;
  final Widget? labelBadge;
  final Widget? labelAction;

  const BookingSummaryRow({
    super.key,
    required this.label,
    required this.amount,
    this.sign = BillingRowSign.none,
    this.originalAmount,
    this.isEmphasised = false,
    this.labelBadge,
    this.labelAction,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = isEmphasised
        ? context.heading.defaultSize : context.body.defaultSize;
    final TextStyle amountStyle = isEmphasised
        ? context.heading.large : context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor);

    final double? original = originalAmount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Flexible(child: Text(label, style: labelStyle, overflow: TextOverflow.ellipsis)),
                if (labelBadge != null) ...<Widget>[
                  const SizedBox(width: Dimensions.padding6),
                  labelBadge!,
                ],
                if (labelAction != null) ...<Widget>[
                  const SizedBox(width: Dimensions.padding6),
                  labelAction!,
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
                style: context.body.small.copyWith(
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
              '${sign.prefix}${PriceConverter.convertPrice(amount, isShowLongPrice: true)}',
              style: amountStyle,
            ),
          ),
        ],
      ),
    );
  }
}
