import 'package:tatarigigs_user/feature/provider/widgets/provider_details_shimmer.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderServiceSearchSheet extends StatefulWidget {
  final String providerId;

  const ProviderServiceSearchSheet({super.key, required this.providerId});

  static Future<void> show(BuildContext context, {required String providerId}) {
    return showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => ProviderServiceSearchSheet(providerId: providerId),
    );
  }

  @override
  State<ProviderServiceSearchSheet> createState() => _ProviderServiceSearchSheetState();
}

class _ProviderServiceSearchSheetState extends State<ProviderServiceSearchSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<AllSearchController>().clearSearchController(shouldUpdate: false);
    Get.find<ProviderServiceSearchController>().clear(shouldUpdate: false);
  }

  @override
  void dispose() {
    Get.find<AllSearchController>().clearSearchController(shouldUpdate: false);
    Get.find<ProviderServiceSearchController>().clear(shouldUpdate: false);
    _scrollController.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    Get.find<AllSearchController>().showSuffixIcon(context, text);
    Get.find<ProviderServiceSearchController>().onQueryChanged(widget.providerId, text);
  }

  void _onSubmit(String text) {
    Get.find<ProviderServiceSearchController>().searchServices(providerId: widget.providerId, query: text.trim());
  }

  void _onClear() {
    Get.find<AllSearchController>().clearSearchController();
    Get.find<ProviderServiceSearchController>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        height: Get.height,
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: SearchAppBar(
            autofocus: true,
            hintText: 'search_services_of_this_provider'.tr,
            onBackTap: () => Get.back<void>(),
            onChanged: _onChanged,
            onSubmit: _onSubmit,
            onClear: _onClear,
          ),
          body: SizedBox(
            width: Dimensions.webMaxWidth,
            child: ProviderServiceSearchResult(
              providerId: widget.providerId,
              scrollController: _scrollController,
            ),
          ),
        ),
      ),
    );
  }
}

class ProviderServiceSearchResult extends StatelessWidget {
  final String providerId;
  final ScrollController scrollController;

  const ProviderServiceSearchResult({super.key, required this.providerId, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderServiceSearchController>(
      builder: (ProviderServiceSearchController searchController) {
        if (searchController.query.isEmpty) {
          return const SizedBox.shrink();
        }

        final List<Service>? serviceList = searchController.serviceList;

        if (serviceList == null) {
          return const SingleChildScrollView(
            child: ProviderServiceSearchList(serviceList: null, providerData: null),
          );
        }

        if (serviceList.isEmpty) {
          return const Center(child: ServiceNotAvailableScreen(fromPage: "search_page"));
        }

        return SingleChildScrollView(
          controller: scrollController,
          child: PaginatedListView(
            scrollController: scrollController,
            totalSize: searchController.totalSize,
            offset: searchController.offset,
            limit: ProviderServiceSearchController.pageSize,
            onPaginate: (int offset) async => searchController.searchServices(
              providerId: providerId,
              query: searchController.query,
              offset: offset,
              isPagination: true,
            ),
            itemView: ProviderServiceSearchList(
              serviceList: serviceList,
              providerData: Get.find<ProviderBookingController>().providerDetailsContent?.provider,
            ),
          ),
        );
      },
    );
  }
}

class ProviderServiceSearchList extends StatelessWidget {
  final List<Service>? serviceList;
  final ProviderData? providerData;

  const ProviderServiceSearchList({super.key, required this.serviceList, required this.providerData});

  static const int _shimmerItemCount = 5;

  @override
  Widget build(BuildContext context) {
    final List<Service>? services = serviceList;

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: services?.length ?? _shimmerItemCount,
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: Dimensions.padding24,
          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
        ),
        itemBuilder: (BuildContext context, int index) {
          if (services == null) {
            return const ServiceCardShimmer();
          }

          return ServiceCardWidget(
            service: services[index],
            fromType: 'provider_details',
            providerData: providerData,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding4),
            showCardColor: false,
            showProviderName: false,
          );
        },
      ),
    );
  }
}
