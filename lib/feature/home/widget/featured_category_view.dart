import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class FeaturedCategoryView extends StatefulWidget {
  const FeaturedCategoryView({super.key});

  @override
  State<FeaturedCategoryView> createState() => _FeaturedCategoryViewState();
}

class _FeaturedCategoryViewState extends State<FeaturedCategoryView> with TickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _syncTabController(int categoryCount) {
    if (_tabController?.length == categoryCount) {
      return;
    }
    final TabController? previousController = _tabController;
    _selectedIndex = 0;
    _tabController = TabController(length: categoryCount, vsync: this);

    if (previousController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previousController.dispose());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(builder: (serviceController) {
      final categoryList = serviceController.categoryList;

      if (categoryList == null || categoryList.isEmpty) {
        return const SizedBox();
      }

      _syncTabController(categoryList.length);

      final selectedCategory = categoryList[_selectedIndex < categoryList.length ? _selectedIndex : 0];
      final services = serviceController.featuredCategoryServices(selectedCategory.slug);

      if (services == null && !serviceController.isFeaturedCategoryServiceLoading(selectedCategory.slug)) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => serviceController.getFeaturedCategoryServiceList(selectedCategory.slug),
        );
      }

      final bool isLoading = services == null || serviceController.isFeaturedCategoryServiceLoading(selectedCategory.slug);
      final List<Service> visibleServices = services == null ? const <Service>[]
          : services.take(ServiceController.featuredCategoryServiceLimit).toList();

      return Container(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimensions.padding16,
                Dimensions.padding10,
                Dimensions.padding16,
                Dimensions.padding10,
              ),
              child: Text('featured_services'.tr, style: context.heading.extraLarge),
            ),

            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              labelPadding: const EdgeInsets.only(right: Dimensions.padding20),
              indicator: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2))),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              labelStyle: context.heading.large.strong,
              unselectedLabelStyle: context.heading.large.strong,
              onTap: (index) => setState(() => _selectedIndex = index),
              tabs: categoryList.map((category) => Tab(height: 40, text: category.name ?? '')).toList(),
            ),

            const SizedBox(height: Dimensions.padding10),

            if (isLoading)
              const FeaturedCategoryServiceList.loading()
            else if (visibleServices.isEmpty)
              SizedBox(
                height: 100,
                width: Get.width,
                child: Center(child: Text('no_services_found'.tr, style: context.body.defaultSize)),
              )
            else
              FeaturedCategoryServiceList(services: visibleServices),
          ],
        ),
      );
    });
  }
}

class FeaturedCategoryServiceList extends StatelessWidget {
  final List<Service> services;
  final bool isLoading;

  const FeaturedCategoryServiceList({super.key, required this.services}) : isLoading = false;

  const FeaturedCategoryServiceList.loading({super.key}): services = const <Service>[], isLoading = true;

  static const int _loadingColumnCount = 2;
  static const double _cardGap = Dimensions.padding10;
  static const double _verticalPadding = Dimensions.padding6;

  @override
  Widget build(BuildContext context) {
    final int columnCount = isLoading ? _loadingColumnCount : (services.length / 2).ceil();
    final bool hasSecondRow = isLoading || services.length > 1;
    final double cardWidth = ResponsiveHelper.isTab(context) ? Get.width / 2.5 : Get.width / 1.16;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(start: Dimensions.padding16, bottom: _verticalPadding, top: _verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FeaturedCategoryCardRow(services: services, isLoading: isLoading, columnCount: columnCount, cardWidth: cardWidth, rowOffset: 0),
          if (hasSecondRow) ...[
            const SizedBox(height: _cardGap),
            _FeaturedCategoryCardRow(services: services, isLoading: isLoading, columnCount: columnCount, cardWidth: cardWidth, rowOffset: 1),
          ],
        ],
      ),
    );
  }
}

class _FeaturedCategoryCardRow extends StatelessWidget {
  final List<Service> services;
  final bool isLoading;
  final int columnCount;
  final double cardWidth;
  final int rowOffset;

  const _FeaturedCategoryCardRow({
    required this.services,
    required this.isLoading,
    required this.columnCount,
    required this.cardWidth,
    required this.rowOffset,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List<Widget>.generate(columnCount, (int columnIndex) {
          final int index = columnIndex * 2 + rowOffset;
          final Widget card = isLoading
              ? const FeaturedCategoryServiceShimmer()
              : index < services.length
                  ? ServiceCardWidget(service: services[index], fromType: '', nameMaxLines: 1)
                  : const SizedBox();

          return Padding(
            padding: const EdgeInsetsDirectional.only(end: Dimensions.padding12, bottom: Dimensions.padding2),
            child: SizedBox(width: cardWidth, child: card),
          );
        }),
      ),
    );
  }
}
