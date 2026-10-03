import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/provider/widgets/provider_details_shimmer.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class ProviderDetailsScreen extends StatefulWidget {
  final String providerId;
  const ProviderDetailsScreen({super.key,required this.providerId}) ;


  @override
  ProviderDetailsScreenState createState() => ProviderDetailsScreenState();
}

class ProviderDetailsScreenState extends State<ProviderDetailsScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;
  final GlobalKey _topCardKey = GlobalKey();
  late final AutoScrollController _scrollController = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, _pinnedHeaderHeight, 0, 0));
  double? _measuredTopCardHeight;
  double get _appBarHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  double get _pinnedHeaderHeight => _appBarHeight + _CategoryTabBar.height;

  void _measureTopCardHeight() {
    final renderBox = _topCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final double height = renderBox.size.height;
    if (_measuredTopCardHeight != height && mounted) {
      setState(() => _measuredTopCardHeight = height);
    }
  }

  bool get _isRebookingEnabled => Get.find<AuthController>().isLoggedIn()
      && (Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false);

  void _syncTabController(int length) {
    final TabController? previous = tabController;
    if (previous != null && previous.length == length) return;

    setState(() => tabController = TabController(length: length, vsync: this));
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
  }

  Future<void> _refreshProviderDetails() async {
    final providerBookingController = Get.find<ProviderBookingController>();

    await providerBookingController.refreshProviderDetails(widget.providerId);
    if (!mounted) return;

    _syncTabController(providerBookingController.categoryItemList.length);

    if (_isRebookingEnabled) {
      await Get.find<BookingRebookController>().loadProviderRebookableBookings(providerId: widget.providerId);
    }
  }

  @override
  void initState() {
    super.initState();

    final providerBookingController = Get.find<ProviderBookingController>();

    providerBookingController.updateTabBarPinned(false);

    if(_isRebookingEnabled){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Get.find<BookingRebookController>().loadProviderRebookableBookings(providerId: widget.providerId);
      });
    }


    providerBookingController.getProviderDetailsData(widget.providerId, true).then((value){
      if(!mounted) return;
      _syncTabController(providerBookingController.categoryItemList.length);
      Get.find<CartController>().updatePreselectedProvider(null);
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomPopWidget(
      child: Scaffold(
        drawer: null,
        endDrawer: null,
        extendBodyBehindAppBar: true,
        appBar: AnimatedCustomAppBar(providerId: widget.providerId),
        floatingActionButton: const FloatingViewCartButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GetBuilder<ProviderBookingController>(
          builder: (providerBookingController){
            final ProviderDetailsContent? detailsContent = providerBookingController.providerDetailsContent;
            final TabController? categoryTabController = tabController;

            if(detailsContent != null && categoryTabController != null){

              if(detailsContent.provider == null) {
                return _ProviderNotFoundView(onRefresh: _refreshProviderDetails);
              }
              if(categoryTabController.length != providerBookingController.categoryItemList.length){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(mounted) _syncTabController(providerBookingController.categoryItemList.length);
                });
                return const ProviderDetailsShimmer();
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {if(mounted) _measureTopCardHeight();});

              final double appBarHeight = _appBarHeight;

              return Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      final double? topCardHeight = _measuredTopCardHeight;
                      if (scrollNotification.metrics.axis == Axis.vertical && topCardHeight != null) {
                        final threshold = topCardHeight - appBarHeight;
                        if (scrollNotification.metrics.pixels >= threshold && !providerBookingController.isTabBarPinnedNotifier.value) {
                          providerBookingController.updateTabBarPinned(true);
                        } else if (scrollNotification.metrics.pixels < threshold && providerBookingController.isTabBarPinnedNotifier.value) {
                          providerBookingController.updateTabBarPinned(false);
                        }
                      }
                      return false;
                    },
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: RefreshIndicator(
                          onRefresh: _refreshProviderDetails,
                          edgeOffset: appBarHeight,
                          child: VerticalScrollableTabView(
                            tabController: categoryTabController,
                            scrollController: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            listItemData: providerBookingController.categoryItemList,
                            verticalScrollPosition: VerticalScrollPosition.begin,
                            onVisibleItemsChanged: (visibleIndexes, isNearBottom) =>
                                providerBookingController.loadVisibleSections(visibleIndexes, isNearBottom: isNearBottom),
                            eachItemChild: (object, index) => CategorySection(
                              category: object as CategoryModelItem,
                              providerData: detailsContent.provider,
                            ),
                            slivers: [
                              if(detailsContent.provider?.isAvailable == false)
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                      border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.error)),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16, horizontal: Dimensions.padding20),
                                    child: Center(child: Text('provider_is_currently_unavailable'.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),)),
                                  ),
                                ),

                              SliverToBoxAdapter(
                                child: ProviderDetailsTopCard(key: _topCardKey, providerId: widget.providerId),
                              ),

                              SliverToBoxAdapter(
                                child: _CategoryTabBar(
                                  tabController: categoryTabController,
                                  categoryItemList: providerBookingController.categoryItemList,
                                ),
                              ),

                              if(providerBookingController.categoryItemList.every((section) => section.isEmptyAfterLoad)) SliverToBoxAdapter(
                                child: NoDataScreen(text: 'no_subscribed_subcategories_available'.tr),
                              ),
                            ],
                            trailingSlivers: const [
                              SliverToBoxAdapter(child: ViewCartBottomSpace()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: providerBookingController.isTabBarPinnedNotifier,
                    builder: (context, isPinned, child) {
                      if (!isPinned) return const SizedBox.shrink();
                      return Positioned(
                        top: appBarHeight,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: Dimensions.webMaxWidth,
                            child: _CategoryTabBar(
                              tabController: categoryTabController,
                              categoryItemList: providerBookingController.categoryItemList,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  BackToTopButton(
                    scrollController: _scrollController,
                    topResolver: () => appBarHeight + BackToTopButton.gap
                        + (providerBookingController.isTabBarPinnedNotifier.value ? _CategoryTabBar.height : 0),
                  ),
                ],
              );

            }else{
              return const ProviderDetailsShimmer();
            }
          },
        ),
      ),
    );
  }

}

