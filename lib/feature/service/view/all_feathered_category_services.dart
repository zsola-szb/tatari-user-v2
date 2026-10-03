import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AllFeatheredCategoryServiceView extends StatefulWidget {
  final String? fromPage;
  final String? categorySlug;
  const AllFeatheredCategoryServiceView({super.key, this.fromPage, this.categorySlug});

  @override
  State<AllFeatheredCategoryServiceView> createState() => _AllFeatheredCategoryServiceViewState();
}

class _AllFeatheredCategoryServiceViewState extends State<AllFeatheredCategoryServiceView> {

  static const int allServiceLimit = 50;

  List<Service>? serviceList;
  @override
  void initState() {
    super.initState();
    final ServiceController serviceController = Get.find<ServiceController>();
    serviceController.getFeatherCategoryList(false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => serviceController.getFeaturedCategoryServiceList(widget.categorySlug, limit: allServiceLimit),
    );
  }

  @override
  Widget build(BuildContext context) {



    return CustomPopWidget(
      child: Scaffold(
        appBar: CustomAppBar(
          title:widget.fromPage ,showCart: true,),
        drawer: null,

        endDrawer: null,
        body:  FooterBaseView(
          child: GetBuilder<ServiceController>(builder: (serviceController){

            serviceList = serviceController.featuredCategoryServices(widget.categorySlug);

            return serviceController.categoryList != null &&  serviceController.categoryList!.isNotEmpty ?  SizedBox(
              width: Dimensions.webMaxWidth,
              child: (serviceList != null && serviceList!.isEmpty) || widget.categorySlug == null ?  NoDataScreen(text: 'no_services_found'.tr,type: NoDataType.service,) :  serviceList != null ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16,vertical: Dimensions.padding16),
                child: LayoutBuilder(builder: (context, constraints) {

                  final int crossAxisCount = ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 5;
                  final double itemWidth = (constraints.maxWidth - (Dimensions.padding16 * (crossAxisCount - 1))) / crossAxisCount;

                  return CustomScrollView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [

                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Dimensions.padding16,
                          mainAxisSpacing:  Dimensions.padding16,
                          childAspectRatio: ResponsiveHelper.isTab(context) ? .9 : .75,
                          crossAxisCount: crossAxisCount,
                          mainAxisExtent: ServiceWidgetVertical.heightFor(context, itemWidth),
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return ServiceWidgetVertical(service: serviceList![index], fromType: widget.fromPage ?? "",);
                          },
                          childCount: serviceList!.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  );
                }),
              ) : GridView.builder(
                key: UniqueKey(),
                padding: const EdgeInsets.only(
                  top: Dimensions.padding16,
                  bottom: Dimensions.padding16,
                  left: Dimensions.padding16,
                  right: Dimensions.padding16,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.padding16,
                  mainAxisSpacing:  Dimensions.padding16,
                  childAspectRatio: ResponsiveHelper.isTab(context) ? 1 : .70,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 5,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const ServiceShimmer(isEnabled: true, hasDivider: false);
                },
              ),
            ) : const Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }




}

