import 'dart:convert';

import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.getData(
      "${AppConstants.addressUri}?limit=100&offset=1&guest_id=${Get.find<SplashController>().getGuestId()}",
    );
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData(
      '${AppConstants.zoneUri}?lat=$lat&lng=$lng',
      headers: AppConstants.configHeader,
    );
  }

  Future<Response> removeAddressByID(String id) async {
    return await apiClient.postData("${AppConstants.addressUri}/$id", {
      '_method': 'delete',
      'guest_id': Get.find<SplashController>().getGuestId(),
    });
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(
      AppConstants.addressUri,
      addressModel.toJson(),
    );
  }

  Future<Response> updateAddress(
    AddressModel addressModel,
    String addressId,
  ) async {
    return await apiClient.putData(
      '${AppConstants.addressUri}/$addressId',
      addressModel.toJson(),
    );
  }

  Future<bool> saveUserAddress(String address, String? zoneIDs) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      zoneIDs,
      sharedPreferences.getString(AppConstants.languageCode),
      sharedPreferences.getString(AppConstants.guestId),
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  Future<Response> getAddressFromGeocode(LatLng? latLng) async {
    return await apiClient.getData(
      '${AppConstants.geocodeUri}?lat=${latLng!.latitude}&lng=${latLng.longitude}',
      headers: AppConstants.configHeader,
    );
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.getData(
      '${AppConstants.searchLocationUri}?search_text=$text',
    );
  }

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData(
      '${AppConstants.placeDetailsUri}?placeid=$placeID',
    );
  }

  Future<Response> changePostServiceAddress(
    String postId,
    String addressId,
  ) async {
    return await apiClient.postData(AppConstants.updatePostInfo, {
      "_method": "put",
      "post_id": postId,
      "service_address_id": addressId,
    });
  }

  Future<void> setZoneContinue(String isContinue) async {
    await sharedPreferences.setString(AppConstants.isContinueZone, isContinue);
  }

  String getZoneContinue() {
    return sharedPreferences.getString(AppConstants.isContinueZone) ?? "";
  }

  Future<bool> saveRecentAddress(AddressModel address) async {
    List<String> recent =
        sharedPreferences.getStringList(AppConstants.recentPickedLocation) ??
        [];
    recent.removeWhere((e) {
      try {
        return jsonDecode(e)['address'] == address.address;
      } catch (e) {
        return false;
      }
    });
    recent.insert(0, jsonEncode(address.toJson()));
    if (recent.length > 10) {
      recent = recent.sublist(0, 10);
    }
    return await sharedPreferences.setStringList(
      AppConstants.recentPickedLocation,
      recent,
    );
  }

  List<AddressModel> getRecentAddresses() {
    List<String> recent =
        sharedPreferences.getStringList(AppConstants.recentPickedLocation) ??
        [];
    return recent
        .map((e) {
          try {
            return AddressModel.fromJson(jsonDecode(e));
          } catch (e) {
            return null;
          }
        })
        .whereType<AddressModel>()
        .toList();
  }
}
