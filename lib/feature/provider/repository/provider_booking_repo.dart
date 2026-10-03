import 'package:tatarigigs_user/common/models/api_response_model.dart';
import 'package:tatarigigs_user/common/repo/data_sync_repo.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ProviderBookingRepo extends DataSyncRepo{
  ProviderBookingRepo({required super.apiClient, required SharedPreferences super.sharedPreferences});


  Future<Response> getCategoryList() async {
    return await apiClient.getData('${AppConstants.categoryUrl}?limit=100&offset=1');
  }
  Future<ApiResponseModel<T>> getProviderList<T>({
    required int offset,
    required DataSourceEnum source,
    int limit = 10,
    String? sortByType,
    int? rating,
    List<String>? categoryIds,
    int? serviceAvailability,
    double? latitude,
    double? longitude,
  }) async {
    final List<String> queryParameters = <String>[
      'limit=$limit',
      'offset=$offset',
    ];

    if (sortByType != null && sortByType.isNotEmpty) {
      queryParameters.add('sort_by_type=${Uri.encodeQueryComponent(sortByType)}');
    }

    if (latitude != null && longitude != null) {
      queryParameters.add('latitude=$latitude');
      queryParameters.add('longitude=$longitude');
    }

    return await fetchData<T>('${AppConstants.getProviderList}?${queryParameters.join('&')}', source);
  }

  Future<Response> getProviderDetails(String providerId) async {
    return await apiClient.getData("${AppConstants.getProviderDetails}/$providerId");
  }

  Future<Response> searchProviderServices({
    required String providerId,
    required int limit,
    required int offset,
    String query = '',
    String? sortByType,
    List<String>? categoryIds,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      "provider_id" : providerId,
      "limit" : limit,
      "offset" : offset,
    };

    if (query.isNotEmpty) {
      body['string'] = query;
    }
    if (sortByType != null && sortByType.isNotEmpty) {
      body['sort_by_type'] = sortByType;
    }
    if (categoryIds != null && categoryIds.isNotEmpty) {
      body['category_ids'] = categoryIds;
    }

    return await apiClient.postData(AppConstants.searchServicesUri, body);
  }

  Future<Response> updateIsFavoriteStatus({required String serviceId}) async {
    return await apiClient.postData(AppConstants.updateFavoriteProviderStatus,{
      "provider_id" : serviceId
    });
  }
}