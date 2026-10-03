import 'dart:convert';
import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/feature/search/model/search_suggestion_model.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSearchData({required String query,required int offset, SearchResultType type = SearchResultType.all, int? limit, String? sortByType, double? latitude, double? longitude, double? minPrice, double ? maxPrice, List<String>? ratings, List<String>? categoryIdes }) async {


    Map<String, dynamic> data = {
      "string": query,
      "sort_by_type": sortByType,
      "min_price": minPrice ?? 0,
      "max_price": maxPrice ?? 0,
    };
    if(ratings != null && ratings.isNotEmpty){
      data.addAll({
        "rating" : ratings
      });
    }
    if(limit != null){
      data.addAll({
        "limit" : limit,
        "offset" : offset,
      });
    }
    if(latitude != null && longitude != null){
      data.addAll({
        "latitude" : latitude,
        "longitude" : longitude,
      });
    }
    if(categoryIdes !=null && categoryIdes.isNotEmpty){
      data.addAll({
        "category_ids" : categoryIdes
      });
    }
    return await apiClient.postData(_uriFor(type), data);
  }

  String _uriFor(SearchResultType type){
    switch(type){
      case SearchResultType.all:
        return AppConstants.searchUri;
      case SearchResultType.services:
        return AppConstants.searchServicesUri;
      case SearchResultType.providers:
        return AppConstants.searchProvidersUri;
    }
  }

  Future<Response> getSearchSuggestion({String? query}) async {

    return apiClient.getData("${AppConstants.searchSuggestion}?string=${query?.trim()}");
  }

  Future<bool> saveSearchHistory(List<SearchSuggestion> searchHistories) async {
    return await sharedPreferences.setStringList(
      AppConstants.searchHistory,
      searchHistories.map((SearchSuggestion suggestion) => jsonEncode(suggestion.toJson())).toList(),
    );
  }

  List<SearchSuggestion> getSearchHistory() {
    final List<String> storedHistories = sharedPreferences.getStringList(AppConstants.searchHistory) ?? <String>[];

    return storedHistories.map(_decodeHistory).nonNulls.toList();
  }

  SearchSuggestion? _decodeHistory(String storedHistory) {
    if(storedHistory.trim().isEmpty){
      return null;
    }

    try{
      final dynamic decoded = jsonDecode(storedHistory);
      if(decoded is Map<String, dynamic>){
        return SearchSuggestion.fromJson(decoded);
      }
    } catch (_) {}

    return SearchSuggestion(name: storedHistory);
  }

}
