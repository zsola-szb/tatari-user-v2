import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';
import 'package:get/get.dart';

class BookingServiceVariation {
  final String variantKey;
  final int quantity;
  final double unitPrice;
  final double discountAmount;
  final double campaignDiscountAmount;
  final double couponDiscountAmount;
  final double taxAmount;

  const BookingServiceVariation({
    this.variantKey = '',
    this.quantity = 1,
    this.unitPrice = 0,
    this.discountAmount = 0,
    this.campaignDiscountAmount = 0,
    this.couponDiscountAmount = 0,
    this.taxAmount = 0,
  });

  String get label => variantKey.replaceAll('-', ' ').capitalizeFirst ?? '';

  double get lineTotal => unitPrice * (quantity <= 0 ? 1 : quantity);

  double get originalUnitPrice {
    final int count = quantity <= 0 ? 1 : quantity;
    return unitPrice - ((discountAmount + campaignDiscountAmount) / count);
  }

  bool get hasDiscount => unitPrice > originalUnitPrice;

  double get discountedLineTotal => originalUnitPrice * (quantity <= 0 ? 1 : quantity);
}

class BookingServiceItemModel {
  final String serviceId;
  final String name;
  final String? thumbnailFullPath;
  final List<BookingServiceVariation> variations;

  const BookingServiceItemModel({
    this.serviceId = '',
    this.name = '',
    this.thumbnailFullPath,
    this.variations = const <BookingServiceVariation>[],
  });

  factory BookingServiceItemModel.fromSummaryJson(Map<String, dynamic> json) => BookingServiceItemModel(
        serviceId: BookingParse.string(json['id']) ?? '',
        name: BookingParse.string(json['name']) ?? '',
        thumbnailFullPath: BookingParse.string(json['thumbnail_full_path']),
      );

  static List<BookingServiceItemModel> listFrom(dynamic detail) {
    final List<Map<String, dynamic>> rows = BookingParse.objectList<Map<String, dynamic>>(
      detail, (Map<String, dynamic> json) => json);
    if (rows.isEmpty) {
      return const <BookingServiceItemModel>[];
    }

    final Map<String, List<Map<String, dynamic>>> grouped = <String, List<Map<String, dynamic>>>{};
    final List<String> order = <String>[];

    for (final Map<String, dynamic> row in rows) {
      final String key = BookingParse.string(row['service_id']) ??
          BookingParse.string(row['id']) ??
          BookingParse.string(row['service_name']) ??
          BookingParse.string(row['name']) ??
          order.length.toString();
      if (!grouped.containsKey(key)) {
        grouped[key] = <Map<String, dynamic>>[];
        order.add(key);
      }
      grouped[key]!.add(row);
    }

    return order.map((String key) {
      final List<Map<String, dynamic>> items = grouped[key]!;
      final Map<String, dynamic> first = items.first;
      final Map<String, dynamic>? service = BookingParse.object(first['service']);

      return BookingServiceItemModel(
        serviceId: BookingParse.string(first['service_id']) ?? BookingParse.string(first['id']) ?? '',
        name: BookingParse.string(first['service_name']) ??
            BookingParse.string(first['name']) ?? BookingParse.string(service?['name']) ?? '',
        thumbnailFullPath: BookingParse.string(service?['thumbnail_full_path']) ??
            BookingParse.string(service?['cover_image_full_path']) ??
            BookingParse.string(first['thumbnail_full_path']),
        variations: items
            .map((Map<String, dynamic> row) => BookingServiceVariation(
                  variantKey: BookingParse.string(row['variant_key']) ?? '',
                  quantity: BookingParse.toInt(row['quantity'], fallback: 1),
                  unitPrice: BookingParse.toDouble(row['service_cost']),
                  discountAmount: BookingParse.toDouble(row['discount_amount']),
                  campaignDiscountAmount: BookingParse.toDouble(row['campaign_discount_amount']),
                  couponDiscountAmount: BookingParse.toDouble(row['overall_coupon_discount_amount']),
                  taxAmount: BookingParse.toDouble(row['tax_amount']),
                )).toList(growable: false),
      );
    }).toList(growable: false);
  }
}
