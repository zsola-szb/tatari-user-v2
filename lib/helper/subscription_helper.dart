import 'package:tatarigigs_user/feature/subscription/widget/subscription_success_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SubscriptionHelper {

  void showSuccessDialog(){
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SubscriptionSuccessWidget();
      },
    );
  }
}