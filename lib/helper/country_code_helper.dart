import 'package:tatarigigs_user/util/core_export.dart';

class CountryCodeHelper {

  static String? getCountryCode(String? number) {
    String? countryCode;
    try{
      countryCode = codes.firstWhere((item) =>
          number!.contains('${item['dial_code']}'))['dial_code'];
    }catch(error){
      debugPrint('country error: $error');
    }
    return countryCode;
  }
}