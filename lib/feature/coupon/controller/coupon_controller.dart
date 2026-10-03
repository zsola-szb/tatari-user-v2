import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';



class CouponController extends GetxController implements GetxService{
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  List<CouponModel>? _activeCouponList;
  List<CouponModel>? get activeCouponList => _activeCouponList;

  List<CouponModel>? _expiredCouponList;
  List<CouponModel>? get expiredCouponList => _expiredCouponList;

  int _selectedCouponIndex = -1;
  int get selectedCouponIndex => _selectedCouponIndex;


  TabController? voucherTabController;
  CouponTabState __couponTabCurrentState = CouponTabState.currentCoupon;
  CouponTabState get couponTabCurrentState => __couponTabCurrentState;

  Future<void> getCouponList({bool reload = true}) async {
    if(reload){
      _activeCouponList = null;
      _expiredCouponList = null;
    }

    Response response = await couponRepo.getCouponList();
    if (response.statusCode == 200) {
      _activeCouponList = _couponsUnder(response.body, 'active_coupons');
      _expiredCouponList = _couponsUnder(response.body, 'expired_coupons');
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  /// v1 wrapped each bucket in a paginator (`content.<bucket>.data`); v2 returns
  /// the rows straight under `data.<bucket>`.
  List<CouponModel> _couponsUnder(dynamic body, String bucket) {
    if (body is! Map) {
      return <CouponModel>[];
    }
    final dynamic root = body['data'] ?? body['content'];
    if (root is! Map) {
      return <CouponModel>[];
    }
    final dynamic group = root[bucket];
    final dynamic rows = group is Map ? group['data'] : group;
    if (rows is! List) {
      return <CouponModel>[];
    }
    return rows
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> row) => CouponModel.fromJson(row))
        .toList();
  }

  Future<ResponseModel> applyCoupon(String  couponCode) async {
    _isLoading = true;
    update();

    Response response = await couponRepo.applyCoupon(couponCode);
    if(response.statusCode == 200 && response.body['response_code'] == 'coupon_applied_200'){

      for( int i = 0 ; i < _activeCouponList!.length - 1; i ++){
        if(_activeCouponList?[i].couponCode == couponCode || (_activeCouponList?[i].couponCode?.toLowerCase() == couponCode.toLowerCase())){
          _activeCouponList![i].isUsed = 1;
        }else{
          _activeCouponList![i].isUsed = 0;
        }
      }
      await Get.find<CartController>().refreshCart();

      _isLoading = false;
      update();
      return ResponseModel(true, _messageOf(response));
    }else{
      _isLoading = false;
      update();

      return ResponseModel(false, _messageOf(response));
    }
  }

  /// v2 answers an unknown or expired code with a plain 404 page rather than
  /// JSON, so the body is not always a map to read `message` out of.
  String _messageOf(Response response) {
    final dynamic body = response.body;
    if (body is Map && body['message'] is String) {
      return body['message'];
    }
    return response.statusText ?? 'coupon_not_found'.tr;
  }



  Future<void> removeCoupon({ int? index, bool fromCheckout = false}) async {
    _isLoading = true;
    update();
    Response response = await couponRepo.removeCoupon();
    if(response.statusCode == 200 && response.body['response_code'] == 'default_update_200'){
      await Get.find<CartController>().refreshCart();
      if(!fromCheckout){
        Get.back();
      }
      customSnackBar("coupon_removed_successfully".tr, toasterTitle: "removed".tr);
      if(index!=null){
        _activeCouponList?[index].isUsed = 0;
      }

    }else{

      if(!fromCheckout){
        Get.back();
        customSnackBar(_messageOf(response), type : ToasterMessageType.success);
      }
    }
    _isLoading = false;
    update();
  }



  void updateTabBar(CouponTabState couponTabState, {bool isUpdate = true}){
    __couponTabCurrentState = couponTabState;
    if(isUpdate){
      update();
    }
  }

  void updateSelectedCouponIndex({int? index, bool shouldUpdate = true}){
    if( index !=null ){
      _selectedCouponIndex = index;
    }
    if(shouldUpdate){
      update();
    }
  }
}

enum CouponTabState {
  currentCoupon,
  usedCoupon
}