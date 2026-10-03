import 'package:tatarigigs_user/util/core_export.dart';

class CartItem {
  final String id;
  final String serviceId;
  final String categoryId;
  final String subCategoryId;
  final String variantKey;
  final String variantName;
  final double serviceCost;
  final double discountedServiceCost;
  final int quantity;
  final double discountAmount;
  final double campaignDiscount;
  final double couponDiscount;
  final String? couponCode;
  final int? couponRemainingUses;
  final double taxAmount;
  final double totalCost;
  final Service? service;
  final ProviderData? provider;

  const CartItem({
    required this.id,
    required this.serviceId,
    required this.categoryId,
    required this.subCategoryId,
    required this.variantKey,
    required this.variantName,
    required this.serviceCost,
    required this.discountedServiceCost,
    required this.quantity,
    this.discountAmount = 0,
    this.campaignDiscount = 0,
    this.couponDiscount = 0,
    this.couponCode,
    this.couponRemainingUses,
    this.taxAmount = 0,
    this.totalCost = 0,
    this.service,
    this.provider,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? serviceJson =
        json['service'] is Map<String, dynamic> ? json['service'] as Map<String, dynamic> : null;
    final Map<String, dynamic>? providerJson =
        json['provider'] is Map<String, dynamic> ? json['provider'] as Map<String, dynamic> : null;

    return CartItem(
      id: json['id']?.toString() ?? '',
      serviceId: (json['service_id'] ?? serviceJson?['id'])?.toString() ?? '',
      categoryId: (json['category_id'] ?? serviceJson?['category_id'])?.toString() ?? '',
      subCategoryId: (json['sub_category_id'] ?? serviceJson?['sub_category_id'])?.toString() ?? '',
      variantKey: json['variant_key']?.toString() ?? '',
      variantName: json['variant']?.toString() ?? '',
      serviceCost: _toDouble(json['service_cost']),
      discountedServiceCost: _toDouble(json['discounted_amount']),
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      discountAmount: _toDouble(json['discount_amount']),
      campaignDiscount: _toDouble(json['campaign_discount']),
      couponDiscount: _toDouble(json['coupon_discount']),
      couponCode: json['coupon_code']?.toString(),
      couponRemainingUses: int.tryParse(json['remaining_uses'].toString()),
      taxAmount: _toDouble(json['tax_amount']),
      totalCost: _toDouble(json['total_cost']),
      service: serviceJson == null ? null : Service.fromJson(serviceJson),
      provider: providerJson == null ? null : ProviderData.fromJson(providerJson),
    );
  }

  static double _toDouble(dynamic value) => double.tryParse(value.toString()) ?? 0;

  double get originalSubTotal => serviceCost * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      serviceId: serviceId,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      variantKey: variantKey,
      serviceCost: serviceCost,
      quantity: quantity ?? this.quantity,
      discountAmount: discountAmount,
      campaignDiscount: campaignDiscount,
      couponDiscount: couponDiscount,
      couponCode: couponCode,
      couponRemainingUses: couponRemainingUses,
      taxAmount: taxAmount,
      totalCost: totalCost,
      service: service,
      provider: provider,
      variantName: variantName,
      discountedServiceCost: discountedServiceCost
    );
  }
}
