import 'package:tatarigigs_user/feature/cart/widget/common/cart_expandable_row.dart';
import 'package:tatarigigs_user/feature/cart/widget/items/cart_variation_row.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const double _thumbnailSize = 48;

class CartServiceGroupTile extends StatelessWidget {
  final CartServiceGroup group;
  final bool isExpanded;
  final bool isEnabled;
  final VoidCallback onToggleExpanded;
  final VoidCallback onGroupIncrement;
  final VoidCallback onGroupDecrement;
  final void Function(CartItem item) onItemIncrement;
  final void Function(CartItem item) onItemDecrement;

  const CartServiceGroupTile({
    super.key,
    required this.group,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onGroupIncrement,
    required this.onGroupDecrement,
    required this.onItemIncrement,
    required this.onItemDecrement,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radius8),
              onTap: () => _openServiceDetails(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radius8),
                child: CustomImage(
                  image: group.thumbnail,
                  height: _thumbnailSize,
                  width: _thumbnailSize,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.padding12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    group.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.subHeading.defaultSize.medium,
                  ),
                  const SizedBox(height: Dimensions.padding4),
                  _GroupPriceRow(group: group),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.padding10),

            _GroupQuantityStepper(
              size: 36,
              quantity: group.totalQuantity,
              useDeleteIconAtMinimum: group.hasSingleVariation,
              onIncrement: isEnabled ? onGroupIncrement : () {},
              onDecrement: isEnabled ? onGroupDecrement : () {},
            ),
          ],
        ),

        const SizedBox(height: Dimensions.padding8),
        CartExpandableRow(
          label: 'variations'.tr,
          value: group.variantSummary,
          isExpanded: isExpanded,
          isExpandable: !group.hasSingleVariation,
          onToggle: onToggleExpanded,
        ),

        // AnimatedCrossFade(
        //   duration: const Duration(milliseconds: 200),
        //   crossFadeState: isExpanded && !group.hasSingleVariation ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        //   firstChild: const SizedBox(width: double.infinity),
        //   secondChild: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisSize: MainAxisSize.min,
        //     children: group.items
        //         .map((CartItem item) => CartVariationRow(
        //               item: item,
        //               isEnabled: isEnabled,
        //               onIncrement: () => onItemIncrement(item),
        //               onDecrement: () => onItemDecrement(item),
        //             )).toList(),
        //   ),
        // ),
      ],
    );
  }

  void _openServiceDetails() {
    final String? slug = group.service?.slug;
    if (slug == null || slug.isEmpty) {
      return;
    }
    Get.toNamed(RouteHelper.getServiceRoute(slug));
  }
}

class _GroupQuantityStepper extends StatelessWidget {
  final double size;
  final int quantity;
  final bool useDeleteIconAtMinimum;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _GroupQuantityStepper({
    required this.size,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.useDeleteIconAtMinimum = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = Theme.of(context).disabledColor.withValues(alpha: 0.1);
    final Color foreground = context.customThemeColors.textColor;

    if (quantity <= 0) {
      return InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        onTap: onIncrement,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(Dimensions.radius8)),
          child: Icon(Icons.add, size: 20, color: foreground),
        ),
      );
    }

    return Container(
      height: size,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(Dimensions.radius8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: onDecrement,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding6),
              child: Icon(
                useDeleteIconAtMinimum && quantity == 1 ? Icons.delete_outline : Icons.remove,
                size: 18,
                color: foreground,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: size),
            child: Center(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding4),
                child: Text('$quantity', style: context.heading.defaultSize.strong),
              ),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding6),
              child: Icon(Icons.add, size: 18, color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupPriceRow extends StatelessWidget {
  final CartServiceGroup group;

  const _GroupPriceRow({required this.group});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            PriceConverter.convertPrice(group.totalServiceCost, isShowLongPrice: true),
            style: context.heading.defaultSize,
          ),
          if (group.hasDiscount) ...<Widget>[
            const SizedBox(width: Dimensions.padding6),
            Text(
              PriceConverter.convertPrice(group.originalTotal, isShowLongPrice: true),
              style: context.body.small.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).hintColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
