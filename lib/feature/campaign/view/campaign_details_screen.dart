import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/campaign/widget/campaign_category_section.dart';
import 'package:tatarigigs_user/feature/campaign/widget/campaign_details_shimmer_widget.dart';
import 'package:tatarigigs_user/feature/campaign/widget/campaign_service_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CampaignDetailsScreen extends StatefulWidget {
  final CampaignData? campaign;

  const CampaignDetailsScreen({super.key, this.campaign});

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final CampaignData? campaign = widget.campaign;
    if (campaign != null) {
      Get.find<CampaignDetailsController>().initCampaign(campaign);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CampaignData? campaign = widget.campaign;

    if (campaign == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'campaign'.tr),
        body: NoDataScreen(text: 'campaign_not_found'.tr, type: NoDataType.service),
      );
    }

    final double contentWidth = MediaQuery.sizeOf(context).width > Dimensions.webMaxWidth
        ? Dimensions.webMaxWidth : MediaQuery.sizeOf(context).width;
    final double heroHeight = contentWidth * 0.55;

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.secondaryBackGroundColor,
        floatingActionButton: const FloatingViewCartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GetBuilder<CampaignDetailsController>(
          builder: (CampaignDetailsController campaignController) {
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: RefreshIndicator(
                  onRefresh: campaignController.refreshCampaign,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            CampaignHeroHeader(coverImage: campaign.coverImageFullPath ?? '', height: heroHeight),

                            Padding(
                              padding: EdgeInsets.only(top: heroHeight - Dimensions.radius28),
                              child: CampaignInfoCard(
                                campaign: campaign,
                                categoryCount: campaignController.categoryTotalSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding3)),

                      SliverToBoxAdapter(
                        child: campaignController.isLoading
                            ? CampaignDetailsShimmerWidget(isCategoryAndMixedWise: campaign.isCategoryAndMixedWise)
                            : campaign.isCategoryAndMixedWise
                                ? CampaignCategorySection(campaignController: campaignController)
                                : CampaignServiceSection(
                                    campaignController: campaignController,
                                    scrollController: _scrollController,
                                  ),
                      ),

                      const SliverToBoxAdapter(child: ViewCartBottomSpace()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}