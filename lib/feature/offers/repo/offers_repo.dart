import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersRepo {
  final ApiClient apiClient;

  OffersRepo({required this.apiClient});

  Future<Response> getOffersList({
    required int offset,
    int limit = 10,
    String query = '',
    String? sortByType,
    double? minPrice,
    double? maxPrice,
    List<String>? ratings,
    List<String>? categoryIds,
    int? serviceAvailability,
    double? latitude,
    double? longitude,
  }) async {

    final Map<String, dynamic> body = <String, dynamic>{
      'string': query,
      'sort_by_type': sortByType ?? '',
      'limit': limit,
      'offset': offset,
    };

    if(ratings != null && ratings.isNotEmpty){
      body['rating'] = ratings;
    }
    if(minPrice != null && maxPrice != null){
      body['min_price'] = minPrice;
      body['max_price'] = maxPrice;
    }
    if(categoryIds != null && categoryIds.isNotEmpty){
      body['category_ids'] = categoryIds;
    }
    if(serviceAvailability != null){
      body['service_availability'] = serviceAvailability;
    }
    if(latitude != null && longitude != null){
      body['latitude'] = latitude;
      body['longitude'] = longitude;
    }

    return await apiClient.postData(AppConstants.offerListUri, body);
  }
}
