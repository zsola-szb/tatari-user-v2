import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SocialShareApp {
  final String scheme;
  final String androidPackage;
  final String iosAppId;

  const SocialShareApp({required this.scheme, required this.androidPackage, required this.iosAppId});
}

class SocialShareHelper {

  static Future<void> openAppOrStore(SocialShareApp app) async {
    final Uri appUri = Uri.parse(app.scheme);
    final Uri storeUri = GetPlatform.isIOS
        ? Uri.parse('https://apps.apple.com/app/id${app.iosAppId}')
        : Uri.parse('https://play.google.com/store/apps/details?id=${app.androidPackage}');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
  }
}
