import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CampaignDetailsShimmerWidget extends StatelessWidget {
  final bool isCategoryAndMixedWise;

  const CampaignDetailsShimmerWidget({super.key, this.isCategoryAndMixedWise = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
      child: isCategoryAndMixedWise
          ? const CampaignCategoryShimmerList()
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Shimmer(
                  child: CampaignShimmerBone(
                    height: 22, width: Get.width * 0.4,
                    color: CampaignShimmerBone.boneColorOf(context),
                  ),
                ),
              ),
              Gaps.verticalGapOf(Dimensions.padding16),

              const CampaignServiceShimmerList(),
            ]),
    );
  }
}

class CampaignServiceShimmerList extends StatelessWidget {
  final int itemCount;

  const CampaignServiceShimmerList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    final Color boneColor = CampaignShimmerBone.boneColorOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      child: Shimmer(
        child: Column(
          children: List<Widget>.generate(itemCount, (int index) => Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.padding16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  CampaignShimmerBone(height: 18, width: Get.width * 0.45, color: boneColor),
                  Gaps.verticalGapOf(Dimensions.padding10),
                  CampaignShimmerBone(height: 14, width: Get.width * 0.25, color: boneColor),
                  Gaps.verticalGapOf(Dimensions.padding10),
                  CampaignShimmerBone(height: 16, width: Get.width * 0.35, color: boneColor),
                ]),
              ),
              Gaps.horizontalGapOf(Dimensions.padding12),

              CampaignShimmerBone(height: 110, width: 110, color: boneColor),
            ]),
          )),
        ),
      ),
    );
  }
}

class CampaignCategoryShimmerList extends StatelessWidget {
  final int itemCount;

  const CampaignCategoryShimmerList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final Color boneColor = CampaignShimmerBone.boneColorOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      child: Shimmer(
        child: Column(
          children: List<Widget>.generate(itemCount, (int index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
            child: Row(children: <Widget>[
              CampaignShimmerBone(height: 20, width: Get.width * 0.4, color: boneColor),
              const Spacer(),
              CampaignShimmerBone(height: 28, width: 28, color: boneColor),
            ]),
          )),
        ),
      ),
    );
  }
}

class CampaignShimmerBone extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const CampaignShimmerBone({super.key, required this.height, required this.width, required this.color});

  static Color boneColorOf(BuildContext context) =>
      Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Dimensions.radius12)),
    );
  }
}
