import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ServiceBiddingButton extends StatelessWidget {
  final Service service;
  final bool popBeforeOpen;
  final bool isDisabled;
  const ServiceBiddingButton({super.key, required this.service, this.popBeforeOpen = true, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () {
        if (popBeforeOpen) Get.back();
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: Get.context!,
          builder: (context) => const BottomCreatePostDialog(),
        );
        Get.find<CreatePostController>().resetCreatePostValue(removeService: false);
        Get.find<CreatePostController>().updateSelectedService(service);
      },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            color: context.customThemeColors.secondaryBackGroundColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
          child: Center(
            child: Hero(
              tag: 'provide_image',
              child: SvgPicture.asset(Images.toolIcon, height: 20, width: 20),
            ),
          ),
        ),
      ),
    );
  }
}
