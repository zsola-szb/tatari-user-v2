import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ContactInfoHelper {
  const ContactInfoHelper._();

  static UserInfoModel? get _user => Get.find<AuthController>().isLoggedIn()
      ? Get.find<UserController>().userInfoModel : null;

  static String get profileName {
    final UserInfoModel? user = _user;
    if (user == null) {
      return '';
    }
    return '${clean(user.fName)} ${clean(user.lName)}'.trim();
  }

  static String get profilePhone => clean(_user?.phone);

  static String resolveName({String? fallbackName}) {
    final String guestName = clean(Get.find<LocationController>().guestContactName);
    if (guestName.isNotEmpty) {
      return guestName;
    }
    return fallbackName != null ? clean(fallbackName) : profileName;
  }

  static String resolvePhone({String? fallbackPhone}) {
    final String guestPhone = clean(Get.find<LocationController>().guestContactNumber);
    if (guestPhone.isNotEmpty) {
      return guestPhone;
    }
    return fallbackPhone != null ? clean(fallbackPhone) : profilePhone;
  }

  static bool hasContactInfo({String? fallbackName, String? fallbackPhone}) =>
      resolveName(fallbackName: fallbackName).isNotEmpty &&
      resolvePhone(fallbackPhone: fallbackPhone).isNotEmpty;

  static String clean(String? value) {
    if (value == null || value == 'null') {
      return '';
    }
    return value.replaceAll('null', '').trim();
  }
}
