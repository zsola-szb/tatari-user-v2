
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

void customCouponSnackBar(BuildContext context, String? title, { String? subtitle,bool isError = true, double margin = Dimensions.padding10,int duration =2, Color? backgroundColor, Widget? customWidget, double borderRadius = Dimensions.radius6}) {
  if(title != null && title.isNotEmpty) {
    Get.closeAllSnackbars();
    Get.snackbar( title.tr,
      "",
      messageText: Text(
        subtitle?.tr ?? "",
        style: context.subHeading.defaultSize.overrideWith(color: Colors.white.withValues(alpha: 0.7)),
      ),
      duration: Duration(seconds: duration),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade900,
      borderRadius: Dimensions.padding10,
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding24,
          vertical: Dimensions.padding20
      ),
      icon: Image.asset(
          isError ? Images.couponWarning : Images.correctIcon,
          width: Dimensions.padding20 * 2,
          height: Dimensions.padding20 * 2
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: isError ? Colors.red : Colors.green,
      maxWidth: Dimensions.webMaxWidth,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.symmetric( horizontal : Dimensions.padding16, vertical: Dimensions.padding10),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
      reverseAnimationCurve: Curves.bounceIn ,
    );
  }
}