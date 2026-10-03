import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class ApiChecker {
  static void checkApi(Response response, {bool showDefaultToaster = true}) {

    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData(response: response);
      if(Get.currentRoute != RouteHelper.getInitialRoute()){
        Get.offAllNamed(RouteHelper.getInitialRoute());
        customSnackBar("${response.statusCode!}".tr);
      }
    }if(response.statusCode == 204) {
      customSnackBar('information_not_found'.tr, showDefaultSnackBar: showDefaultToaster);
      Get.offAllNamed(RouteHelper.getInitialRoute());

    }else if(response.statusCode == 500){
      customSnackBar("${response.statusCode!}".tr, showDefaultSnackBar: showDefaultToaster);
    }

    else if((response.statusCode == 400 || response.statusCode == 403 || response.statusCode == 422) && _errorMessage(response) != null){
      customSnackBar(_errorMessage(response), showDefaultSnackBar: showDefaultToaster);
    }
    else if(response.statusCode == 429){
      customSnackBar("too_many_request".tr, showDefaultSnackBar: showDefaultToaster);
    }
    else{
      customSnackBar(_messageOf(response), showDefaultSnackBar: showDefaultToaster);
    }
  }

  static String? _errorMessage(Response response) {
    final dynamic body = response.body;
    if (body is! Map) {
      return null;
    }
    final dynamic errors = body['errors'];
    if (errors is! List || errors.isEmpty) {
      return null;
    }
    final dynamic first = errors.first;
    return first is Map ? '${first['message']}' : null;
  }

  static String _messageOf(Response response) {
    final dynamic body = response.body;
    if (body is Map && body['message'] != null) {
      return '${body['message']}';
    }
    return response.statusText ?? 'something_went_wrong'.tr;
  }
}