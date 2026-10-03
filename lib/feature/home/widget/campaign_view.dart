import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignView extends StatelessWidget {
  const CampaignView({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(
        builder: (campaignController){
          if(campaignController.campaignList != null && campaignController.campaignList!.isEmpty){
            return const SizedBox();
          }else{
            return Container(
                width: MediaQuery.of(context).size.width,
                height: 340,
                padding: const EdgeInsets.only(top: Dimensions.padding16, bottom : Dimensions.padding10),
                color: context.customThemeColors.backGroundColor,
                child: campaignController.campaignList != null ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          enableInfiniteScroll: campaignController.campaignList!.length > 1 ? true : false,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: campaignController.campaignList!.length  == 1 ? 0.96 : .94,
                          disableCenter: true,
                          autoPlayInterval: const Duration(seconds: 7),
                          onPageChanged: (index, reason) {
                            campaignController.setCurrentIndex(index, true);
                          },
                        ),
                        itemCount: campaignController.campaignList!.isEmpty ? 1 : campaignController.campaignList!.length,
                        itemBuilder: (context, index, _) {

                          return InkWell(
                            onTap: () {
                              if(isRedundentClick(DateTime.now())){
                                return;
                              }
                              campaignController.navigateFromCampaign(campaignController.campaignList![index]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                              child: _CampaignCard(campaignData: campaignController.campaignList![index]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding10),

                    campaignController.campaignList!.length > 1 ? Align(
                      alignment: Alignment.center,
                      child: AnimatedSmoothIndicator(
                        activeIndex: campaignController.currentIndex!,
                        count: campaignController.campaignList!.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 7,
                          dotWidth: 7,
                          spacing: 5,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Theme.of(context).hintColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: Dimensions.padding24),
                  ],) :
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true, color: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6),
                          boxShadow: Get.isDarkMode ? null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                        ),
                      )
                  ),
                ),
            );
          }
        });
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignData campaignData;
  const _CampaignCard({required this.campaignData});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 10, spreadRadius: 1, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
              child: SizedBox(
                width: double.infinity,
                child: GetBuilder<SplashController>(builder: (splashController) {
                  return CustomImage(
                    image: campaignData.coverImageFullPath ?? "",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: Images.placeholder,
                  );
                }),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.padding16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius8),
                        child: GetBuilder<SplashController>(builder: (splashController) {
                          return CustomImage(
                            image: campaignData.thumbnailFullPath ?? "",
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            placeholder: Images.placeholder,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimensions.padding16, right: Dimensions.padding16, top: Dimensions.padding8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          campaignData.name ?? '',
                          style: context.heading.large,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimensions.padding8),
                        Row(
                          children: [
                            SvgPicture.asset(Images.service, width: 16, height: 16, colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn)),
                            const SizedBox(width: Dimensions.padding6),
                            Text('${campaignData.serviceCount ?? 0} ${'services'.tr}', style: context.body.small),
                            const SizedBox(width: Dimensions.padding16),
                            Image.asset(Images.calendar2, width: 16, height: 16),
                            const SizedBox(width: Dimensions.padding6),
                            Text(
                              campaignData.validTillDate != null ? DateConverter.dateStringMonthYear(campaignData.validTillDate) : '',
                              style: context.body.small,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
