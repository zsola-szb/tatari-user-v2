// ignore_for_file: deprecated_member_use
import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/search/widget/search_result_categories_section.dart';
import 'package:tatarigigs_user/feature/search/widget/search_result_providers_section.dart';
import 'package:tatarigigs_user/feature/search/widget/search_result_services_section.dart';
import 'package:tatarigigs_user/feature/search/widget/search_result_tabs.dart';
import 'package:tatarigigs_user/feature/search/widget/search_shimmer_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SearchResultScreen extends StatefulWidget {
  final String? queryText;
  final String? fromPage;

  const SearchResultScreen({super.key, required this.queryText, this.fromPage}) ;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _loadDart();
    super.initState();
  }

  Future<void> _loadDart() async {

    Get.find<AllSearchController>().clearAllFilterValue(shouldUpdate: false);
    Get.find<AllSearchController>().updateSortByType(widget.fromPage, shouldUpdate: false);
    Get.find<AllSearchController>().searchData(query:widget.queryText!, offset: 1, shouldUpdate: false);
    await Get.find<CategoryController>().getCategoryList(false);
    Get.find<AllSearchController>().resetCategoryCheckedList(shouldUpdate: false);
    Get.find<AllSearchController>().populatedSearchController(widget.queryText ?? "", shouldUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final bool hasCategories = (searchController.searchResultModel?.data?.categories ?? []).isNotEmpty;
      final bool hasProviders = (searchController.searchResultModel?.data?.providers ?? []).isNotEmpty;

      return CustomPopWidget(
      isNavigationOnOnPop: searchController.isViewAllOpen,
      onPopInvoked: (){
        if(searchController.isViewAllOpen){
          searchController.closeViewAll();
          return;
        }
        searchController.clearSearchController();

      },
      child: Scaffold(
        appBar: SearchAppBar(
          backButton: true,
          showFilterButton: true,
          onBackTap: (){
            if(searchController.isViewAllOpen){
              searchController.closeViewAll();
              return;
            }
            searchController.clearSearchController();
            Navigator.pop(context);
          },
          onFilterTap: (){
            showModalBottomSheet(
              useRootNavigator: true, isScrollControlled: true, backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => GetBuilder<CategoryController>(
                builder: (CategoryController categoryController) => FilterSortSheet(source: searchController),
              ),
            );
          },
        ),

        body: RefreshIndicator(
          onRefresh: searchController.refreshSearchResult,
          child: FooterBaseView(
            scrollController: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: searchController.searchResultModel == null ? const SearchShimmerWidget() :
            Container(
              color: context.customThemeColors.backGroundColor,
              width: Dimensions.webMaxWidth,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(searchController.resultTotalSize > 0) ...[
                    _SearchResultHeader(resultTotalSize: searchController.resultTotalSize),
                    const SizedBox(height: Dimensions.padding10)
                  ],

                  if(searchController.hasEmptyResult) const _EmptySearchResultView()

                  else if(searchController.isViewAllOpen) ...[

                    searchController.showAllServices
                        ? _ViewAllPaginatedView(
                            key: const ValueKey<String>('view_all_services'),
                            scrollController: scrollController,
                            totalSize: searchController.viewAllServiceTotalSize,
                            offset: searchController.viewAllServiceOffset,
                            onPaginate: (int offset) => searchController.loadViewAllServices(offset: offset, isPagination: true),
                            child: const SearchResultServicesSection(),
                          )
                        : _ViewAllPaginatedView(
                            key: const ValueKey<String>('view_all_providers'),
                            scrollController: scrollController,
                            totalSize: searchController.viewAllProviderTotalSize,
                            offset: searchController.viewAllProviderOffset,
                            onPaginate: (int offset) => searchController.loadViewAllProviders(offset: offset, isPagination: true),
                            child: const SearchResultProvidersSection(),
                          ),
                  ] else ...[

                    (searchController.searchResultModel?.data?.services ?? []).isEmpty
                        ? const ServiceNotAvailableScreen(fromPage: "search_page") : const SearchResultServicesSection(),

                    if(hasCategories) ...[
                      const SizedBox(height: Dimensions.padding4),

                      const SearchResultCategoriesSection(),
                    ],

                    if(hasProviders) ...[
                      const SizedBox(height: Dimensions.padding4),

                      const SearchResultProvidersSection(),
                    ],
                  ],

                ],
              ),
            ),
          ),
        ),
      ),
    );
    });
  }
}

class _SearchResultHeader extends StatelessWidget {
  final int resultTotalSize;

  const _SearchResultHeader({required this.resultTotalSize});

  @override
  Widget build(BuildContext context) {
    final bool hasResultCount = resultTotalSize > 0;

    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: Dimensions.padding16,
          right: Dimensions.padding16,
          top: Dimensions.padding16,
          bottom: Dimensions.padding10,
        ),
        child: Row(children: [

          if(hasResultCount) Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: " $resultTotalSize ",
                    style: context.subHeading.defaultSize.strong.overrideWith(color: context.customThemeColors.secondaryTextColor),
                  ),
                  TextSpan(
                    text: 'results'.tr,
                    style: context.body.defaultSize,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if(BusinessModelHelper.isOpenMarket) ...[
            if(hasResultCount) const SizedBox(width: Dimensions.padding10),

            const SearchResultTabs(),
          ],
        ]),
      ),
    );
  }
}

class _EmptySearchResultView extends StatelessWidget {
  const _EmptySearchResultView();
  static const double _viewportFraction = 0.7;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * _viewportFraction,
      child: const Center(child: ServiceNotAvailableScreen(fromPage: "search_page")),
    );
  }
}

class _ViewAllPaginatedView extends StatelessWidget {
  final ScrollController scrollController;
  final int totalSize;
  final int offset;
  final Future<void> Function(int offset) onPaginate;
  final Widget child;

  const _ViewAllPaginatedView({
    super.key,
    required this.scrollController,
    required this.totalSize,
    required this.offset,
    required this.onPaginate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedListView(
      scrollController: scrollController,
      totalSize: totalSize,
      offset: offset,
      limit: AllSearchController.viewAllPageSize,
      onPaginate: (int offset) async => onPaginate(offset),
      bottomPadding: 0,
      itemView: child,
    );
  }
}
