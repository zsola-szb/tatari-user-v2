import 'package:get/get.dart';

class BookingPlaceResult {
  final bool isSuccess;
  final String? bookingId;
  final String? readableId;
  final String? token;
  final String? message;

  const BookingPlaceResult({
    required this.isSuccess,
    this.bookingId,
    this.readableId,
    this.token,
    this.message,
  });

  const BookingPlaceResult.failure(this.message): isSuccess = false, bookingId = null, readableId = null, token = null;

  factory BookingPlaceResult.fromResponse(
    Response response, {
    required List<String> successCodes,
  }) {
    final dynamic body = response.body;
    if (response.statusCode != 200 || body is! Map) {
      return BookingPlaceResult.failure(_messageOf(body) ?? response.statusText);
    }
    if (!successCodes.contains(body['response_code']?.toString())) {
      return BookingPlaceResult.failure(_messageOf(body) ?? response.statusText);
    }

    final Map<dynamic, dynamic>? booking = _firstBooking(body['data'] ?? body['content']);
    if (booking == null) {
      return BookingPlaceResult(isSuccess: true, message: _messageOf(body));
    }

    return BookingPlaceResult(
      isSuccess: true,
      bookingId: _stringValue(booking['booking_id'] ?? booking['id']),
      readableId: booking['readable_id']?.toString(),
      token: booking['token']?.toString(),
      message: _messageOf(body),
    );
  }

  static Map<dynamic, dynamic>? _firstBooking(dynamic content) {
    if (content is Map) {
      return content;
    }
    if (content is List && content.isNotEmpty && content.first is Map) {
      return content.first as Map<dynamic, dynamic>;
    }
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value is List) {
      return value.isEmpty ? null : value.first?.toString();
    }
    return value?.toString();
  }

  static String? _messageOf(dynamic body) {
    if (body is! Map) {
      return null;
    }
    final dynamic errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      final dynamic first = errors.first;
      if (first is Map && first['message'] != null) {
        return first['message'].toString();
      }
    }
    return body['message']?.toString();
  }
}
