import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PopularCategoriesInitSection extends StatefulWidget {
  const PopularCategoriesInitSection({super.key});

  @override
  State<PopularCategoriesInitSection> createState() => _PopularCategoriesInitSectionState();
}

class _PopularCategoriesInitSectionState extends State<PopularCategoriesInitSection> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController){
      final List<CategoryModel>? categoryList = categoryController.categoryList;

      if(categoryList != null && categoryList.isEmpty){
        return const SizedBox();
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Text('popular_categories'.tr, style: heading.extraLarge.strong),
        ),
        const SizedBox(height: Dimensions.padding16,),

        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            itemCount: categoryList == null ? 4 : categoryList.length,
            itemBuilder: (context, index){
              if(categoryList == null){
                return const PopularCategoryTileShimmer();
              }

              final CategoryModel category = categoryList[index];

              return Padding(
                padding: const EdgeInsetsDirectional.only(end: Dimensions.padding10),
                child: InkWell(
                  onTap: (){
                    Get.find<AllSearchController>().populatedSearchController(category.name ?? '');
                    Get.toNamed(RouteHelper.getSearchResultRoute(queryText: category.name));
                  },
                  child: Column(children: [
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                        color: context.customThemeColors.secondaryBackGroundColor,
                      ),
                      child: Center(child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        child: CustomImage(
                          width: 40,
                          height: 40,
                          image: category.imageFullPath ?? "",
                          fit: BoxFit.cover,
                        ),
                      )),
                    ),
                    const SizedBox(height: Dimensions.padding10),
                    SizedBox(
                      width: 65,
                      child: Text(
                        category.name ?? '',
                        style: context.subHeading.small,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        ),

      ]);
    });
  }
}

class PopularCategoryTileShimmer extends StatelessWidget {
  const PopularCategoryTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: Dimensions.padding10),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(height: Dimensions.padding10),
          Container(height: 12, width: 50, color: Theme.of(context).shadowColor),
        ]),
      ),
    );
  }
}
