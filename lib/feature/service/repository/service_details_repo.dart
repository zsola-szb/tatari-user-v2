import 'package:tatarigigs_user/api/remote/client_api.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/app_constants.dart';

class ServiceDetailsRepo {
  final ApiClient apiClient;
  ServiceDetailsRepo({required this.apiClient});

  Future<Response> getServiceDetails(String slug, String fromPage) async {

    if(fromPage=="search_page"){
      return await apiClient.getData('${AppConstants.serviceDetailsUri}/$slug?attribute=service');
    }else{
      return await apiClient.getData('${AppConstants.serviceDetailsUri}/$slug');
    }

  }
}
