import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotificationList( int offset) async {
    return await apiClient.getData('${AppConstants.notificationUri}?limit=10&offset=$offset');
  }

  Future<Response> markNotificationAsRead(String id) async {
    return await apiClient.putData('${AppConstants.notificationUri}/$id/read', <String, dynamic>{});
  }

}
