import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CampaignServiceSection extends StatelessWidget {
  final CampaignDetailsController campaignController;
  final ScrollController scrollController;

  const CampaignServiceSection({super.key, required this.campaignController, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final List<Service> services = campaignController.serviceList;

    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(top: Dimensions.padding16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Text('explore_services'.tr, style: context.heading.extraLarge),
        ),
        Gaps.verticalGapOf(Dimensions.padding6),

        if(services.isEmpty)
          SizedBox(
            height: Get.height * 0.35,
            child: NoDataScreen(text: 'no_service_found'.tr, type: NoDataType.service),
          )
        else
          PaginatedListView(
            scrollController: scrollController,
            totalSize: campaignController.serviceTotalSize,
            offset: campaignController.serviceOffset,
            limit: CampaignDetailsController.servicePageSize,
            bottomPadding: 0,
            onPaginate: (int offset) async => campaignController.loadMoreServices(offset),
            itemView: CampaignServiceList(services: services),
          ),
      ]),
    );
  }
}

class CampaignServiceList extends StatelessWidget {
  final List<Service> services;

  const CampaignServiceList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: services.length,
      separatorBuilder: (BuildContext context, int index) => const CampaignListDivider(),
      itemBuilder: (BuildContext context, int index) => ServiceCardWidget(
        service: services[index],
        fromType: '',
        showCardColor: false,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding16),
      ),
    );
  }
}

class CampaignListDivider extends StatelessWidget {
  const CampaignListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1, thickness: 1,
      indent: Dimensions.padding16, endIndent: Dimensions.padding16,
      color: Theme.of(context).hintColor.withValues(alpha: 0.2),
    );
  }
}