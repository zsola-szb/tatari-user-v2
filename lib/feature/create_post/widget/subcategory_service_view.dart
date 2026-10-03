import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SubcategoryServiceView extends StatefulWidget {
  final String categorySlug;
  const SubcategoryServiceView({super.key, required this.categorySlug}) ;

  @override
  State<SubcategoryServiceView> createState() => _SubcategoryServiceViewState();
}

class _SubcategoryServiceViewState extends State<SubcategoryServiceView>  with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getSubCategoryList(widget.categorySlug,shouldUpdate: false).then((value) {
      Get.find<ServiceController>().getSubCategoryBasedServiceList(
        Get.find<CategoryController>().subCategoryList !=null && Get.find<CategoryController>().subCategoryList!.isNotEmpty
            ? Get.find<CategoryController>().subCategoryList![0].slug! : "", showShimmerAlways: true,
      );
      tabController = TabController(length: Get.find<CategoryController>().subCategoryList?.length??0, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return pointerInterceptor();
  }

  Padding pointerInterceptor(){
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: GetBuilder<CategoryController>(builder: (categoryController){
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: Get.height/1.5,
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.only(top: Dimensions.padding20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Center(child: Container(height: 5,width: 90,decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.fontSizeDefault),
                          color: Theme.of(context).hintColor,
                        ),)),
                        const SizedBox(height: Dimensions.padding16,),

                        (categoryController.subCategoryList != null && categoryController.subCategoryList!.isNotEmpty )? Container(
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(
                              color: Theme.of(context).hintColor
                          )), color: Theme.of(context).cardColor
                          ),
                          child: TabBar(
                            controller: tabController,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: true,
                            indicatorColor: Theme.of(context).primaryColor,
                            labelColor:  Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color :  Theme.of(context).colorScheme.primary,
                            labelStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),
                            tabs: categoryController.subCategoryList!.map((e) {
                              return Tab(text: e.name);
                            }).toList(),
                            onTap: (index)async {
                              Get.find<ServiceController>().getSubCategoryBasedServiceList(categoryController.subCategoryList?[index].slug??"",showShimmerAlways: true);
                            },
                          ),
                        ): const SizedBox(),

                        GetBuilder<ServiceController>(builder: (serviceController){

                          if((categoryController.subCategoryList != null && serviceController.subCategoryBasedServiceList != null
                              &&  serviceController.subCategoryBasedServiceList!.isEmpty) || (categoryController.subCategoryList != null && categoryController.subCategoryList!.isEmpty)){
                           return Padding(padding: EdgeInsets.only(top: Get.height * 0.1),
                             child: NoDataScreen(text: 'no_services_found'.tr,type: NoDataType.service,),
                           );
                          }else if(serviceController.subCategoryBasedServiceList!=null && categoryController.subCategoryList != null){
                            return Padding(padding: EdgeInsets.only(top: Dimensions.padding16,
                              bottom:  40,
                            ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(bottom: Dimensions.padding24,),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: serviceController.subCategoryBasedServiceList!.length,
                                    itemBuilder: (context, index) {
                                      bool showDiscountedPrice = false;
                                      showDiscountedPrice = ((serviceController.subCategoryBasedServiceList?[index].lowestPrice ?? 0) > (serviceController.subCategoryBasedServiceList?[index].discountedLowestPrice ?? 0));

                                      return GestureDetector(
                                        onTap: (){
                                          Get.back();
                                          Get.find<CreatePostController>().updateSelectedService(serviceController.subCategoryBasedServiceList![index]);
                                        },
                                        child: Padding(
                                          padding:  const EdgeInsets.symmetric(vertical:Dimensions.padding10,horizontal: Dimensions.padding16),
                                          child: Container(
                                            padding: const EdgeInsets.all(Dimensions.padding10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.radius12),
                                              boxShadow: Get.find<ThemeController>().darkTheme? [const BoxShadow()]: [BoxShadow(
                                                offset: const Offset(0, 2),
                                                blurRadius: 5,
                                                color: Colors.black.withValues(alpha: 0.05),
                                              )],
                                              color: Theme.of(context).cardColor
                                            ),
                                            child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radius6),
                                                child: CustomImage(height: 90, width: 90, fit: BoxFit.cover,
                                                  image:"${serviceController.subCategoryBasedServiceList?[index].thumbnailFullPath}",
                                                ),
                                              ),
                                              const SizedBox(width: Dimensions.padding16,),
                                              Expanded(
                                                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                                                  const SizedBox(height: Dimensions.padding6,),
                                                  Text( serviceController.subCategoryBasedServiceList?[index].name??"", style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                                                      maxLines: 1, overflow: TextOverflow.ellipsis),
                                                  const SizedBox(height: Dimensions.padding10),
                                                  Text("starts_from".tr,style: context.body.defaultSize,),
                                                  const SizedBox(height: Dimensions.padding6),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      if(showDiscountedPrice)
                                                        Directionality(
                                                          textDirection: TextDirection.ltr,
                                                          child: Text(
                                                            PriceConverter.convertPrice(serviceController.subCategoryBasedServiceList?[index].lowestPrice ?? 0),
                                                            maxLines: 2,
                                                            style: context.subHeading.large.copyWith(
                                                              color: Theme.of(context).colorScheme.error.withValues(alpha: .8),
                                                              decoration: TextDecoration.lineThrough,
                                                            ),),
                                                        ),
                                                      const SizedBox(width: Dimensions.padding10),

                                                      showDiscountedPrice ?
                                                      Directionality(
                                                        textDirection: TextDirection.ltr,
                                                        child: Text(
                                                          PriceConverter.convertPrice(serviceController.subCategoryBasedServiceList?[index].discountedLowestPrice),
                                                          style: context.subHeading.large.overrideWith(
                                                            fontWeight: AppWeight.medium,
                                                            color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                      ): Directionality(
                                                        textDirection: TextDirection.ltr,
                                                        child: Text(
                                                          PriceConverter.convertPrice(serviceController.subCategoryBasedServiceList?[index].lowestPrice),
                                                          style: context.subHeading.large.overrideWith(
                                                            fontWeight: AppWeight.medium,
                                                            color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],),
                                              )
                                            ],),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: Dimensions.padding20),
                              ]),
                            );
                          }else{
                            return  GridView.builder(

                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: Dimensions.padding20,
                                mainAxisSpacing: Dimensions.padding10,
                                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 1,
                                mainAxisExtent: ResponsiveHelper.isMobile(context) ? 115 : 120,
                              ),
                              itemCount: 6,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: Dimensions.padding24,top: Dimensions.padding16),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder:(BuildContext context, index) {
                                return  const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                                  child: SubCategoryShimmer(isEnabled: true, hasDivider: false),
                                );
                              },
                            );
                          }
                        })
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
    );
  }
}
