import 'package:tatarigigs_user/helper/analytics/analytics_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceCartHelper {
  const ServiceCartHelper._();

  static int quantityOf(Service service) =>
      Get.find<CartController>().quantityOfService(service.id ?? '');

  static Future<void> increment(
    BuildContext context,
    Service service, {
    ProviderData? providerData,
  }) async {
    final CartController cartController = Get.find<CartController>();
    if (cartController.isUpdating) {
      return;
    }

    final List<CartItem> items = cartController.itemsForService(service.id ?? '');

    if (items.length == 1 && _variationsOf(service).length <= 1) {
      final CartItem item = items.first;
      await cartController.updateItemQuantity(item.id, item.quantity + 1, serviceId: item.serviceId);
      _logAddToCart(service, item.serviceCost.toDouble());
      return;
    }

    await quickAdd(context, service, providerData: providerData);
  }

  static Future<void> decrement(
    BuildContext context,
    Service service, {
    ProviderData? providerData,
    double? minPurchasePrice,
  }) async {
    final CartController cartController = Get.find<CartController>();
    if (cartController.isUpdating) {
      return;
    }

    final List<CartItem> items = cartController.itemsForService(service.id ?? '');
    if (items.isEmpty) {
      return;
    }

    if (items.length > 1) {
      await _openVariationSheet(context, service, providerData: providerData);
      return;
    }

    final CartItem item = items.first;
    if (item.quantity > 1) {
      await cartController.updateItemQuantity(item.id, item.quantity - 1, serviceId: item.serviceId);
      return;
    }

    await _confirmRemove(cartController, item);
  }

  static Future<void> quickAdd(
    BuildContext context,
    Service service, {
    ProviderData? providerData,
    double? minPurchasePrice,
  }) async {
    final List<ZoneWiseVariations> variations = _variationsOf(service);

    if (variations.length != 1) {
      await _openVariationSheet(context, service, providerData: providerData);
      return;
    }

    await _addSingleVariation(service, variations.first, providerData);
  }

  static List<ZoneWiseVariations> _variationsOf(Service service) =>
      service.variationsAppFormat?.zoneWiseVariations ?? <ZoneWiseVariations>[];

  static Future<void> _openVariationSheet(
    BuildContext context,
    Service service, {
    ProviderData? providerData,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => ServiceCenterDialog(
        service: service,
        providerData: providerData,
      ),
    );
  }

  static Future<void> _confirmRemove(CartController cartController, CartItem item) {
    return Get.bottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.cartDeleteVariation,
        description: 'are_you_sure_to_delete_this_service'.tr,
        onYesPressed: () {
          Get.back();
          cartController.removeItem(item);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static Future<void> _addSingleVariation(
    Service service,
    ZoneWiseVariations variation,
    ProviderData? providerData,
  ) async {
    final CartController cartController = Get.find<CartController>();
    final String serviceId = service.id ?? '';

    cartController.prepareVariationSelections(service);
    if (cartController.variationSelectionsForService(serviceId).isEmpty) {
      return;
    }

    cartController.setSelectionQuantity(
      serviceId,
      0,
      cartController.quantityOfVariation(serviceId, variation.variantKey) + 1,
      notify: false,
    );

    await cartController.addSelectionsToCart(
      serviceId: serviceId,
      fromServiceCenterDialog: false,
      providerId: providerData?.id ?? cartController.selectedProvider?.id ?? '',
    );

    if (Get.isDialogOpen ?? false) {
      return;
    }

    _logAddToCart(service, (variation.price ?? 0).toDouble());

    customSnackBar('successfully_added_to_cart'.tr, type: ToasterMessageType.success);
  }

  static void _logAddToCart(Service service, double price) {
    AnalyticsHelper.logAddToCart(
      itemId: service.id ?? '',
      itemName: service.name ?? '',
      price: price,
      quantity: 1,
      currency: Get.find<SplashController>().configModel.content?.currencyCode ?? '\$',
    );
  }
}
