import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/styles.dart' as context;
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

void customSnackBar(String? message,
    {ToasterMessageType type = ToasterMessageType.error,
      double margin = Dimensions.padding10,int duration =2,
      Color? backgroundColor, Widget? customWidget, double borderRadius = Dimensions.radius6,
      bool showDefaultSnackBar = true,
      String? icon, String? toasterTitle,
    }) {
  if(message != null && message.isNotEmpty) {
    // if(showDefaultSnackBar){
    //
    //   ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    //
    //     content:  Material(
    //       color: Colors.transparent,
    //       child: Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: const Color(0xFF393f47), borderRadius: BorderRadius.circular(Dimensions.radius8),
    //           ),
    //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    //           child: customWidget ?? Row(  mainAxisSize: toasterTitle != null ?  MainAxisSize.max : MainAxisSize.min, children: [
    //             icon !=null  ? Image.asset(icon, width: 25,) : CustomToasterIcon(type: type),
    //             const SizedBox(width: Dimensions.padding10),
    //
    //             Flexible(
    //               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //                 if(toasterTitle !=null) Padding(
    //                   padding: const EdgeInsets.only(bottom: 2),
    //                   child: Text(toasterTitle.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Colors.white), maxLines: 3, overflow: TextOverflow.ellipsis,),
    //                 ),
    //                 Text(message, style: context.subHeading.defaultSize.copyWith(color: Colors.white.withValues(alpha:0.8), height: toasterTitle !=null ? 1.0 : 1.2), maxLines: 3, overflow: TextOverflow.ellipsis),
    //               ]),
    //             ),
    //           ]),
    //         ),
    //       ),
    //     ),
    //     padding: const EdgeInsets.only(bottom: 0),
    //     margin: const EdgeInsets.symmetric( horizontal : Dimensions.padding16, vertical: Dimensions.padding10),
    //     behavior: SnackBarBehavior.floating,
    //     duration: Duration(seconds: duration),
    //     backgroundColor: backgroundColor ?? Colors.transparent,
    //     elevation: 0,
    //     clipBehavior: Clip.none,
    //
    //   ));
    //
    // }else{
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: duration),
        overlayBlur: 0.0,
        messageText: customWidget ?? Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF393f47),
                borderRadius: BorderRadius.circular(Dimensions.radius8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                icon != null  ? Image.asset(icon, width: 25,) : CustomToasterIcon(type: type),
                const SizedBox(width: Dimensions.padding10),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if(toasterTitle !=null) Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(toasterTitle.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Colors.white), maxLines: 3, overflow: TextOverflow.ellipsis,),
                    ),
                    Text(message, style: context.subHeading.defaultSize.copyWith(color: Colors.white.withValues(alpha:0.8), height: toasterTitle !=null ? 1.0 : 1.2), maxLines: 3, overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ]),
            ),
          ),
        ),
        maxWidth: Dimensions.webMaxWidth,
        snackStyle: SnackStyle.GROUNDED,
        margin: const EdgeInsets.symmetric( horizontal : Dimensions.padding16, vertical: Dimensions.padding10),
        borderRadius: borderRadius,
        isDismissible: true,

        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
        reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      ));
  //  }
  }
}


class CustomToasterIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final ToasterMessageType type;
  final Color checkColor;

  const CustomToasterIcon({
    super.key,
    required this.type,
    this.size = Dimensions.padding20,
    this.backgroundColor,
    this.checkColor = Colors.white,
  });

  ({Color color, IconData icon}) _getDataByType(BuildContext context) {
    switch(type) {
      case ToasterMessageType.success:
        return (color: context.customThemeColors.success, icon: Icons.check);
      case ToasterMessageType.error:
        return (color: context.customThemeColors.error, icon: Icons.close);

      case ToasterMessageType.info:
        return (color: context.customThemeColors.info, icon: Icons.info_outline);
    }
  }

  @override
  Widget build(BuildContext context) {

    final data = _getDataByType(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? data.color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Icon(
          data.icon,
          size: size * 0.7, // Relative sizing
          color: checkColor,
        ),
      ),
    );
  }
}