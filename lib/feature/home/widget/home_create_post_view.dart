import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeCreatePostView extends StatelessWidget {
  final bool showShimmer;
  const HomeCreatePostView({super.key, required this.showShimmer}) ;

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = Get.isDarkMode
        ? context.customThemeColors.secondaryBackGroundColor : const Color(0xFFECEEF7);

    return showShimmer ? const HomeCreatePostViewShimmer() : Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        border: Border.all(color: surfaceColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("request_a_custom_service".tr, style: context.heading.large,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.padding4),
                Text("create_post_text".tr, style: context.body.defaultSize,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.padding8),
                InkWell(
                  onTap: ()=> Get.toNamed(RouteHelper.getCreatePostScreen()),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text("create_post".tr, style: heading.large.overrideWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                    const SizedBox(width: Dimensions.padding8),
                    SvgPicture.asset(
                      Images.arrowIcon, width: 16, height: 16,
                      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding16),
          SvgPicture.asset(Images.customizedBookingRequest, width: 70, height: 70),
        ],
      ),
    );
  }
}

class HomeCreatePostViewShimmer extends StatelessWidget {
  const HomeCreatePostViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Shimmer(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 18, width: 160, color: Theme.of(context).shadowColor),
                  const SizedBox(height: Dimensions.padding8),
                  Container(height: 12, width: double.infinity, color: Theme.of(context).shadowColor),
                  const SizedBox(height: 4),
                  Container(height: 12, width: 140, color: Theme.of(context).shadowColor),
                  const SizedBox(height: Dimensions.padding10),
                  Container(height: 16, width: 100, color: Theme.of(context).shadowColor),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.padding16),
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
