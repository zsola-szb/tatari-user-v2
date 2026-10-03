import 'package:tatarigigs_user/util/core_export.dart';

class CartProviderPage {
  final List<CartProviderGroup> groups;
  final int totalSize;

  const CartProviderPage({
    this.groups = const <CartProviderGroup>[],
    this.totalSize = 0,
  });

  const CartProviderPage.empty() : this();

  factory CartProviderPage.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> content = BookingParse.object(json['content']) ?? json;

    return CartProviderPage(
      groups: BookingParse.objectList<CartProviderGroup>(content['data'], CartProviderGroup.fromJson),
      totalSize: BookingParse.toInt(content['total_size']),
    );
  }
}

class CartProviderGroup {
  final ProviderData? provider;
  final int serviceCount;
  final int itemCount;
  final double originalAmount;
  final double discountAmount;
  final double taxAmount;
  final double payableAmount;
  final double discountedAmount;
  final List<CartServiceSummary> services;

  const CartProviderGroup({
    this.provider,
    this.serviceCount = 0,
    this.itemCount = 0,
    this.originalAmount = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.payableAmount = 0,
    this.discountedAmount = 0,
    this.services = const <CartServiceSummary>[],
  });

  factory CartProviderGroup.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? providerJson = BookingParse.object(json['provider']);

    return CartProviderGroup(
      provider: providerJson == null ? null : ProviderData.fromJson(providerJson),
      serviceCount: BookingParse.toInt(json['service_count']),
      itemCount: BookingParse.toInt(json['item_count']),
      originalAmount: BookingParse.toDouble(json['original_amount']),
      discountAmount: BookingParse.toDouble(json['discount_amount']),
      taxAmount: BookingParse.toDouble(json['tax_amount']),
      payableAmount: BookingParse.toDouble(json['payable_amount']),
      discountedAmount: BookingParse.toDouble(json['discounted_amount']),
      services: BookingParse.objectList<CartServiceSummary>(json['services'], CartServiceSummary.fromJson),
    );
  }

  String get providerId => provider?.id ?? '';

  String get providerName => provider?.name ?? '';

  bool get isVerified => provider?.isVerified ?? false;

  bool get hasDiscount => originalAmount > discountedAmount;

  List<String> get thumbnails =>
      services.map((CartServiceSummary service) => service.thumbnail).toList(growable: false);
}

class CartServiceSummary {
  final String id;
  final String name;
  final String thumbnail;

  const CartServiceSummary({this.id = '', this.name = '', this.thumbnail = ''});

  factory CartServiceSummary.fromJson(Map<String, dynamic> json) => CartServiceSummary(
        id: BookingParse.string(json['id']) ?? '',
        name: BookingParse.string(json['name']) ?? '',
        thumbnail: BookingParse.string(json['thumbnail_full_path']) ?? '',
      );
}
