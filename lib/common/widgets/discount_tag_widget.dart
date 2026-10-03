import 'package:tatarigigs_user/util/core_export.dart';

class DiscountTagWidget extends StatelessWidget {
  final double? discountAmount;
  final String? discountAmountType;
  const DiscountTagWidget({super.key, this.discountAmount, this.discountAmountType}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radius6),
          bottomRight: Radius.circular(Dimensions.radius12),
        ),
      ),
      child: Text(PriceConverter.percentageOrAmount('$discountAmount', '$discountAmountType'),
        style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).primaryColorLight),
      ),
    );
  }
}
