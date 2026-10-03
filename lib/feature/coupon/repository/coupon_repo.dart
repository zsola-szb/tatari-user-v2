import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class CouponRepo {
  final ApiClient apiClient;
  CouponRepo({required this.apiClient});

  Future<Response> getCouponList() async {
    return await apiClient.getData('${AppConstants.couponUri}&guest_id=${Get.find<SplashController>().getGuestId()}');
  }

  /// Only the coupons whose scope intersects the current cart.
  Future<Response> getApplicableCouponList({int limit = 100, int offset = 1}) async {
    return await apiClient.getData(
      '${AppConstants.applicableCouponUri}?limit=$limit&offset=$offset&guest_id=${Get.find<SplashController>().getGuestId()}',
    );
  }

  Future<Response> applyCoupon(String couponCode) async {
    return await apiClient.postData(AppConstants.applyCoupon,
        {'coupon_code':couponCode,
          "guest_id" : Get.find<SplashController>().getGuestId(),
        }
    );
  }

  /// v2 removes by DELETE — the v1 GET route is gone.
  Future<Response> removeCoupon() async {
    return await apiClient.deleteData("${AppConstants.removeCoupon}?guest_id=${Get.find<SplashController>().getGuestId()}");
  }
}