class _ProviderNotFoundView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _ProviderNotFoundView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;

    return RefreshIndicator(
      onRefresh: onRefresh,
      edgeOffset: appBarHeight,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: appBarHeight),
        child: SizedBox(
          height: Get.height * 0.65,
          child: NoDataScreen(text: 'no_data_found'.tr, type: NoDataType.provider),
        ),
      ),
    );
  }
}

class _CategoryTabBar extends StatelessWidget {
  static const double height = 45;

  final TabController tabController;
  final List<CategoryModelItem> categoryItemList;
  const _CategoryTabBar({required this.tabController, required this.categoryItemList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: Dimensions.webMaxWidth,
      color: Theme.of(context).cardColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), width: 0.5)),
        ),
        child: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Get.isDarkMode ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          labelStyle: heading.large.strong,
          unselectedLabelStyle: heading.large.strong,
          tabs: categoryItemList.map((e) => Tab(text: e.title)).toList(),
          onTap: (index) {
            VerticalScrollableTabBarStatus.setIndex(index);
          },
        ),
      ),
    );
  }
}

class AnimatedCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String providerId;

  const AnimatedCustomAppBar({super.key, this.height = kToolbarHeight, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (bookingController){
      return ValueListenableBuilder<bool>(
        valueListenable: bookingController.isTabBarPinnedNotifier,
        builder: (context, isPinned, child) {
          if(!isPinned){
            return AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              leading: const Padding(
                padding: EdgeInsets.only(left: Dimensions.padding12),
                child: _FloatingButton(icon: Icons.arrow_back),
              ),
              actions: [
                if(bookingController.providerDetailsContent?.provider != null)...[
                  _FloatingButton(
                    icon: Icons.search,
                    onTap: () => ProviderServiceSearchSheet.show(context, providerId: providerId),
                  ),
                  const SizedBox(width: Dimensions.padding8),
                  _FloatingFavoriteButton(providerId: providerId, value: bookingController.providerDetailsContent?.provider?.isFavorite),
                  const SizedBox(width: Dimensions.padding12),
                ]
              ],
            );
          }

          return AppBar(
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: Dimensions.padding12,
            leadingWidth: 60,
            leading: const Padding(
              padding: EdgeInsets.only(left: Dimensions.padding12),
              child: _FloatingButton(icon: Icons.arrow_back),
            ),
            title: Text(
              bookingController.providerDetailsContent?.provider?.name ?? "provider_details".tr,
              style: context.heading.large,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              _SearchFloatingButton(providerId: providerId),
              const SizedBox(width: Dimensions.padding8),
              _FloatingFavoriteButton(providerId: providerId, value: bookingController.providerDetailsContent?.provider?.isFavorite),
              const SizedBox(width: Dimensions.padding12),
            ],
          );
        },
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _SearchFloatingButton extends StatelessWidget {
  final String providerId;
  const _SearchFloatingButton({required this.providerId});

  @override
  Widget build(BuildContext context) {
    return _FloatingButton(
      icon: Icons.search,
      onTap: () => ProviderServiceSearchSheet.show(context, providerId: providerId),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  static const double _size = 36;

  final IconData icon;
  final VoidCallback? onTap;
  const _FloatingButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        onTap: onTap ?? () => Navigator.of(context).canPop() ? Navigator.pop(context) : Get.offAllNamed(RouteHelper.getInitialRoute()),
        child: Container(
          height: _size, width: _size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.radius8), boxShadow: searchBoxShadow),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}

class _FloatingFavoriteButton extends StatelessWidget {
  static const double _size = 36;

  final String providerId;
  final int? value;
  const _FloatingFavoriteButton({required this.providerId, required this.value});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: _size, width: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.radius8), boxShadow: searchBoxShadow),
        clipBehavior: Clip.antiAlias,
        child: FavoriteIconWidget(providerId: providerId, value: value, size: _size, iconSize: 20),
      ),
    );
  }
}
