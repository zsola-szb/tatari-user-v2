import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/util/styles.dart' as context;
import 'package:get/get.dart';

class ReferWelcomeDialog extends StatelessWidget {
  const ReferWelcomeDialog({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return pointerInterceptor();
  }

  Container pointerInterceptor(){
    return Container(
        width: Dimensions.webMaxWidth,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20),
            ),
            color: Theme.of(Get.context!).cardColor
        ),

        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(height: 5, width: 40,
            decoration: BoxDecoration(
                color: Theme.of(Get.context!).hintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimensions.radius12)
            ),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.padding16 * 1.5),
          ),

          Image.asset(Images.welcomeIcon, height: 130, fit: BoxFit.fitHeight,),
          const SizedBox(height: Dimensions.padding20),

          Text("${"welcome_to".tr} ${AppConstants.appName}!", style: Get.context!.heading.large),
          const SizedBox(height: Dimensions.padding10),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16 * 2,),
            child: Text("welcome_message_for_refer".tr , maxLines: 3,
              style: context.body.defaultSize.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.padding20 * 1.3),

          CustomButton(
            buttonText: 'okay'.tr,
            width: 100,
            onPressed: () {
              Get.find<AuthController>().toggleReferralBottomSheetShow();
              Get.back();
            }
          ),

          const SizedBox(height: Dimensions.padding20),

        ]),
    );
  }
}
