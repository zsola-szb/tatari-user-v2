import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceDetailsShimmerWidget extends StatelessWidget {
  const ServiceDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double heroHeight = ServiceHeroHeader.coverHeight(context);
    final Color boneColor = Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor;

    return FooterBaseView(
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Stack(
            children: [
              Column(
                children: [
                  Shimmer(child: Container(height: heroHeight, width: double.infinity, color: boneColor)),

                  Container(
                    width: double.infinity,
                    color: context.customThemeColors.backGroundColor,
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    child: Shimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bone(height: 20, width: Get.width * 0.6, color: boneColor),
                          Gaps.verticalGapOf(Dimensions.padding10),
                          _bone(height: 16, width: Get.width * 0.3, color: boneColor),
                          Gaps.verticalGapOf(Dimensions.padding10),
                          _bone(height: 22, width: Get.width * 0.4, color: boneColor),
                          Gaps.verticalGapOf(Dimensions.padding10),
                          _bone(height: 14, width: double.infinity, color: boneColor),
                        ],
                      ),
                    ),
                  ),

                  Gaps.verticalGapOf(Dimensions.padding10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                    child: Column(
                      children: [
                        _cardShimmer(context, boneColor),
                        Gaps.verticalGapOf(Dimensions.padding10),
                        _cardShimmer(context, boneColor),
                        Gaps.verticalGapOf(Dimensions.padding10),
                        _cardShimmer(context, boneColor),
                      ],
                    ),
                  ),

                  Gaps.verticalGapOf(Dimensions.padding32 * 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardShimmer(BuildContext context, Color boneColor) {
    return Shimmer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _bone(height: 18, width: Get.width * 0.3, color: boneColor)),
                Container(height: 28, width: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: boneColor)),
              ],
            ),
            Gaps.verticalGapOf(Dimensions.padding16),
            _bone(height: 12, width: double.infinity, color: boneColor),
            Gaps.verticalGapOf(Dimensions.padding6),
            _bone(height: 12, width: double.infinity, color: boneColor),
            Gaps.verticalGapOf(Dimensions.padding6),
            _bone(height: 12, width: Get.width * 0.5, color: boneColor),
          ],
        ),
      ),
    );
  }

  Widget _bone({required double height, required double width, required Color color}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Dimensions.radius12)),
    );
  }
}
