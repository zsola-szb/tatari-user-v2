import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SubscriptionRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SubscriptionRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSubscriptionList() async {
    return await apiClient.getData(AppConstants.getSubscriptionPlanList);
  }

  Future<Response> getSubscriptionTerms() async {
    return await apiClient.getData(AppConstants.getSubscriptionTermsAndCondition);
  }

  Future<Response> cancelSubscription() async {
    return await apiClient.postData(AppConstants.subscriptionCancel, {});
  }

  Future<Response> paySubscriptionAmount(String planId, String methodName, String callBack, String platform) async {
    return await apiClient.postData(
        AppConstants.subscribePlan,
        {
          'plan_id' : planId,
          'payment_method' : methodName,
          'payment_platform' : platform,
          'callback' : callBack
        }
    );
  }

  void setTabIndex(int index){
    sharedPreferences.setInt(AppConstants.tabIndex, index);
  }

  int? getTabIndex(){
    return sharedPreferences.getInt(AppConstants.tabIndex);
  }

}