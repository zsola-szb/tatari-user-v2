import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PostCreateSuccessfullyScreen extends StatelessWidget {
  const PostCreateSuccessfullyScreen({super.key}) ;
  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: 'create_custom_service'.tr, isBackButtonExist: true),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.padding16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding32, horizontal: Dimensions.padding16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  decoration: BoxDecoration(
                    color: context.customThemeColors.secondaryBackGroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Theme.of(context).primaryColor, size: 20),
                ),
                const SizedBox(height: Dimensions.padding16),

                Text("your_request_has_been_created_successfully".tr,
                  style: context.heading.extraLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding6),

                Text("stay_tuned_for_responses".tr,
                  style: context.body.defaultSize,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding20),

                CustomButton(
                  buttonText: "view_request".tr,
                  height: 40, width: 160,
                  radius: Dimensions.radius8,
                  onPressed: (){
                    Get.offNamed(RouteHelper.getMyPostScreen());
                  },
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.padding16),

            // Center(
            //   child: TextButton(
            //     onPressed: (){
            //       Get.offAllNamed(RouteHelper.getMainRoute(''));
            //     },
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.zero,
            //       minimumSize: const Size(50,30),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //     ),
            //     child: Text('go_back_to_home'.tr, style: context.subHeading.defaultSize.overrideWith(
            //       color: Get.isDarkMode ? Theme.of(context).primaryColorLight :  Theme.of(context).colorScheme.primary,
            //     )),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }
}
