import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryWidget extends GetView<ServiceController> {
  final CategoryModel? categoryModel;
  const SubCategoryWidget({super.key, required this.categoryModel,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final String categorySlug = categoryModel?.slug ?? '';
        if (categorySlug.isEmpty) {
          return;
        }
        Get.find<ServiceController>().cleanSubCategory();
        Get.toNamed(RouteHelper.allServiceScreenRoute(categorySlug));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius6),
            color: Theme.of(context).cardColor,
            boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius6),
            child: CustomImage(
              image: categoryModel?.imageFullPath ?? "",
              height: 90, width: 90 , fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(children: [
                  Expanded(child: Text(
                    categoryModel?.name ?? "",
                    style: context.heading.defaultSize,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  )),
                ]),
                const SizedBox(height: Dimensions.padding6),
                Text( categoryModel?.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: context.subHeading.small,
                ),
                const SizedBox(height: Dimensions.padding6,),
                Text( "${categoryModel?.serviceCount ?? "" } ${'services'.tr} ",
                  style: context.subHeading.defaultSize.copyWith(
                    color: Get.isDarkMode ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
