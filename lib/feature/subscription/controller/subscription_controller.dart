import 'package:tatarigigs_user/api/remote/api_checker.dart';
import 'package:tatarigigs_user/common/widgets/custom_snackbar.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/profile/model/userinfo_model.dart';
import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/feature/subscription/model/subscription_termsn_and_condition_model.dart';
import 'package:tatarigigs_user/feature/subscription/repository/subscription_repo.dart';
import 'package:tatarigigs_user/helper/route_helper.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController implements GetxService{
  final SubscriptionRepo subscriptionRepo;
  SubscriptionController({required this.subscriptionRepo});

   SubscriptionModel? subscriptionModel;
   SubscriptionTermsConditionModel? tramsAndCondition;
   int selectedPlanIndex = 0;
   bool isLoading = false;

  Plans? get selectedPlan {
    final List<Plans> plans = subscriptionModel?.content?.plans ?? <Plans>[];
    if (selectedPlanIndex < 0 || selectedPlanIndex >= plans.length) {
      return null;
    }
    return plans[selectedPlanIndex];
  }

  String get subscribeButtonLabel {
    final SubscribedPlan? subscribedPlan = Get.find<UserController>().userInfoModel?.subscribedPlan;

    if (subscribedPlan == null) {
      return selectedPlan?.type == 'paid' ? 'subscribe_now'.tr : 'start_free_trial'.tr;
    }

    return selectedPlan?.id == subscribedPlan.subscriptionPlanId ? 'renew_subscription'.tr : 'shift_plan'.tr;
  }

  String get benefitSummaryText {
    final Benefits? benefits = subscriptionModel?.content?.benefits;

    if (benefits?.discount?.status == 1) {
      return '${'you_can_able_discount'.tr} ${benefits?.discount?.discount}% ${'for_all_bookings'.tr}';
    } else if (benefits?.coupon?.status == 1) {
      return 'you_can_able_coupon_from_coupon_list'.tr;
    } else {
      return '${'you_can_able_service'.tr} ${(benefits?.serviceFee?.type ?? '').tr}';
    }
  }

  Future<void> getSubscriptionList() async {
    Response response = await subscriptionRepo.getSubscriptionList();
    if(response.statusCode == 200){
      subscriptionModel = SubscriptionModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSubscriptionTerms() async {
    Response response = await subscriptionRepo.getSubscriptionTerms();
    if(response.statusCode == 200){
      tramsAndCondition = SubscriptionTermsConditionModel.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setPlanIndex(int index, {bool isUpdate = true}){
    selectedPlanIndex = index;

    if(isUpdate){
      update();
    }
  }

  Future<Response> paySubscriptionAmount(String planId, String methodName, String callBack, String platform) async{
    isLoading = true;
    update();

    Response response = await subscriptionRepo.paySubscriptionAmount(planId, methodName, callBack, platform);
    if(response.statusCode == 200){

    }else{
      ApiChecker.checkApi(response, showDefaultToaster: false);
    }

    isLoading = false;
    update();
    return response;
  }
  void setTabIndex(int index){
    subscriptionRepo.setTabIndex(index);
  }

  int? getTabIndex(){
    return subscriptionRepo.getTabIndex();
  }

  Future<Response> cancelSubscription() async{
    isLoading = true;
    update();

    Response response = await subscriptionRepo.cancelSubscription();
    if(response.statusCode == 200){
      customSnackBar('subscription_cancelled_successfully'.tr);
      await Get.find<UserController>().getUserInfo();
      Get.back();
      Get.offNamed(RouteHelper.subscriptionScreen);
    }else{
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
    return response;
  }

}