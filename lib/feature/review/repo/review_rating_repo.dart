import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ReviewRatingRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  ReviewRatingRepo({required this.sharedPreferences,required this.apiClient});

  Future<Response> submitReview({required ReviewBody reviewBody}) async {
    return await apiClient.postData(AppConstants.serviceReview, reviewBody.toJson());
  }
  Future<Response> getReviewList({required String bookingId}) async {
    return await apiClient.getData('${AppConstants.bookingReviewList}?booking_id=$bookingId');
  }

  Future<Response> getCustomerReviews({
    required String id,
    required ReviewSource source,
    required int offset,
    required int limit,
  }) async {
    final String uri = switch(source){
      ReviewSource.service => '${AppConstants.serviceReviewListUri}/$id',
      ReviewSource.provider => '${AppConstants.getProviderDetails}/$id/reviews',
    };
    return await apiClient.getData('$uri?offset=$offset&limit=$limit');
  }
}