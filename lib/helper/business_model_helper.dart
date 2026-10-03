import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BusinessModelHelper {
  const BusinessModelHelper._();

  static BusinessModel get current =>
      BusinessModel.fromApi(Get.find<SplashController>().configModel.content?.businessModel);

  static bool get isOpenMarket => current == BusinessModel.openMarket;

  static bool get isCurated => current == BusinessModel.curated;
}
