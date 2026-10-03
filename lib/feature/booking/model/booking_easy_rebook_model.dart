import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_party_model.dart';

class EasyRebookItem {
  final String id;
  final String readableId;
  final String subCategoryId;
  final String? subCategoryName;
  final bool isRepeat;
  final double totalAmount;
  final DateTime? placedAt;
  final BookingProviderModel? provider;
  final List<EasyRebookService> services;
  final int serviceCount;

  const EasyRebookItem({
    this.id = '',
    this.readableId = '',
    this.subCategoryId = '',
    this.subCategoryName,
    this.isRepeat = false,
    this.totalAmount = 0,
    this.placedAt,
    this.provider,
    this.services = const <EasyRebookService>[],
    this.serviceCount = 0,
  });

  factory EasyRebookItem.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? provider = BookingParse.object(json['provider']);
    final List<EasyRebookService> services = BookingParse.objectList<EasyRebookService>(
      json['services'],
      EasyRebookService.fromJson,
    );
    return EasyRebookItem(
      id: BookingParse.string(json['id']) ?? '',
      readableId: BookingParse.string(json['readable_id']) ?? '',
      subCategoryId: BookingParse.string(json['sub_category_id']) ?? '',
      subCategoryName: BookingParse.string(json['sub_category']),
      isRepeat: BookingParse.toBool(json['is_repeated']),
      totalAmount: BookingParse.toDouble(json['total_booking_amount']),
      placedAt: BookingParse.utcDate(json['created_at']),
      provider: provider == null ? null : BookingProviderModel.fromJson(provider),
      services: services,
      serviceCount: BookingParse.toInt(json['total_service_count'], fallback: services.length),
    );
  }
}

class EasyRebookService {
  final String serviceId;
  final String serviceName;
  final String? imageFullPath;
  final String variantKey;
  final double currentUnitCost;
  final double bookedUnitCost;
  final bool isAvailable;
  final bool isPriceChanged;

  const EasyRebookService({
    this.serviceId = '',
    this.serviceName = '',
    this.imageFullPath,
    this.variantKey = '',
    this.currentUnitCost = 0,
    this.bookedUnitCost = 0,
    this.isAvailable = true,
    this.isPriceChanged = false,
  });

  factory EasyRebookService.fromJson(Map<String, dynamic> json) => EasyRebookService(
        serviceId: BookingParse.string(json['service_id']) ?? '',
        serviceName: BookingParse.string(json['service_name']) ?? '',
        imageFullPath: BookingParse.string(json['service_image']),
        variantKey: BookingParse.string(json['variant_key']) ?? '',
        currentUnitCost: BookingParse.toDouble(json['service_unit_cost']),
        bookedUnitCost: BookingParse.toDouble(json['booking_service_unit_cost']),
        isAvailable: json['is_available'] == null || BookingParse.toBool(json['is_available']),
        isPriceChanged: BookingParse.toBool(json['is_price_changed']),
      );
}

class EasyRebookPage {
  final List<EasyRebookItem> bookings;
  final int currentPage;
  final int lastPage;
  final int total;

  const EasyRebookPage({
    this.bookings = const <EasyRebookItem>[],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  const EasyRebookPage.empty() : this();

  factory EasyRebookPage.fromJson(Map<String, dynamic> json) {
    final int total = BookingParse.toInt(json['total_size']);
    final int limit = BookingParse.toInt(json['limit'], fallback: 10);

    return EasyRebookPage(
      bookings: BookingParse.objectList<EasyRebookItem>(json['data'], EasyRebookItem.fromJson),
      currentPage: BookingParse.toInt(json['offset'], fallback: 1),
      lastPage: limit > 0 ? (total / limit).ceil().clamp(1, double.infinity).toInt() : 1,
      total: total,
    );
  }
}
