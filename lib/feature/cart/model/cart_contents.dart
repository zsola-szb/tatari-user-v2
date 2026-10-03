import 'package:tatarigigs_user/util/core_export.dart';

/// Everything the cart-list endpoint returns: the flat [items], the same items
/// bucketed per service as [groups], and the Pro-plan benefit that applies.
class CartContents {
  final List<CartItem> items;
  final List<CartServiceGroup> groups;
  final double proDiscountAmount;
  final String? proBenefitType;

  const CartContents({
    this.items = const <CartItem>[],
    this.groups = const <CartServiceGroup>[],
    this.proDiscountAmount = 0,
    this.proBenefitType,
  });

  const CartContents.empty() : this();

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  ProviderData? get provider {
    for (final CartItem item in items) {
      if (item.provider != null) {
        return item.provider;
      }
    }
    return null;
  }

  String get subCategoryId {
    for (final CartItem item in items) {
      if (item.subCategoryId.isNotEmpty) {
        return item.subCategoryId;
      }
    }
    return '';
  }

  String? get couponCode {
    for (final CartItem item in items) {
      if (item.couponCode != null) {
        return item.couponCode;
      }
    }
    return null;
  }

  int? get couponRemainingUses {
    for (final CartItem item in items) {
      if (item.couponCode != null) {
        return item.couponRemainingUses;
      }
    }
    return null;
  }

  int get serviceCount => groups.length;

  factory CartContents.fromJson(Map<String, dynamic> json) {
    final dynamic rows = json['data'];
    if (rows is! List) {
      return const CartContents.empty();
    }

    final List<CartItem> items =
        rows.whereType<Map<String, dynamic>>().map(CartItem.fromJson).toList();

    return CartContents(
      items: items,
      groups: groupByService(items),
      proDiscountAmount: double.tryParse('${json['pro_discount_amount']}') ?? 0,
      proBenefitType: json['pro_benefit_type']?.toString(),
    );
  }

  static List<CartServiceGroup> groupByService(List<CartItem> items) {
    final Map<String, List<CartItem>> buckets = <String, List<CartItem>>{};
    for (final CartItem item in items) {
      buckets.putIfAbsent(item.serviceId.isEmpty ? item.id : item.serviceId, () => <CartItem>[]).add(item);
    }

    return buckets.entries
        .map((MapEntry<String, List<CartItem>> entry) => CartServiceGroup(
              serviceId: entry.key, service: entry.value.first.service,
              items: List<CartItem>.unmodifiable(entry.value))).toList();
  }
}
