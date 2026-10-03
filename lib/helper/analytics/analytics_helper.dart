import 'package:tatarigigs_user/helper/analytics/tiktok_analytics.dart';
import 'package:tatarigigs_user/util/core_export.dart';

import 'facebook_analytics.dart';
import 'firebase_analytics.dart';

class AnalyticsHelper {

  static Future<void> init() async {
    await TikTokAnalyticsService.init();
  }

  static Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
    required int quantity,
    required String currency,
  }) async {
    final double totalPrice = price * quantity;

    try {
      await FirebaseAnalyticsService.logAddToCart(
        itemId: itemId,
        itemName: itemName,
        price: price,
        quantity: quantity,
        currency: currency,
      );

      await FacebookAnalyticsService.logAddToCart(
        itemId: itemId,
        currency: currency,
        totalPrice: totalPrice,
      );
      await TikTokAnalyticsService.logAddToCart(
        itemId: itemId,
        itemName: itemName,
        totalPrice: totalPrice,
        quantity: quantity,
        currency: currency,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Analytics Helper Error: $e");
      }
    }
  }
}