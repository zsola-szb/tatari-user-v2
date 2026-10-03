import 'package:tatarigigs_user/api/remote/client_api.dart';
import 'package:tatarigigs_user/util/app_constants.dart';
import 'package:get/get.dart';


class SuggestServiceRepo{
  final ApiClient apiClient;
  SuggestServiceRepo({required this.apiClient});

  Future<Response> getCategoryList() async {
    return await apiClient.getData('${AppConstants.categoryUrl}?limit=100&offset=1');
  }

  Future<Response> getSuggestedServiceList(int offset, {String status = 'all'}) async {
    return await apiClient.getData('${AppConstants.getSuggestedServiceList}?limit=30&offset=$offset&status=$status');
  }

  Future<Response> submitNewServiceRequest(Map<String,String> body) async {
    return await apiClient.postData(AppConstants.submitNewServiceRequest,body);
  }

  Future<Response> updateServiceRequest(String id, Map<String,String> body) async {
    return await apiClient.putData('${AppConstants.updateServiceRequest}/$id', body);
  }

  Future<Response> deleteServiceRequest(String id) async {
    return await apiClient.deleteData('${AppConstants.deleteServiceRequest}/$id');
  }
}