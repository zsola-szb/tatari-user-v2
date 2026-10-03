import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartServiceGroup {
  final String serviceId;
  final Service? service;
  final List<CartItem> items;

  const CartServiceGroup({
    required this.serviceId,
    required this.service,
    required this.items,
  });

  int get totalQuantity => items.fold<int>(0, (int sum, CartItem item) => sum + item.quantity);

  double get totalServiceCost => items.fold<double>(0, (double sum, CartItem item) => sum + item.discountedServiceCost);

  double get originalTotal => items.fold<double>(0, (double sum, CartItem item) => sum + item.originalSubTotal);

  bool get hasDiscount => originalTotal > totalServiceCost;

  bool get hasSingleVariation => items.length == 1;

  List<String> get variantLabels => items.map((CartItem item) => item.variantName).toList();

  String get variantSummary => variantLabels.join(', ');

  String get serviceName => service?.name ?? 'service_not_available_in_current_location'.tr;

  String get thumbnail => service?.thumbnailFullPath ?? '';

  /// What tapping "−" on the group stepper should do: with a single variation
  /// there is only one row to change, otherwise the group has to open first so
  /// the user can pick which variation to reduce.
  CartGroupAction get decrementAction =>
      hasSingleVariation ? CartGroupAction.changeQuantity : CartGroupAction.expandVariations;
}
