import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  CartRepo({required this.apiClient, required this.sharedPreferences});

  String get _guestId => Get.find<SplashController>().getGuestId();

  String _query(Map<String, String?> params) {
    final List<String> parts = <String>[];
    params.forEach((String key, String? value) {
      if (value != null && value.isNotEmpty) {
        parts.add('$key=${Uri.encodeQueryComponent(value)}');
      }
    });
    return parts.isEmpty ? '' : '?${parts.join('&')}';
  }

  Future<Response> getCartList({int limit = 100, int offset = 1, String? providerId}) async {
    return await apiClient.getData('${AppConstants.getCartList}${_query(<String, String?>{
      'limit': '$limit',
      'offset': '$offset',
      'provider_id': providerId,
      'guest_id': _guestId,
    })}');
  }

  Future<Response> addToCart({
    required String serviceId,
    required String categoryId,
    required String subCategoryId,
    required String variantKey,
    required int quantity,
    String? providerId,
  }) async {
    return await apiClient.postData(AppConstants.addToCart, <String, dynamic>{
      'service_id': serviceId,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'variant_key': variantKey,
      'quantity': quantity,
      if (providerId != null && providerId.isNotEmpty) 'provider_id': providerId,
      if (_guestId.isNotEmpty) 'guest_id': _guestId,
    });
  }

  Future<Response> updateQuantity({required String cartId, required int quantity}) async {
    return await apiClient.putData(
      '${AppConstants.updateCartQuantity}$cartId',
      <String, dynamic>{
        'quantity': quantity,
        if (_guestId.isNotEmpty) 'guest_id': _guestId,
      },
    );
  }

  Future<Response> updateProvider({String? providerId}) async {
    return await apiClient.putData(
      AppConstants.updateCartProvider,
      <String, dynamic>{
        if (providerId != null && providerId.isNotEmpty) 'provider_id': providerId,
        if (_guestId.isNotEmpty) 'guest_id': _guestId,
      },
    );
  }

  Future<Response> removeItem({required String cartId}) async {
    return await apiClient.deleteData(
      '${AppConstants.removeCartItem}$cartId${_query(<String, String?>{'guest_id': _guestId})}',
    );
  }

  Future<Response> removeAll({String? providerId}) async {
    return await apiClient.deleteData(
      '${AppConstants.removeAllCartItem}${_query(<String, String?>{
        'provider_id': providerId,
        'guest_id': _guestId,
      })}',
    );
  }

  Future<Response> getCustomersAlsoTake({int limit = 10, int offset = 1}) async {
    return await apiClient.getData('${AppConstants.customersAlsoTake}${_query(<String, String?>{
      'limit': '$limit',
      'offset': '$offset',
      'guest_id': _guestId,
    })}');
  }

  Future<Response> getCartProviders({int limit = 10, int offset = 1}) async {
    return await apiClient.getData('${AppConstants.getCartProviders}${_query(<String, String?>{
      'limit': '$limit',
      'offset': '$offset',
      'guest_id': _guestId,
    })}');
  }

  Future<Response> getProvidersBySubCategory({required String subCategoryId}) async {
    return await apiClient.getData(
      '${AppConstants.getProviderBasedOnSubcategory}?sub_category_id=$subCategoryId',
    );
  }

  Future<Response> getServiceDetails({required String slug}) async {
    return await apiClient.getData('${AppConstants.serviceDetailsUri}/$slug');
  }
}
