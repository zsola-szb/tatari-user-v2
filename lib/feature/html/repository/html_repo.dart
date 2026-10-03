import 'package:get/get_connect/http/src/response/response.dart';
import 'package:tatarigigs_user/api/remote/client_api.dart';
import 'package:tatarigigs_user/util/app_constants.dart';

class HtmlRepository{
  final ApiClient apiClient;
  HtmlRepository({required this.apiClient});

  Future<Response> getPagesContent(String pageKey) async {
    return await apiClient.getData('${AppConstants.pagesDetailsApi}/$pageKey');
  }

}