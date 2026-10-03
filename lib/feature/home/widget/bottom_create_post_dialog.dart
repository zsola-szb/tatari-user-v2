import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/util/styles.dart' as context;
import 'package:get/get.dart';

class BottomCreatePostDialog extends StatelessWidget {
  const BottomCreatePostDialog({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return pointerInterceptor();
  }

  Widget pointerInterceptor(){
    return Container(
      width: Dimensions.webMaxWidth,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20),
            topRight: Radius.circular(Dimensions.radius20),
          ),
          color: Theme.of(Get.context!).cardColor
      ),padding: const EdgeInsets.all(15),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).hintColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 4 , width: 80,
          ),
          const SizedBox(height: Dimensions.padding16,),
          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20),
            child: Image.asset(Images.bottomCreatePostMan,height: 120, width: 120,),
          ),

          Text("post_your_needs".tr, style: Get.context!.heading.large,
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.padding16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding16
            ),
            child: Text("post_your_needs_bottom".tr, style: context.body.defaultSize.copyWith(wordSpacing: 2, height: 1.3),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: Dimensions.padding24 + 10,),
          CustomButton(
            buttonText: "create_post".tr,
            height: 40,
            width: 200,
            radius: Dimensions.radius8,
            onPressed: (){
              Get.back();
              Get.toNamed(RouteHelper.getCreatePostScreen());

            },
          ),
          const SizedBox(height: Dimensions.padding24),
        ],),
    );
  }
}
