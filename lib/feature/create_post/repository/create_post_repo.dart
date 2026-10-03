import 'package:tatarigigs_user/api/remote/client_api.dart';
import 'package:tatarigigs_user/feature/create_post/model/create_post_body.dart';
import 'package:tatarigigs_user/util/app_constants.dart';
import 'package:get/get.dart';

class CreatePostRepo{
  final ApiClient apiClient;
  CreatePostRepo({required this.apiClient});


  Future<Response> createCustomPost(CreatePostBody body)  async {
    return await apiClient.postData(AppConstants.createCustomizedPost, body.toJson());
  }

  Future<Response> getMyPostList(int offset, {String? status})  async {
    return await apiClient.getData("${AppConstants.getMyPostList}?limit=10&offset=$offset&filter=$status");
  }

  Future<Response> getPostDetails(String postId) async {
    return await apiClient.getData("${AppConstants.getPostDetails}/$postId");
  }

  Future<Response> getProvidersOfferList(int offset, String postId) async {
    return await apiClient.getData("${AppConstants.getInterestedProviderList}?post_id=$postId&limit=10&offset=$offset");
  }

  Future<Response> getProviderBidDetails(String postId, String providerId) async {
    return await apiClient.getData("${AppConstants.getProviderBidDetails}?post_id=$postId&provider_id=$providerId");
  }

  Future<Response> updatePostStatus(String postId, String providerId, String status,{int? isPartial, String? serviceAddressId, String? serviceAddress}) async {

    return await apiClient.postData(
      AppConstants.updatePostStatus,
      {
        "_method":"put",
        "post_id":postId,
        "provider_id":providerId,
        "status": status,
        "service_address": serviceAddress,
        "service_address_id": serviceAddressId,
        "is_partial": isPartial,

      }
    );
  }

  Future<Response> updatePostRequest(String postId, {required String description, required List<String> instructions, String? schedule, String? serviceAddressId, String? serviceId, String? serviceName, String? categoryId, String? subCategoryId, String? contactPersonName, String? contactPersonNumber}) async {
    return await apiClient.postData(
      '${AppConstants.updatePostInfo}/$postId',
      {
        "_method": "put",
        "service_description": description,
        "additional_instructions": instructions,
        "booking_schedule": ?schedule,
        if(serviceAddressId != null && serviceAddressId.isNotEmpty) "service_address_id": serviceAddressId,
        if(serviceId != null && serviceId.isNotEmpty) "service_id": serviceId,
        if(serviceName != null && serviceName.isNotEmpty) "service_name": serviceName,
        if(categoryId != null && categoryId.isNotEmpty) "category_id": categoryId,
        if(subCategoryId != null && subCategoryId.isNotEmpty) "sub_category_id": subCategoryId,
        if(contactPersonName != null && contactPersonName.isNotEmpty) "contact_person_name": contactPersonName,
        if(contactPersonNumber != null && contactPersonNumber.isNotEmpty) "contact_person_number": contactPersonNumber,
      }
    );
  }

  Future<Response> deletePost(String postId) async {
    return await apiClient.deleteData("${AppConstants.deletePost}/$postId");
  }

  Future<Response>  makePayment({String? paymentMethod,String? postId, String? providerId, String? address,
    String? serviceAddressID,String? schedule,String? zoneId, int? isPartial, String? offlinePaymentId, String? customerInformation
  }) async {
    return await apiClient.postData(AppConstants.placeRequest, {
      "payment_method": paymentMethod,
      "zone_id": zoneId,
      "service_schedule": schedule,
      "service_address_id": serviceAddressID,
      "service_address" : address,
      "post_id" : postId,
      "provider_id":providerId,
      "is_partial" : isPartial,
      "service_location" : "customer"
    });
  }
}