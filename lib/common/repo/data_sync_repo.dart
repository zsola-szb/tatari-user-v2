import 'dart:convert';
import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/common/models/api_response_model.dart';
import 'package:tatarigigs_user/helper/db_helper.dart';
import 'package:tatarigigs_user/helper/get_di.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:drift/drift.dart';
import 'package:get/get_connect/http/src/response/response.dart';



class DataSyncRepo {
  final ApiClient apiClient;
  final SharedPreferences? sharedPreferences;

  DataSyncRepo({required this.apiClient, required this.sharedPreferences});

  Future<ApiResponseModel<T>> fetchData<T>(String uri, DataSourceEnum source, {dynamic body, ApiMethodType method = ApiMethodType.get} ) async {
    try {
      return source == DataSourceEnum.client || _isACachesDisable() ? await _fetchFromClient<T>(uri, method: method, body: body) : await _fetchFromLocalCache<T>(uri);
    } catch (e) {
      debugPrint('DataSyncRepo: ===> $source $e ($uri)');

      return ApiResponseModel.withError(e);
    }
  }

  Future<ApiResponseModel<T>> _fetchFromClient<T>(String uri, {dynamic body,ApiMethodType method = ApiMethodType.get}) async {
    final response = await _fetchResponseFromClient(uri, body: body, method: method);
    if(response.statusCode == 200) {
      final cacheData = CacheResponseCompanion(
        endPoint: Value(uri),
        header: Value(jsonEncode(response.headers)),
        response: Value(jsonEncode(response.body)),
      );

      if(_isAppCachesActive()) {
        await DbHelper.insertOrUpdate(id: uri, data: cacheData);
      }
    }

    return ApiResponseModel.withSuccess(response as T);
  }

  Future<Response> _fetchResponseFromClient (String uri,{dynamic body, ApiMethodType method = ApiMethodType.get}){
    if(method == ApiMethodType.get){
      return apiClient.getData(uri);
    }else{
      return apiClient.postData(uri, body);
    }
  }

  bool _isAppCachesActive()=> (AppConstants.cachesType == LocalCachesTypeEnum.all || AppConstants.cachesType == LocalCachesTypeEnum.app);
  bool _isACachesDisable() => AppConstants.cachesType == LocalCachesTypeEnum.none;

  Future<ApiResponseModel<T>> _fetchFromLocalCache<T>(String uri) async {
    CacheResponseData? cacheData = await database.getCacheResponseById(uri);

    if (cacheData != null && jsonDecode(cacheData.response) != null) {
      return ApiResponseModel.withSuccess(cacheData as T);
    } else {
      return ApiResponseModel.withError("No local data found for $uri");
    }
  }
}
