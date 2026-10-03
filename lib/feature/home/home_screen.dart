import 'package:tatarigigs_user/feature/booking/widget/payment/booking_incomplete_payment_sheet.dart';
import 'package:tatarigigs_user/feature/home/widget/referal_welcome_dialog.dart';
import 'package:tatarigigs_user/feature/home/widget/explore_all_services_section.dart';
import 'package:tatarigigs_user/feature/home/widget/home_easy_booking_widget.dart';
import 'package:tatarigigs_user/feature/home/widget/home_section_sliver.dart';
import 'package:tatarigigs_user/feature/home/widget/nearby_provider_listview.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class HomeScreen extends StatefulWidget {
  static Future<void> loadData(bool reload, {int availableServiceCount = 1}) async {

    if(availableServiceCount==0){
      Get.find<BannerController>().getBannerList(reload);
    }else{
      await Future.wait([
        Get.find<ServiceController>().getRecommendedSearchList(),
        Get.find<ServiceController>().getAllServiceList(1,reload),
        Get.find<BannerController>().getBannerList(reload),
        Get.find<AdvertisementController>().getAdvertisementList(reload),
        Get.find<CategoryController>().getCategoryList(reload),
        Get.find<ServiceController>().getPopularServiceList(1,reload),
        Get.find<ServiceController>().getRecommendedServiceList(1,reload),
        Get.find<ProviderBookingController>().getProviderList(1,reload),
        Get.find<NearbyProviderController>().getProviderList(1,reload),
        Get.find<CampaignController>().getCampaignList(reload),
        Get.find<CheckoutController>().loadOfflineMethodList(reload: false, notify: false),
        Get.find<ServiceController>().getFeatherCategoryList(reload),
        if(Get.find<AuthController>().isLoggedIn())  Get.find<AuthController>().updateToken(),
        if(Get.find<AuthController>().isLoggedIn())  Get.find<ServiceController>().getRecentlyViewedServiceList(1,reload),
        if(Get.find<AuthController>().isLoggedIn() && (Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false))  Get.find<BookingRebookController>().loadRebookableBookings(reload: reload),

      ]);

      BookingIncompletePaymentPrompt.showIfNeeded();
      _showReferralWelcomeIfNeeded();

      if(Get.find<AuthController>().isLoggedIn() && (Get.find<SplashController>().configModel.content?.isProFeatureActive == 1)){
        Get.find<SubscriptionController>().getSubscriptionList();
        Get.find<SubscriptionController>().getSubscriptionTerms();
      }

    }
  }

  static void _showReferralWelcomeIfNeeded() {
    final bool isOnHome = Get.currentRoute.contains(RouteHelper.home) ||
        Get.currentRoute.contains('/?page=home');
    final List<Service>? services = Get.find<ServiceController>().allService;

    if (!isOnHome || services == null || services.isEmpty) {
      return;
    }
    if (!Get.find<UserController>().showReferWelcomeDialog() ||
        Get.find<AuthController>().getIsShowReferralBottomSheet() != true) {
      return;
    }

    Future<void>.delayed(const Duration(microseconds: 500), () {
      showModalBottomSheet<void>(
        isDismissible: false,
        context: Get.context!,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => const ReferWelcomeDialog(),
      );
    });
  }

  final AddressModel? addressModel;
  final bool showServiceNotAvailableDialog;
  const HomeScreen({super.key, this.addressModel, required this.showServiceNotAvailableDialog}) ;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static bool _isLoginPromptHandled = false;

  AddressModel? _previousAddress;
  int availableServiceCount = 0;

  @override
  void initState() {
    super.initState();

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }
    if(Get.find<LocationController>().getUserAddress() !=null){
      availableServiceCount = Get.find<LocationController>().getUserAddress()!.availableServiceCountInZone!;
    }
    HomeScreen.loadData(false, availableServiceCount: availableServiceCount);

    _previousAddress = widget.addressModel;

    if (_previousAddress != null && availableServiceCount == 0 && widget.showServiceNotAvailableDialog) {
      Future.delayed(const Duration(microseconds: 1000), () {
        Get.dialog(
          ServiceNotAvailableDialog(
            address: _previousAddress,
            forCard: false,
            showButton: true,
            onBackPressed: () {
              Get.back();
              Get.find<LocationController>().setZoneContinue('false');
            },
          )
        );
      });
    }

    _scheduleLoginPrompt();
  }

  void _scheduleLoginPrompt() async{
    if (_isLoginPromptHandled) {
      return;
    }
    _isLoginPromptHandled = true;

    if (Get.find<AuthController>().isLoggedIn()) {
      return;
    }

    await Future.delayed(const Duration(seconds: 2)).then((_){
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) {
        return;
      }
      Get.bottomSheet(const LoginOrSignupBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true);
    });

  }

  final ScrollController scrollController = ScrollController();
  final GlobalKey _scrollViewKey = GlobalKey();
  final GlobalKey _exploreHeaderKey = GlobalKey();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double _resolveBackToTopTop() {
    final RenderObject? scrollObject = _scrollViewKey.currentContext?.findRenderObject();
    final RenderObject? headerObject = _exploreHeaderKey.currentContext?.findRenderObject();

    if(scrollObject is! RenderBox || headerObject is! RenderBox || !scrollObject.attached || !headerObject.attached) {
      return BackToTopButton.gap;
    }

    final double headerHeight = headerObject.size.height;
    final double headerBottom = headerObject.localToGlobal(Offset(0, headerHeight)).dy - scrollObject.localToGlobal(Offset.zero).dy;
    final bool isPinned = headerBottom > 0 && headerBottom <= headerHeight;
    return (isPinned ? headerBottom : 0) + BackToTopButton.gap;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HomeAppBar(backButton: false, scrollController: scrollController),
      drawer: null,
      endDrawer: null,
      floatingActionButton: const FloatingViewCartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(children: [
          CurvedTopContainer(
          scrollController: scrollController,
          child: RefreshIndicator(
          onRefresh: () async {

            if(availableServiceCount > 0){
              Get.find<SplashController>().getConfigData();
              await Get.find<ServiceController>().getAllServiceList(1,true);
              await Get.find<ExploreServicesController>().refreshSelectedCategory();
              await Get.find<BannerController>().getBannerList(true);
              await  Get.find<AdvertisementController>().getAdvertisementList(true);
              await Get.find<CategoryController>().getCategoryList(true);
              await Get.find<ProviderBookingController>().getProviderList(1, true);
              await Get.find<ServiceController>().getPopularServiceList(1,true,);
              await Get.find<ServiceController>().getRecommendedServiceList(1,true);
              await Get.find<CampaignController>().getCampaignList(true);
              await Get.find<ServiceController>().getFeatherCategoryList(true);
              await Get.find<CartController>().refreshCart();
              if(Get.find<AuthController>().isLoggedIn()) {
                await Get.find<ServiceController>().getRecentlyViewedServiceList(1,true,);
                if(Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false){
                  await Get.find<BookingRebookController>().loadRebookableBookings(reload: true);
                }
              }
            }else{
              await Get.find<BannerController>().getBannerList(true);
            }
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: GetBuilder<SplashController>(builder: (splashController){
              return GetBuilder<ProviderBookingController>(builder: (providerController){
                return GetBuilder<ServiceController>(builder: (serviceController){

                  bool isAvailableProvider = providerController.providerList != null && providerController.providerList!.isNotEmpty;
                  int ? providerBooking = splashController.configModel.content?.directProviderBooking;
                  bool isLtr = Get.find<LocalizationController>().isLtr;
                  bool showProviderSection = providerBooking == 1 && (isAvailableProvider || providerController.providerList == null);

                  return  CustomScrollView(
                    key: _scrollViewKey,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics()
                    ),
                    slivers: [

                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding16)),

                      if(availableServiceCount > 0) ...[

                        // 1. Category
                        const HomeSectionSliver(name: 'category', child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                          child: CategoryView(),
                        )),

                        // 2. Banner
                        const HomeSectionSliver(name: 'banner', child: BannerView()),

                        // 3. Request a custom service
                        if((Get.find<SplashController>().configModel.content?.biddingStatus == 1) && serviceController.allService != null && serviceController.allService!.isNotEmpty) ...[
                          const HomeSectionSliver(name: 'create_post', child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding20),
                            child: HomeCreatePostView(showShimmer: false,),
                          )),
                        ],

                        // 4. Easy rebooking
                        if(Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false) ...[
                          HomeSectionSliver(name: 'easy_booking', child: HomeEasyBookingWidget()),
                        ],

                        // 5. Popular services
                        HomeSectionSliver(name: 'popular_services', child: HorizontalScrollServiceView(fromPage: 'most_popular_services',serviceList: serviceController.popularServiceList)),

                        // 6. Highlight / featured providers
                        const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding10)),
                        const HomeSectionSliver(name: 'highlight_provider', child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                          child: HighlightProviderWidget(),
                        )),

                        // 7. Recommended providers
                        if(Get.find<SplashController>().configModel.content?.directProviderBooking==1) ...[
                          const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding20)),
                          const HomeSectionSliver(name: 'recommend_provider', child: HomeRecommendProvider(height: 300,)),
                        ],

                        // 8. Nearby providers
                        if(showProviderSection) ...[
                          const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding20)),
                          HomeSectionSliver(name: 'nearby_provider', child: NearbyProviderListview(height:  isLtr ? 310 : 325)),
                        ],

                        // 9. Campaign
                        const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding32)),
                        const HomeSectionSliver(name: 'campaign', child: CampaignView()),

                        // 10. Explore nearby providers card
                        if(showProviderSection)
                          HomeSectionSliver(name: 'explore_provider_card', child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding20),
                            child: ExploreProviderCard(showShimmer: providerController.providerList == null,),
                          )),

                        // 11. Recently viewed services
                        if(Get.find<AuthController>().isLoggedIn()) ...[
                          // const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding20)),
                          HomeSectionSliver(name: 'recently_viewed', child: HorizontalScrollServiceView(fromPage: 'recently_view_services',serviceList: serviceController.recentlyViewServiceList)),
                        ],


                        // 12. Feathered categories
                        const HomeSectionSliver(name: 'featured_category', child: FeaturedCategoryView()),

                        // 13. Services only for you
                        if(Get.find<AuthController>().isLoggedIn())
                        HomeSectionSliver(name: 'popular_services', child: HorizontalScrollServiceView(fromPage: 'services_only_for_you',serviceList: serviceController.recommendedServiceList)),

                        // 14. Explore all services
                        if(serviceController.allService != null && serviceController.allService!.isNotEmpty && (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context))) ...[
                          HomeSectionSliver(name: 'explore_title', child: Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding32, Dimensions.padding16,  Dimensions.padding4),
                            child: Text('explore_all_services'.tr, style: context.heading.extraLarge),
                          )),

                          SliverPersistentHeader(
                            pinned: true,
                            delegate: ExploreCategoryTabHeaderDelegate(headerKey: _exploreHeaderKey),
                          ),
                          const HomeSectionSliver(name: 'spacer', child: SizedBox(height: Dimensions.padding4))
                        ],

                        HomeSectionSliver(name: 'explore_list', child: GetBuilder<ExploreServicesController>(builder: (exploreController) {
                          return PaginatedListView(
                            key: ValueKey<String>('explore_services_${exploreController.selectedCategoryId ?? 'all'}'),
                            scrollController: scrollController,
                            totalSize: exploreController.totalSize,
                            offset: exploreController.currentPage,
                            onPaginate: (int offset) async => await exploreController.loadMore(offset),
                            showBottomSheet: true,
                            itemView: ServiceViewVertical(
                              service: exploreController.serviceList,
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Get.isDarkMode ? Dimensions.padding10 : 0),
                              type: 'others',
                              noDataType: NoDataType.home,
                            ),
                          );
                        })),
                      ] else ...[
                        const HomeSectionSliver(name: 'banner', child: BannerView()),
                        HomeSectionSliver(name: 'service_unavailable', child: SizedBox( height: MediaQuery.of(context).size.height *.6, child: const ServiceNotAvailableScreen())),
                      ],

                      const SliverToBoxAdapter(child: ViewCartBottomSpace()),

                    ],
                  );
                });
              });
            })
            ),
            ),
          ),

          BackToTopButton(scrollController: scrollController, topResolver: _resolveBackToTopTop),
        ]),
      ),
    );
  }
}
