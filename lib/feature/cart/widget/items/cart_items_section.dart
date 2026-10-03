import 'package:tatarigigs_user/feature/cart/widget/common/cart_section_card.dart';
import 'package:tatarigigs_user/feature/cart/widget/items/cart_add_more_row.dart';
import 'package:tatarigigs_user/feature/cart/widget/items/cart_service_group_tile.dart';
import 'package:tatarigigs_user/feature/cart/widget/items/cart_variation_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (CartController controller) {
        final List<CartServiceGroup> groups = controller.visibleGroups;
        final bool isEnabled = !controller.isUpdating;

        return CartSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int index = 0; index < groups.length; index++) ...<Widget>[
                if (index > 0)
                  Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
                CartServiceGroupTile(
                  group: groups[index],
                  isEnabled: isEnabled,
                  isExpanded: controller.isGroupExpanded(groups[index].serviceId),
                  onToggleExpanded: () => controller.toggleGroupExpanded(groups[index].serviceId),
                  onGroupIncrement: () => _onGroupIncrement(context, controller, groups[index]),
                  onGroupDecrement: () => _onGroupDecrement(context, controller, groups[index]),
                  onItemIncrement: controller.incrementItem,
                  onItemDecrement: controller.decrementItem,
                ),
              ],

              Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
              CartAddMoreRow(onTap: () => _onAddMore(controller)),
            ],
          ),
        );
      },
    );
  }

  void _onAddMore(CartController controller) {
    final String? providerId = controller.visibleCart.provider?.id;
    if (providerId == null || providerId.isEmpty) {
      Get.toNamed(RouteHelper.getCartAddMoreServiceRoute());
      return;
    }
    Get.toNamed(RouteHelper.getProviderDetails(providerId));
  }

  Future<void> _onGroupIncrement(BuildContext context, CartController controller, CartServiceGroup group) async {
    if (await openCartVariationSheet(context, group.service)) {
      return;
    }
    if (group.hasSingleVariation) {
      controller.incrementItem(group.items.first);
      return;
    }
    customSnackBar('no_variation_is_available'.tr, type: ToasterMessageType.info);
  }

  Future<void> _onGroupDecrement(BuildContext context, CartController controller, CartServiceGroup group) async {
    if (await openCartVariationSheet(context, group.service)) {
      return;
    }
    switch (group.decrementAction) {
      case CartGroupAction.changeQuantity:
        controller.decrementItem(group.items.first);
        break;
      case CartGroupAction.expandVariations:
        controller.expandGroup(group.serviceId);
        break;
    }
  }
}
