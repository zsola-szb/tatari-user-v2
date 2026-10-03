import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:flutter/material.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';

const Color _kDiscountBadgeColor = Color(0xFFFEE9E7);
const Color _kDiscountBorderColor = Color(0xFFFCB3AD);

class DiscountTag extends StatelessWidget {
  final num? discount;
  final String? discountType;
  final double? fromTop;
  final double? fontSize;
  final bool? freeDelivery;
  final Color? color;
  const DiscountTag({super.key, required this.discount, required this.discountType, this.fromTop = 5, this.fontSize, this.freeDelivery = false, this.color});

  String _label() {
    if(freeDelivery!){
      return PriceConverter.percentageOrAmount('$discount', '$discountType');
    }
    final bool isWhole = discount == discount!.roundToDouble();
    final String numberText = isWhole ? discount!.toStringAsFixed(0) : discount.toString();
    final String suffix = discountType == 'percent' ? '%' : PriceConverter.getCurrency();
    return '-$numberText$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = color ?? _kDiscountBorderColor;

    return (discount! > 0 || freeDelivery!) ? Positioned(
      top: fromTop, right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding4),
        decoration: BoxDecoration(
          color: _kDiscountBadgeColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Text(
          _label(),
          style: context.heading.defaultSize.copyWith(color: Theme.of(context).colorScheme.error, fontSize: fontSize ?? Dimensions.fontSizeSmall),
        ),
      ),
    ) : const SizedBox();
  }
}
