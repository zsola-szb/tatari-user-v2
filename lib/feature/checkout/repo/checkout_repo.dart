import 'dart:convert';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  CheckoutRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> placeBookingRequest({
    required String paymentMethod,
    required String zoneId,
    required AddressModel serviceAddress,
    required int isPartial,
    required String serviceLocation,
    required String serviceType,
    required String contactPersonName,
    required String contactPersonNumber,
    String? serviceAddressId,
    String? schedule,
    String? bookingType,
    String? dates,
    SignUpBody? newUserInfo,
    String? cartProviderId,
  }) async {
    return apiClient.postData(AppConstants.placeRequest, <String, dynamic>{
      'payment_method': paymentMethod,
      'zone_id': zoneId,
      'service_schedule': schedule,
      'service_address_id': serviceAddressId,
      'guest_id': Get.find<SplashController>().getGuestId(),
      'service_address': jsonEncode(serviceAddress),
      'contact_person_name': contactPersonName,
      'contact_person_number': contactPersonNumber,
      'is_partial': isPartial,
      'service_type': serviceType,
      'booking_type': bookingType,
      'dates': dates,
      'new_user_info': newUserInfo != null ? jsonEncode(newUserInfo) : null,
      'service_location': serviceLocation,
      if (cartProviderId != null && cartProviderId.isNotEmpty) 'cart_provider_id': cartProviderId,
    });
  }

  Future<Response> placeBidBookingRequest({
    required String paymentMethod,
    required String zoneId,
    required AddressModel serviceAddress,
    required int isPartial,
    required String postId,
    required String providerId,
    required String contactPersonName,
    required String contactPersonNumber,
    String? serviceAddressId,
    String? schedule,
    String? offlinePaymentId,
  }) async {
    return apiClient.postData(AppConstants.placeRequest, <String, dynamic>{
      'payment_method': paymentMethod,
      'zone_id': zoneId,
      'service_schedule': schedule,
      'service_address_id': serviceAddressId,
      'service_address': jsonEncode(serviceAddress),
      'contact_person_name': contactPersonName,
      'contact_person_number': contactPersonNumber,
      'post_id': postId,
      'provider_id': providerId,
      'is_partial': isPartial,
      'offline_payment_id': offlinePaymentId,
      'service_location': 'customer',
    });
  }

  Future<Response> acceptBid({
    required String postId,
    required String providerId,
    required int isPartial,
    required AddressModel serviceAddress,
    required String contactPersonName,
    required String contactPersonNumber,
    String? serviceAddressId,
  }) async {
    return apiClient.postData(AppConstants.updatePostStatus, <String, dynamic>{
      '_method': 'put',
      'post_id': postId,
      'provider_id': providerId,
      'status': 'accept',
      'service_address': jsonEncode(serviceAddress),
      'contact_person_name': contactPersonName,
      'contact_person_number': contactPersonNumber,
      'service_address_id': serviceAddressId,
      'is_partial': isPartial,
    });
  }

  Future<Response> getPostDetails({required String postId, required String bidId}) async {
    return apiClient.getData('${AppConstants.checkoutPostDetails}/$postId?post_bid_id=$bidId');
  }

  Future<Response> updatePostSchedule({
    required String postId,
    required String schedule,
  }) async {
    return apiClient.postData(AppConstants.updatePostInfo, <String, dynamic>{
      '_method': 'put',
      'post_id': postId,
      'booking_schedule': schedule,
    });
  }

  Future<Response> getOfflinePaymentMethodList() async {
    return apiClient.getData(AppConstants.offlinePaymentUri);
  }

  Future<Response> submitOfflinePaymentData({
    required String bookingId,
    required String offlinePaymentId,
    required String offlinePaymentInfo,
    required int isPartialPayment,
  }) async {
    return apiClient.postData(AppConstants.offlinePaymentDataStore, <String, dynamic>{
      'booking_id': bookingId,
      'offline_payment_id': offlinePaymentId,
      'customer_information': offlinePaymentInfo,
      'is_partial': isPartialPayment,
    });
  }

  Future<Response> checkPriceAreUpdated(String providerId) async {
    return apiClient.getData("${AppConstants.checkServicePriceUpdated}?guest_id=${Get.find<SplashController>().getGuestId()}&cart_provider_id=$providerId");
  }

  Future<Response> switchPaymentMethod({
    required String bookingId,
    required String paymentMethod,
    int isPartial = 0,
    String? offlinePaymentId,
    String? offlinePaymentInfo,
  }) async {
    return apiClient.postData(AppConstants.switchPaymentMethod, <String, dynamic>{
      'booking_id': bookingId,
      'payment_method': paymentMethod,
      'offline_payment_id': offlinePaymentId,
      'customer_information': offlinePaymentInfo,
      'is_partial': isPartial,
    });
  }

  Future<Response> checkExistingUser({required String phone}) async {
    return apiClient.postData(AppConstants.checkExistingUser, <String, dynamic>{'phone': phone});
  }

  Future<Response> getDigitalPaymentResponse({String? transactionId}) async {
    return apiClient.getData('${AppConstants.digitalPaymentResponse}?transaction_id=$transactionId');
  }

  void saveProDiscountAmount(String amount) {
    sharedPreferences.setString(AppConstants.proDiscountAmount, amount);
  }

  String? getProDiscountAmount() {
    return sharedPreferences.getString(AppConstants.proDiscountAmount);
  }
}
