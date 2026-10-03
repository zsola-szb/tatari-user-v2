import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  BookingRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getBookingList({
    required int offset,
    required String bookingStatus,
    required String serviceType,
    int limit = 10,
  }) {
    return apiClient.getData(
      '${AppConstants.bookingList}?limit=$limit&offset=$offset'
      '&booking_status=$bookingStatus&service_type=$serviceType',
    );
  }

  Future<Response> getBookingDetails({required String bookingId}) =>
      apiClient.getData('${AppConstants.bookingDetails}/$bookingId');

  Future<Response> getSubBookingDetails({required String subBookingId}) =>
      apiClient.getData('${AppConstants.subBookingDetails}/$subBookingId');

  Future<Response> trackBooking({required String readableId, required String phone}) =>
      apiClient.postData('${AppConstants.trackBooking}/$readableId', <String, dynamic>{'phone': phone});

  Future<Response> getEasyRebookingList({required int offset, String? providerId, int limit = 10}) {
    final String providerQuery = (providerId == null || providerId.isEmpty) ? '' : '&provider_id=$providerId';
    return apiClient.getData('${AppConstants.easyRebookingList}?limit=$limit&offset=$offset$providerQuery');
  }

  Future<Response> cancelBooking({required String bookingId}) {
    return apiClient.postData('${AppConstants.bookingCancel}/$bookingId', <String, dynamic>{
      'booking_status': 'canceled',
      '_method': 'put',
    });
  }

  Future<Response> cancelSubBooking({required String subBookingId}) =>
      apiClient.postData('${AppConstants.subBookingCancel}/$subBookingId', <String, dynamic>{});

  Future<Response> checkRebookAvailability({required String bookingId}) =>
      apiClient.getData('${AppConstants.rebookAvailabilityApi}/$bookingId?limit=100&offset=1&guest_id=${Get.find<SplashController>().getGuestId()}');

  Future<Response> addRebookToCart({required String bookingId}) {
    return apiClient.postData(AppConstants.rebookApi, <String, dynamic>{
      'booking_id': bookingId,
      'guest_id': Get.find<SplashController>().getGuestId(),
    });
  }

  Future<Response> switchPaymentMethod({
    required String bookingId,
    required String paymentMethod,
    int isPartial = 0,
    String? offlinePaymentId,
    String? offlinePaymentInfo,
  }) {
    return apiClient.postData(AppConstants.switchPaymentMethod, <String, dynamic>{
      'booking_id': bookingId,
      'payment_method': paymentMethod,
      'offline_payment_id': offlinePaymentId,
      'customer_information': offlinePaymentInfo,
      'is_partial': isPartial,
    });
  }

  Future<Response> submitOfflinePaymentData({
    required String bookingId,
    required String offlinePaymentId,
    required String offlinePaymentInfo,
    int isPartialPayment = 0,
  }) {
    return apiClient.postData(AppConstants.offlinePaymentDataStore, <String, dynamic>{
      'booking_id': bookingId,
      'offline_payment_id': offlinePaymentId,
      'customer_information': offlinePaymentInfo,
      'is_partial': isPartialPayment,
    });
  }

  Future<Response> getDigitalPaymentResponse({required String transactionId}) =>
      apiClient.getData('${AppConstants.digitalPaymentResponse}?transaction_id=$transactionId');

  Future<void> setLastIncompleteOfflineBookingId(String bookingId) =>
      sharedPreferences.setString(AppConstants.lastIncompleteOfflineBookingId, bookingId);

  String getLastIncompleteOfflineBookingId() =>
      sharedPreferences.getString(AppConstants.lastIncompleteOfflineBookingId) ?? '';
}
