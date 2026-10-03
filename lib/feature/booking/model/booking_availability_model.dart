import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';
import 'package:get/get.dart';

class RebookServiceAvailability {
  final String serviceId;
  final String serviceName;
  final String variantKey;
  final double currentPrice;
  final double bookedPrice;
  final bool isAvailable;
  final bool isPriceChanged;

  const RebookServiceAvailability({
    this.serviceId = '',
    this.serviceName = '',
    this.variantKey = '',
    this.currentPrice = 0,
    this.bookedPrice = 0,
    this.isAvailable = true,
    this.isPriceChanged = false,
  });

  factory RebookServiceAvailability.fromJson(Map<String, dynamic> json) => RebookServiceAvailability(
        serviceId: BookingParse.string(json['service_id']) ?? '',
        serviceName: BookingParse.string(json['service_name']) ?? '',
        variantKey: BookingParse.string(json['variant_key']) ?? '',
        currentPrice: BookingParse.toDouble(json['service_unit_cost']),
        bookedPrice: BookingParse.toDouble(json['booking_service_unit_cost']),
        isAvailable: BookingParse.toBool(json['is_available']),
        isPriceChanged: BookingParse.toBool(json['is_price_changed']),
      );

  bool get showPreviousPrice => isAvailable && isPriceChanged && bookedPrice != currentPrice;

  String get displayName => variantKey.isEmpty ? serviceName : '$serviceName-$variantKey';
}

class BookingAvailabilityModel {
  final bool isSuccess;
  final bool isProviderAvailable;
  final List<RebookServiceAvailability> services;
  final String? message;

  const BookingAvailabilityModel({
    this.isSuccess = false,
    this.isProviderAvailable = true,
    this.services = const <RebookServiceAvailability>[],
    this.message,
  });

  const BookingAvailabilityModel.failure(this.message)
      : isSuccess = false,
        isProviderAvailable = true, services = const <RebookServiceAvailability>[];

  factory BookingAvailabilityModel.fromResponse(Response response) {
    final dynamic body = response.body;
    if (response.statusCode != 200 || body is! Map) {
      return BookingAvailabilityModel.failure(
        body is Map ? body['message']?.toString() : response.statusText,
      );
    }

    final Map<String, dynamic>? booking = BookingParse.object(body['data']);
    if (booking == null) {
      return BookingAvailabilityModel.failure(body['message']?.toString());
    }

    return BookingAvailabilityModel(
      isSuccess: true,
      isProviderAvailable: BookingParse.toBool(booking['is_provider_available']),
      services: BookingParse.objectList<RebookServiceAvailability>(
        booking['services'],
        RebookServiceAvailability.fromJson,
      ),
      message: body['message']?.toString(),
    );
  }
}
