import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CancelPostRequestSheet extends StatelessWidget {
  final String postId;
  const CancelPostRequestSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    Color errorColor = context.customThemeColors.error;

    return BaseBottomSheet(
      child: GetBuilder<CreatePostController>(builder: (createPostController){
        return Padding(
          padding: EdgeInsets.fromLTRB(
            Dimensions.padding20,
            Dimensions.padding10,
            Dimensions.padding20,
            MediaQuery.of(context).padding.bottom + Dimensions.padding20,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: 64, width: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: errorColor, shape: BoxShape.circle),
              child: SvgPicture.asset(Images.deleteOutlinedIcon,
                height: 28, width: 28,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: Dimensions.padding20),

            Text('are_you_sure_cancel_service_request'.tr,
              style: context.heading.extraLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.padding12),

            Text('cancel_service_request_warning'.tr,
              style: context.body.defaultSize,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.padding24),

            Row(children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'keep_request'.tr,
                  height: 48,
                  radius: Dimensions.radius8,
                  backgroundColor: context.customThemeColors.secondaryBackGroundColor,
                  textColor: context.customThemeColors.textColor,
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(
                child: CustomButton(
                  buttonText: 'yes_cancel'.tr,
                  height: 48,
                  radius: Dimensions.radius8,
                  backgroundColor: errorColor,
                  isLoading: createPostController.isCancelingPost,
                  onPressed: () => _cancelRequest(createPostController),
                ),
              ),
            ]),
          ]),
        );
      }),
    );
  }

  Future<void> _cancelRequest(CreatePostController createPostController) async {
    bool isSuccess = await createPostController.cancelPostRequest(postId);
    if(isSuccess){
      Get.back();
   //   createPostController.getMyPostList(1, reload: true);
      Get.offNamed(RouteHelper.getMyPostScreen());
    }
  }
}
