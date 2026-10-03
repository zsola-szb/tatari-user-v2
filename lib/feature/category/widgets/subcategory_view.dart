import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/category/widgets/sub_category_widget.dart';

class SubCategoryView extends GetView<CategoryController> {
  final EdgeInsetsGeometry? padding;
  final bool? isScrollable;
  final int? shimmerLength;
  final String? noDataText;
  final String? type;
  final Function(String type)? onVegFilterTap;
  const SubCategoryView({super.key,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(Dimensions.padding10),
    this.noDataText, this.type,
    this.onVegFilterTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
     builder: (categoryController){
       if(categoryController.subCategoryList == null){
         return  SliverGrid(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisSpacing:ResponsiveHelper.isTab(context) ? 0.0 : Dimensions.padding10,
             mainAxisSpacing: Dimensions.padding10,
             crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 3,
             mainAxisExtent: 120,
           ),
           delegate: SliverChildBuilderDelegate((context, index) {
               return SubCategoryShimmer(isEnabled: true, hasDivider: index != shimmerLength!-1);
             },
             childCount: 6,
           ),
         );
       }else{
         List<CategoryModel> subCategoryList = categoryController.subCategoryList ?? [];
         return subCategoryList.isNotEmpty ? SliverGrid(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisSpacing:ResponsiveHelper.isTab(context) ? 0.0 : Dimensions.padding10,
             mainAxisSpacing: Dimensions.padding10,
             crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 3,
             mainAxisExtent: 120,
           ),
           delegate: SliverChildBuilderDelegate((context, index) {
             return SubCategoryWidget(categoryModel: subCategoryList[index]);
             },
             childCount: subCategoryList.length,
           ),
         ):
         SliverToBoxAdapter(
           child: SizedBox(
             height: Get.height / 1.5,
             child: NoDataScreen(
               text: noDataText ?? 'no_subcategory_found'.tr,
               type: NoDataType.categorySubcategory,
             ),
           ),
         );
       }
     },
    );
  }
}


class SubCategoryShimmer extends StatelessWidget {
  final bool? isEnabled;
  final bool? hasDivider;
  const SubCategoryShimmer({super.key, required this.isEnabled, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        boxShadow: Get.isDarkMode? null: [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnabled!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius12)
                  ),
                ),
                const SizedBox(width: Dimensions.padding16,),
                Expanded(
                  flex: 5,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      height:  20,
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6)
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Container(
                      height:  8,
                      margin: const EdgeInsets.only(right: Dimensions.padding20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6)
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Container(
                      height:  8,
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6)
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Container(
                      height:  8,
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6)
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Container(
                      height:  8,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6)
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

