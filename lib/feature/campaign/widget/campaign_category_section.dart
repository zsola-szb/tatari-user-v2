import 'package:tatarigigs_user/feature/campaign/widget/campaign_details_shimmer_widget.dart';
import 'package:tatarigigs_user/feature/campaign/widget/campaign_service_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CampaignCategorySection extends StatelessWidget {
  final CampaignDetailsController campaignController;

  const CampaignCategorySection({super.key, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    final List<CampaignCategory> categories = campaignController.categoryList;

    if(categories.isEmpty){
      return Container(
        width: double.infinity,
        color: Theme.of(context).cardColor,
        height: Get.height * 0.35,
        child: NoDataScreen(text: 'no_category_found'.tr, type: NoDataType.categorySubcategory),
      );
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder: (BuildContext context, int index) => const CampaignListDivider(),
        itemBuilder: (BuildContext context, int index) => CampaignCategoryTile(
          category: categories[index],
          campaignController: campaignController,
        ),
      ),
    );
  }
}

class CampaignCategoryTile extends StatelessWidget {
  final CampaignCategory category;
  final CampaignDetailsController campaignController;

  const CampaignCategoryTile({super.key, required this.category, required this.campaignController});

  @override
  Widget build(BuildContext context) {
    final String categoryId = category.id ?? '';
    final bool isExpanded = campaignController.isCategoryExpanded(categoryId);
    final bool isLoading = campaignController.isCategoryLoading(categoryId);
    final List<Service>? services = campaignController.servicesOf(categoryId);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      InkWell(
        onTap: () => campaignController.toggleCategory(category),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding20),
          child: Row(children: <Widget>[
            Expanded(
              child: Text(
                category.name ?? '',
                style: context.heading.large,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Gaps.horizontalGapOf(Dimensions.padding12),

            CampaignCategoryChevron(isExpanded: isExpanded),
          ]),
        ),
      ),

      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: !isExpanded ? const SizedBox(width: double.infinity)
            : isLoading || services == null
                ? const Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.padding4),
                    child: CampaignServiceShimmerList(itemCount: 2),
                  )
                : services.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding20),
                        child: Text('no_service_found'.tr, style: context.body.small),
                      ) : CampaignServiceList(services: services),
      ),
    ]);
  }
}

class CampaignCategoryChevron extends StatelessWidget {
  final bool isExpanded;
  const CampaignCategoryChevron({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 28, width: 28,
        padding: const EdgeInsets.all(Dimensions.padding8),
        decoration: BoxDecoration(
          color: context.customThemeColors.secondaryBackGroundColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          Images.chevronDownArrowIcon,
          colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}