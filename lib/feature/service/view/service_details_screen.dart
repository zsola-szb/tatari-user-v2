import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String? serviceID;
  final String? fromPage;
  const ServiceDetailsScreen({super.key, this.serviceID,this.fromPage="others"}) ;

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {

  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if(widget.serviceID != null){
      Get.find<ServiceDetailsController>().getServiceDetails(widget.serviceID!, fromPage: widget.fromPage == "search_page" ? "search_page" : "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double heroHeight = ServiceHeroHeader.coverHeight(context);
    final double topThreshold = MediaQuery.of(context).padding.top + 122;
    final double middlePoint = MediaQuery.of(context).size.height / 2;

    return CustomPopWidget(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: context.customThemeColors.secondaryBackGroundColor,
        drawer: null,
        endDrawer: null,
        body: GetBuilder<ServiceDetailsController>(
          builder: (serviceController) {
            if(serviceController.service != null || widget.serviceID == null){
              if(serviceController.service != null && serviceController.service!.id != null &&  widget.serviceID != null){
                Service service = serviceController.service!;
                final String serviceId = service.id!;
                final bool hasFaqs = service.faqs?.isNotEmpty ?? false;
                final bool hasVariations = (service.variations?? []).isNotEmpty;
                final bool hasDescription = service.description?.trim().isNotEmpty ?? false;
                final bool hasRelatedServices = serviceController.relatedServices.isNotEmpty;
                final bool hasServiceProviders = serviceController.serviceProviders.isNotEmpty;

                return FooterBaseView(
                  isScrollView: false,
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: GetBuilder<ServiceTabController>(
                        init: Get.find<ServiceTabController>(),
                        initState: (state) {
                          final ServiceTabController tabController = Get.find<ServiceTabController>();
                          final ReviewRatingController reviewRatingController = Get.find<ReviewRatingController>();
                          tabController.rebuildSectionKeys(service);
                          tabController.scrollController.addListener(() => tabController.onScroll(heroHeight, middlePoint));
                          reviewRatingController
                              .getCustomerReviews(id: serviceId, source: ReviewSource.service, offset: 1, shouldUpdate: false)
                              .then((_) => tabController.updateHasReviews(
                                    hasReviews: reviewRatingController.customerReviewList.isNotEmpty,
                                    service: service));
                        },
                        builder: (tabController) {
                          final Map<String, GlobalKey> sectionKeys = tabController.sectionKeys;
                          final bool hasReviews = tabController.hasReviews;

                          return Stack(children: [
                            Column(children: [
                              Expanded(
                                child: CustomScrollView(
                                  controller: tabController.scrollController,
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          ServiceHeroHeader(service: service, height: heroHeight),
                                          Padding(
                                            padding: EdgeInsets.only(top: heroHeight - Dimensions.radius28),
                                            child: ServiceTitlePriceSection(service: service),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),

                                    if(hasVariations) ...[
                                      SliverToBoxAdapter(
                                        child: Container(
                                          key: sectionKeys['variations'],
                                          child: ServiceVariationsSection(serviceId: serviceId),
                                        ),
                                      ),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],

                                    if(hasDescription) ...[
                                      SliverToBoxAdapter(
                                        child: Container(
                                          key: sectionKeys['overview'],
                                          child: ServiceExpandableCard(
                                            title: 'service_overview'.tr,
                                            children: [ServiceOverview(description: service.description)],
                                          ),
                                        ),
                                      ),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],

                                    if(hasServiceProviders) ...[
                                      const SliverToBoxAdapter(child: ServiceProviderSection()),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],

                                    if(hasReviews) ...[
                                      SliverToBoxAdapter(
                                        child: Container(
                                          key: sectionKeys['reviews'],
                                          child: ServiceExpandableCard(
                                            title: 'reviews'.tr,
                                            children: [ServiceDetailsReview(serviceID: serviceId)],
                                          ),
                                        ),
                                      ),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],

                                    if(hasFaqs) ...[
                                      SliverToBoxAdapter(
                                        child: Container(key: sectionKeys['faqs'], child: const ServiceDetailsFaqSection()),
                                      ),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],


                                    if(hasRelatedServices) ...[
                                      const SliverToBoxAdapter(child: ServiceAlsoLikeSection()),
                                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.padding6)),
                                    ],
                                  ],
                                ),
                              ),
                              ServiceBottomCartBar(service: service),
                            ]),

                            Positioned(
                              top: 0, left: 0, right: 0,
                              child: IgnorePointer(
                                ignoring: !tabController.showPinnedHeader,
                                child: AnimatedOpacity(
                                  opacity: tabController.showPinnedHeader ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: ServicePinnedHeader(service: service, tabController: tabController, topThreshold: topThreshold),
                                ),
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ),
                );
              }else{
                return NoDataScreen(text: 'no_service_available'.tr,type: NoDataType.service,);
              }
            }else{
              return const ServiceDetailsShimmerWidget();
            }
          },
        ),
      ),
    );
  }
}
