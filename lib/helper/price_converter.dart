import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class PriceConverter {

  static String getCurrency() {
    String currencySymbol = Get.find<SplashController>().configModel.content?.currencySymbol ?? "";
   return currencySymbol;
  }

  static String convertPrice(double? price, {int ? decimalPointCount,double? discount, String? discountType, bool isShowLongPrice = false}) {
    final double defaultPrice = price ?? 0;
    double finalPrice = defaultPrice;

    if(discount != null && discountType != null){
      if(discountType == 'amount') {
        finalPrice = discount > defaultPrice ? 0 : defaultPrice - discount;

      }else if(discountType == 'percent') {
        finalPrice = defaultPrice - ((discount / 100) * defaultPrice);
      }
    }

    final content = Get.find<SplashController>().configModel.content;
    final int decimalPoint = decimalPointCount ?? int.tryParse(content?.currencyDecimalPoint ?? '') ?? 2;
    final bool isRightSide = content?.currencySymbolPosition == 'right' && Get.find<LocalizationController>().isLtr == true;

    final String formattedPrice = '${isRightSide ? '' : getCurrency()}'
        '${finalPrice.toStringAsFixed(decimalPoint)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        '${isRightSide ? getCurrency() : ''}';

    return isShowLongPrice == true ? formattedPrice : longToShortPrice(formattedPrice);
  }

  static double convertWithDiscount(double price, double discount, String discountType) {
    if(discountType == 'amount' || discountType == 'mixed') {
      price = price - discount;
    }else if(discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }


  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : getCurrency()} ${'off'.tr}';
  }
  static String percentageOrAmount(String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : getCurrency()} ${'off'.tr}';  }


  static String longToShortPrice(String price){
    return price.length > 15 ?
    "${price.substring(0, 12)}....${price.substring(price.length - 1,price.length)}":
    price;
  }
}