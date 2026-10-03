import 'package:tatarigigs_user/feature/offers/widget/offers_count_header.dart';
import 'package:tatarigigs_user/feature/offers/widget/offers_shimmer_view.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersListBody extends StatelessWidget {
  final ScrollController scrollController;

  const OffersListBody({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints){
      return GetBuilder<OffersController>(builder: (OffersController offersController){
        return RefreshIndicator(
          onRefresh: offersController.refreshOffers,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                width: Dimensions.webMaxWidth,
                constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
                ),
                child: offersController.isLoading
                    ? const OffersShimmerView() : offersController.isEmpty
                        ? const OffersEmptyView()
                        : OffersPaginatedList(offersController: offersController, scrollController: scrollController),
              ),
            ),
          ),
        );
      });
    });
  }
}

class OffersPaginatedList extends StatelessWidget {
  final OffersController offersController;
  final ScrollController scrollController;

  const OffersPaginatedList({super.key, required this.offersController, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final List<Service> offers = offersController.offers;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      OffersCountHeader(count: offersController.totalSize),

      PaginatedListView(
        scrollController: scrollController,
        totalSize: offersController.totalSize,
        offset: offersController.currentPage,
        limit: OffersController.pageLimit,
        onPaginate: (int offset) async => offersController.loadPage(offset),
        bottomPadding: Dimensions.padding24 * 4,
        itemView: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: offers.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1, thickness: 1,
            indent: Dimensions.padding16, endIndent: Dimensions.padding16,
            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
          ),
          itemBuilder: (BuildContext context, int index) => ServiceCardWidget(
            service: offers[index],
            fromType: '',
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding16),
          ),
        ),
      ),

      const ViewCartBottomSpace(),
    ]);
  }
}

class OffersEmptyView extends StatelessWidget {
  const OffersEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.55,
      child: NoDataScreen(text: 'no_offer_found'.tr, type: NoDataType.offers),
    );
  }
}