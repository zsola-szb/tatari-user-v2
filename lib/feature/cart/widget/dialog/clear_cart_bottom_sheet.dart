import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

Future<void> openClearCartBottomSheet(
  BuildContext context, {
  String titleKey = 'clear_cart',
  String descriptionKey = 'clear_cart_confirmation',
  VoidCallback? onConfirm,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => ConfirmationBottomsheet(
      widget: _ClearCartContent(
        titleKey: titleKey,
        descriptionKey: descriptionKey,
        onConfirm: onConfirm,
      ),
    ),
  );
}

class _ClearCartContent extends StatelessWidget {
  final String titleKey;
  final String descriptionKey;
  final VoidCallback? onConfirm;

  const _ClearCartContent({
    required this.titleKey,
    required this.descriptionKey,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final Color error = context.customThemeColors.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: error),
          child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
        ),
        const SizedBox(height: Dimensions.padding16),

        Text(titleKey.tr, textAlign: TextAlign.center, style: context.heading.extraLarge),
        const SizedBox(height: Dimensions.padding8),

        Text(
          descriptionKey.tr,
          textAlign: TextAlign.center,
          style: context.body.small,
        ),
        const SizedBox(height: Dimensions.padding24),

        Row(
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
                  minimumSize: const Size(Dimensions.webMaxWidth, 48),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius8),
                  ),
                ),
                child: Text('no'.tr, style: context.heading.defaultSize),
              ),
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: CustomButton(
                height: 48,
                radius: Dimensions.radius8,
                backgroundColor: error,
                buttonText: 'yes_delete'.tr,
                onPressed: () {
                  Get.back();
                  if (onConfirm != null) {
                    onConfirm?.call();
                    return;
                  }
                  Get.find<CartController>().clearCart();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
