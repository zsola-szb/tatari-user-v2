import 'package:tatarigigs_user/feature/cart/widget/add_more/cart_add_more_services_grid.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartAddMoreServiceScreen extends StatefulWidget {
  const CartAddMoreServiceScreen({super.key});

  @override
  State<CartAddMoreServiceScreen> createState() => _CartAddMoreServiceScreenState();
}

class _CartAddMoreServiceScreenState extends State<CartAddMoreServiceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<AllSearchController>().clearSearchController(shouldUpdate: false);
    Get.find<CartAddMoreServiceController>().initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartAddMoreServiceController controller = Get.find<CartAddMoreServiceController>();

    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: SearchAppBar(
        onChanged: (String text) {
          Get.find<AllSearchController>().showSuffixIcon(context, text);
          controller.onSearchChanged(text);
        },
        onSubmit: controller.submitSearch,
        onClear: () {
          Get.find<AllSearchController>().clearSearchController();
          controller.clearSearch();
        },
      ),
      body: SafeArea(
        top: false,
        child: _CartAddMoreServiceBody(scrollController: _scrollController),
      ),
    );
  }
}

class _CartAddMoreServiceBody extends StatelessWidget {
  final ScrollController scrollController;

  const _CartAddMoreServiceBody({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return GetBuilder<CartAddMoreServiceController>(builder: (CartAddMoreServiceController controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshServices,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                width: Dimensions.webMaxWidth,
                constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding20, Dimensions.padding16, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
                ),
                child: controller.isLoading
                    ? const CartAddMoreServicesGrid(serviceList: null)
                    : controller.isEmpty
                        ? const _CartAddMoreEmptyView()
                        : PaginatedListView(
                            scrollController: scrollController,
                            totalSize: controller.totalSize,
                            offset: controller.currentPage,
                            limit: CartAddMoreServiceController.pageLimit,
                            onPaginate: (int offset) async => controller.loadPage(offset),
                            itemView: CartAddMoreServicesGrid(serviceList: controller.services),
                          ),
              ),
            ),
          ),
        );
      });
    });
  }
}

class _CartAddMoreEmptyView extends StatelessWidget {
  const _CartAddMoreEmptyView();

  static const double _viewportFraction = 0.55;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * _viewportFraction,
      child: const Center(child: ServiceNotAvailableScreen(fromPage: 'search_page')),
    );
  }
}
