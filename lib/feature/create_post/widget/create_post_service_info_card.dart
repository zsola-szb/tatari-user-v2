import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CreatePostServiceInfoCard extends StatelessWidget {
  final JustTheController tooltipController;
  const CreatePostServiceInfoCard({super.key, required this.tooltipController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController){
      return GetBuilder<CreatePostController>(builder: (createPostController){

        bool hasSelectedCategory = createPostController.selectedCategoryId.isNotEmpty;
        bool isOpenMarket = BusinessModelHelper.isOpenMarket;

        String? selectedCategorySlug = categoryController.categoryList?.firstWhereOrNull(
              (element) => element.id == createPostController.selectedCategoryId,
        )?.slug;

        String? selectedSubCategoryName = categoryController.subCategoryList?.firstWhereOrNull(
              (element) => element.id == createPostController.selectedService?.subCategoryId,
        )?.name;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.padding16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('service_info'.tr, style: context.heading.defaultSize),
            const SizedBox(height: Dimensions.padding16),

            TextFieldTitle(title: "service_category".tr, requiredMark: true),
            _CreatePostCategoryDropdown(categoryList: categoryController.categoryList),

            TextFieldTitle(title: "sub_category".tr, requiredMark: true),
            _CreatePostSelectField(
              // Open market tracks its own sub category selection; curated derives it from the picked service.
              value: (isOpenMarket ? null : selectedSubCategoryName)
                  ?? (createPostController.selectedSubCategoryName.isEmpty ? null : createPostController.selectedSubCategoryName),
              placeholder: 'select_sub_category'.tr,
              enabled: hasSelectedCategory,
              onTap: () => showModalBottomSheet(
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => isOpenMarket
                    ? SubcategoryPickerSheet(categorySlug: selectedCategorySlug ?? "")
                    : SubcategoryServiceView(categorySlug: selectedCategorySlug ?? ""),
              ),
            ),

            if(isOpenMarket) ...[
              TextFieldTitle(title: "service_name".tr, requiredMark: true),
              CustomTextFormField(
                outlineInputBorderRadius: Dimensions.radius8,
                hintText: "enter_service_name".tr,
                outlineInputBorderColor: Theme.of(context).hintColor,
                controller: createPostController.serviceNameController,
                capitalization: TextCapitalization.sentences,
                isShowBorder: true,
              ),
            ]else ...[
              TextFieldTitle(title: "service".tr, requiredMark: true),
              _CreatePostSelectField(
                value: createPostController.selectedService?.name,
                placeholder: 'select_service'.tr,
                enabled: hasSelectedCategory,
                onTap: () => showModalBottomSheet(
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => SubcategoryServiceView(categorySlug: selectedCategorySlug ?? ""),
                ),
              ),
            ],

            if(!isOpenMarket && createPostController.selectedService != null) ...[
              const SizedBox(height: Dimensions.padding6),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                padding: const EdgeInsets.all(Dimensions.padding6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius6),
                    child: CustomImage(
                      image: '${createPostController.selectedService!.thumbnailFullPath}',
                      height: 50, width: 50,
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding16),
                  Expanded(
                    child: Text(createPostController.selectedService!.name ?? "",
                      style: context.heading.defaultSize,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
              ),
            ],

            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextFieldTitle(title: "provide_service_description".tr, requiredMark: true),
              JustTheTooltip(
                backgroundColor: Theme.of(context).primaryColorDark,
                controller: tooltipController,
                preferredDirection: AxisDirection.up,
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius20)),
                tailLength: 14,
                tailBaseWidth: 20,
                content: Padding(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("create_service_request_instruction".tr,
                      textAlign: TextAlign.center,
                      style: context.subHeading.defaultSize.overrideWith(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ]),
                ),
                child: IconButton(
                  onPressed: (){
                    tooltipController.showTooltip();
                  },
                  icon: Icon(Icons.info_outline,
                    color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ),
              ),
            ]),

            CustomTextFormField(
              outlineInputBorderRadius: Dimensions.radius8,
              hintText: "enter_a_description".tr,
              outlineInputBorderColor: Theme.of(context).hintColor,
              maxLines: 5,
              controller: createPostController.descriptionController,
              isShowBorder: true,
            ),
          ]),
        );
      });
    });
  }
}

class _CreatePostCategoryDropdown extends StatelessWidget {
  final List<CategoryModel>? categoryList;
  const _CreatePostCategoryDropdown({required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController){
      return Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          color: Theme.of(context).cardColor,
          border: Border.all(color: context.customThemeColors.secondaryBackGroundColor)
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            isDense: true,
            dropdownColor: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            elevation: 2,
            onTap: (){
              createPostController.updateSelectedService(null);
            },
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: Text(
                createPostController.selectedCategoryName.isEmpty ? "select_category".tr : createPostController.selectedCategoryName,
                style: context.body.defaultSize,
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: SvgPicture.asset(Images.chevronDownArrowIcon,
                width: 16, height: 16,
                colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
              ),
            ),
            items: categoryList?.map((CategoryModel item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.body.defaultSize,
                ),
              );
            }).toList(),
            onChanged: (CategoryModel? newValue) {
              createPostController.selectCategory(newValue?.id ?? "");
              showModalBottomSheet(
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => BusinessModelHelper.isOpenMarket
                    ? SubcategoryPickerSheet(categorySlug: newValue?.slug ?? "")
                    : SubcategoryServiceView(categorySlug: newValue?.slug ?? ""),
              );
            },
          ),
        ),
      );
    });
  }
}

class _CreatePostSelectField extends StatelessWidget {
  final String? value;
  final String placeholder;
  final bool enabled;
  final VoidCallback onTap;
  const _CreatePostSelectField({required this.value, required this.placeholder, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
            color: Theme.of(context).cardColor,
            border: Border.all(color: context.customThemeColors.secondaryBackGroundColor)
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(value ?? placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.body.defaultSize.overrideWith(
                color: value == null ? context.customThemeColors.secondaryTextColor : null,
              ),
            ),
          ),
          SvgPicture.asset(Images.chevronDownArrowIcon,
            width: 16, height: 16,
            colorFilter: ColorFilter.mode(context.customThemeColors.secondaryTextColor, BlendMode.srcIn),
          ),
        ]),
      ),
    );
  }
}
