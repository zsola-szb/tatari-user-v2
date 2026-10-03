import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SubcategoryPickerSheet extends StatefulWidget {
  final String categorySlug;
  const SubcategoryPickerSheet({super.key, required this.categorySlug});

  @override
  State<SubcategoryPickerSheet> createState() => _SubcategoryPickerSheetState();
}

class _SubcategoryPickerSheetState extends State<SubcategoryPickerSheet> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getSubCategoryList(widget.categorySlug, shouldUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: GetBuilder<CategoryController>(builder: (categoryController){
        List<CategoryModel>? subCategoryList = categoryController.subCategoryList;

        return Container(
          height: Get.height / 1.5,
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.only(top: Dimensions.padding20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Container(
                height: 5, width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.fontSizeDefault),
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.padding16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: Text('select_sub_category'.tr, style: context.heading.defaultSize),
            ),
            const SizedBox(height: Dimensions.padding8),

            Expanded(
              child: subCategoryList == null
                  ? ListView.builder(
                      itemCount: 6,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                      itemBuilder: (context, index) => const SubCategoryShimmer(isEnabled: true, hasDivider: true),
                    )
                  : subCategoryList.isEmpty
                      ? NoDataScreen(text: 'no_sub_category_found'.tr, type: NoDataType.service)
                      : ListView.builder(
                          itemCount: subCategoryList.length,
                          padding: const EdgeInsets.only(bottom: Dimensions.padding24),
                          itemBuilder: (context, index) => _SubcategoryTile(subCategory: subCategoryList[index])),
            ),
          ]),
        );
      }),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  final CategoryModel subCategory;
  const _SubcategoryTile({required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController){
      bool isSelected = createPostController.selectedSubCategoryId == subCategory.id;

      return CustomInkWell(
        onTap: (){
          createPostController.selectSubCategory(subCategory);
          Get.back();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12, horizontal: Dimensions.padding16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius6),
              child: CustomImage(height: 40, width: 40, fit: BoxFit.cover, image: subCategory.imageFullPath ?? ""),
            ),
            const SizedBox(width: Dimensions.padding12),

            Expanded(
              child: Text(subCategory.name ?? "",
                style: context.subHeading.defaultSize.overrideWith(
                  fontWeight: isSelected ? AppWeight.medium : null,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),

            if(isSelected)
              Icon(Icons.check_circle, size: 20, color: Theme.of(context).colorScheme.primary),
          ]),
        ),
      );
    });
  }
}