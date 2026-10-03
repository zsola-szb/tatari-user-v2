import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CategorySubCategoryScreen extends StatefulWidget {
  final String categorySlug;
  final String categoryName;
  const CategorySubCategoryScreen({super.key, required this.categorySlug, required this.categoryName});

  @override
  State<CategorySubCategoryScreen> createState() => _CategorySubCategoryScreenState();
}

class _CategorySubCategoryScreenState extends State<CategorySubCategoryScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<CustomShakingWidgetState> _signInShakeKey = GlobalKey<CustomShakingWidgetState>();
  final GlobalKey<RectGetterState> _listViewKey = RectGetter.createGlobalKey();
  final Map<int, GlobalKey<RectGetterState>> _sectionKeys = {};
  TabController? _tabController;

  static const int _maxInitialSections = 3;

  int _loadedUpToIndex = 0;
  int _visibleTabIndex = 0;

  bool _isLoadingSections = false;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Get.find<CategoryController>().getSubCategoryList(widget.categorySlug, shouldUpdate: false).then((_) => _onSubCategoriesLoaded());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _onSubCategoriesLoaded() async {
    final subs = Get.find<CategoryController>().subCategoryList ?? [];
    if(subs.isEmpty || !mounted){
      return;
    }
    setState(() {
      _tabController = TabController(length: subs.length, vsync: this);
    });
    await _loadSectionsUpTo(_initialSectionCount(subs) - 1);
    _appendNextIfContentTooShort();
  }

  int _initialSectionCount(List<CategoryModel> subCategories) {
    int serviceCount = 0;
    int sectionCount = 0;
    while(sectionCount < subCategories.length && sectionCount < _maxInitialSections){
      serviceCount += subCategories[sectionCount].serviceCount ?? 0;
      sectionCount++;
      if(serviceCount >= ServiceController.subCategoryTabPageSize){
        break;
      }
    }
    return sectionCount;
  }

  Future<void> _loadSectionsUpTo(int targetIndex) async {
    final subs = Get.find<CategoryController>().subCategoryList ?? [];
    if(subs.isEmpty){
      return;
    }
    final serviceController = Get.find<ServiceController>();
    final lastIndex = targetIndex.clamp(0, subs.length - 1);

    for(int index = 0; index <= lastIndex; index++){
      final slug = subs[index].slug ?? '';
      if(serviceController.subCategoryTabServiceList(slug) == null){
        if(mounted){
          setState(() => _isLoadingSections = true);
        }
        await serviceController.getSubCategoryTabServiceList(slug, offset: 1);
      }
      if(!mounted){
        return;
      }
      if(index > _loadedUpToIndex){
        setState(() => _loadedUpToIndex = index);
      }
    }

    if(mounted && _isLoadingSections){
      setState(() => _isLoadingSections = false);
    }
  }

  Future<void> _onTabTap(int index) async {
    final subs = Get.find<CategoryController>().subCategoryList ?? [];
    if(index < 0 || index >= subs.length){
      return;
    }
    await _loadSectionsUpTo(index);
    _scrollToSection(index);
  }

  void _scrollToSection(int index) {
    _tabController?.animateTo(index);
    _visibleTabIndex = index;

    final sectionContext = _sectionKeys[index]?.currentContext;
    if(sectionContext != null){
      _ensureSectionVisible(sectionContext);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appendedSectionContext = _sectionKeys[index]?.currentContext;
      if(!mounted || appendedSectionContext == null){
        return;
      }
      _ensureSectionVisible(appendedSectionContext);
    });
  }

  void _ensureSectionVisible(BuildContext sectionContext) {
    _isProgrammaticScroll = true;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      alignment: 0.0,
    ).then((_) => _isProgrammaticScroll = false);
  }

  void _handleScroll() {
    if(_isLoadingSections || !_scrollController.hasClients){
      return;
    }
    final pos = _scrollController.position;
    if(!pos.hasContentDimensions){
      return;
    }
    if(pos.pixels >= pos.maxScrollExtent - 4 && pos.userScrollDirection == ScrollDirection.reverse){
      _appendNextSubCategory();
    }
  }

  Future<void> _appendNextSubCategory() async {
    if(_isLoadingSections){
      return;
    }
    final subs = Get.find<CategoryController>().subCategoryList ?? [];
    if(subs.isEmpty || _loadedUpToIndex >= subs.length - 1){
      return;
    }
    final currentSlug = subs[_loadedUpToIndex].slug ?? '';
    if(!Get.find<ServiceController>().isSubCategoryTabFullyLoaded(currentSlug)){
      return;
    }

    await _loadSectionsUpTo(_loadedUpToIndex + 1);
    _appendNextIfContentTooShort();
  }

  void _appendNextIfContentTooShort() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!mounted || _isLoadingSections || !_scrollController.hasClients){
        return;
      }
      final pos = _scrollController.position;
      if(pos.hasContentDimensions && pos.maxScrollExtent <= 0){
        _appendNextSubCategory();
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if(_isProgrammaticScroll){
      return false;
    }
    final visible = _visibleSectionIndices();
    if(visible.isNotEmpty && visible.first != _visibleTabIndex){
      _visibleTabIndex = visible.first;
      _tabController?.animateTo(_visibleTabIndex);
    }
    return false;
  }

  List<int> _visibleSectionIndices() {
    final viewportRect = RectGetter.getRectFromKey(_listViewKey);
    final visible = <int>[];
    if(viewportRect == null){
      return visible;
    }
    _sectionKeys.forEach((index, key) {
      final rect = RectGetter.getRectFromKey(key);
      if(rect == null){
        return;
      }
      if(rect.bottom < viewportRect.top || rect.top > viewportRect.bottom){
        return;
      }
      visible.add(index);
    });
    visible.sort();
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        appBar: CustomAppBar(title: widget.categoryName),
        floatingActionButton: const FloatingViewCartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: GetBuilder<CategoryController>(builder: (categoryController) {
            final subs = categoryController.subCategoryList;
            return Column(children: [
              SubCategoryTabBarWidget(
                subCategories: subs,
                controller: _tabController,
                onTabTap: _onTabTap,
              ),

              Expanded(
                child: GetBuilder<ServiceController>(builder: (serviceController) {
                  if(subs != null && subs.isEmpty){
                    return NoDataScreen(text: 'no_subcategory_found'.tr, type: NoDataType.categorySubcategory);
                  }
                  if(subs == null){
                    return const SubCategoryScreenShimmerWidget();
                  }
                  if(subs.isEmpty){
                    return const SizedBox();
                  }
                  final sectionCount = (_loadedUpToIndex + 1).clamp(0, subs.length);
                  // The last rendered section shows its own shimmer while it loads, so the trailing
                  // loader belongs to the section being appended after it.
                  final isAppendingSection = _isLoadingSections
                      && serviceController.subCategoryTabServiceList(subs[sectionCount - 1].slug ?? '') != null;

                  return RectGetter(
                    key: _listViewKey,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Center(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: Column(children: [
                              ...List.generate(sectionCount, (index) {
                                final subCategory = subs[index];
                                final slug = subCategory.slug ?? '';
                                return RectGetter(
                                  key: _sectionKeys.putIfAbsent(index, RectGetter.createGlobalKey),
                                  child: SubCategoryServiceSectionWidget(
                                    key: ValueKey('subcategory-section-$index'),
                                    subCategory: subCategory,
                                    services: serviceController.subCategoryTabServiceList(slug),
                                    content: serviceController.subCategoryTabServiceContent(slug),
                                    scrollController: _scrollController,
                                    signInShakeKey: _signInShakeKey,
                                    onPaginate: (offset) => serviceController.getSubCategoryTabServiceList(slug, offset: offset),
                                  ),
                                );
                              }),
                              if(isAppendingSection)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20),
                                  child: Center(child: CustomLoaderWidget(color: Theme.of(context).colorScheme.primary)),
                                ),
                              const SizedBox(height: Dimensions.padding24 * 2),
                              const ViewCartBottomSpace(),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
