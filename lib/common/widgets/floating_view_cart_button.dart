import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class FloatingViewCartButton extends StatelessWidget {
  final Color? backgroundColor;

  const FloatingViewCartButton({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      if(cartController.items.isEmpty){
        return const SizedBox.shrink();
      }

      final Color fadeColor = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
      final double bottomMargin = kFloatingActionButtonMargin + MediaQuery.viewPaddingOf(context).bottom;

      return Transform.translate(
        offset: Offset(0, bottomMargin),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: Dimensions.padding16, bottom: bottomMargin),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [fadeColor.withValues(alpha: 0.03), fadeColor],
              stops: const [0, 0.5],
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(Dimensions.radiusFull),
              child: InkWell(
                onTap: () => Get.toNamed(RouteHelper.getCartEntryRoute()),
                borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: Dimensions.padding10),

                    Text(
                      '${'view_cart'.tr} (${cartController.items.length})',
                      style: heading.large.overrideWith(color: Colors.white),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }
}


class ViewCartBottomSpace extends StatelessWidget {
  const ViewCartBottomSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return SizedBox(height: cartController.items.isEmpty ? 0 : 40);
    });
  }
}
