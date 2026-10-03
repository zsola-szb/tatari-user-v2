import 'package:tatarigigs_user/util/core_export.dart';

class CartVariationRow extends StatelessWidget {
  final CartItem item;
  final bool isEnabled;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartVariationRow({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.padding10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.variantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.subHeading.defaultSize.medium,
                ),
                const SizedBox(height: Dimensions.padding2),
                Row(children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      PriceConverter.convertPrice(item.discountedServiceCost, isShowLongPrice: true),
                      style: context.subHeading.small,
                    ),
                  ),

                  if(item.discountedServiceCost < (item.serviceCost * item.quantity))...[
                    const SizedBox(width: Dimensions.padding6),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice((item.serviceCost * item.quantity), isShowLongPrice: true),
                        style: context.body.small.copyWith(decoration: TextDecoration.lineThrough),
                      ),
                    )
                  ]
                ]),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          AutoCollapsingQuantityStepper(
            size: 32,
            quantity: item.quantity,
            onIncrement: isEnabled ? onIncrement : () {},
            onDecrement: isEnabled ? onDecrement : () {},
          ),
        ],
      ),
    );
  }
}
