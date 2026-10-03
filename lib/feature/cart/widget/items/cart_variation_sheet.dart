import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

Future<bool> openCartVariationSheet(BuildContext context, Service? service) async {
  if (service == null) {
    return false;
  }

  final CartController controller = Get.find<CartController>();

  Service? resolved = controller.cachedVariationService(service);
  if (resolved == null) {
    Get.dialog<void>(const CustomLoader(), barrierDismissible: false);
    resolved = await controller.resolveVariationService(service);
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  final List<ZoneWiseVariations> variations =
      resolved?.variationsAppFormat?.zoneWiseVariations ?? <ZoneWiseVariations>[];
  if (variations.length < 2 || !context.mounted) {
    return false;
  }

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => ServiceCenterDialog(
      service: resolved,
      providerData: controller.visibleCart.provider,
    ),
  );

  await controller.refreshCart();
  return true;
}
