import 'package:tatarigigs_user/api/remote/client_api.dart';
import 'package:tatarigigs_user/util/app_constants.dart';
import 'package:get/get.dart';

class CampaignDetailsRepo {
  final ApiClient apiClient;
  CampaignDetailsRepo({required this.apiClient});

  Future<Response> getSelectedServices(String campaignId, {required int offset, required int limit}) async {
    return await apiClient.getData('${AppConstants.campaignSelectedServicesUri}/$campaignId?limit=$limit&offset=$offset');
  }

  Future<Response> getCategories(String campaignId, {required int offset, required int limit}) async {
    return await apiClient.getData('${AppConstants.campaignCategoriesUri}/$campaignId?limit=$limit&offset=$offset');
  }

  Future<Response> getCategoryServices(String campaignId, String categoryId, {required int offset, required int limit}) async {
    return await apiClient.getData('${AppConstants.campaignCategoryServicesUri}/$campaignId/$categoryId?limit=$limit&offset=$offset');
  }
}