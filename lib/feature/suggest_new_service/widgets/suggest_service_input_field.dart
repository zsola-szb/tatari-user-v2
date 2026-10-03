import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SuggestServiceInputField extends StatefulWidget {
  const SuggestServiceInputField({super.key}) ;

  @override
  State<SuggestServiceInputField> createState() => _SuggestServiceInputFieldState();
}

class _SuggestServiceInputFieldState extends State<SuggestServiceInputField> {

  final FocusNode _serviceName = FocusNode();
  final FocusNode _serviceDetails = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuggestServiceController>(builder: (suggestedServiceController){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

        TextFieldTitle(title: "service_category".tr,requiredMark: true),
        GetBuilder<CategoryController>(builder: (categoryController){
          return Container(width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.padding10),
                border: Border.all( color: Theme.of(context).hintColor.withValues(alpha: 0.2))
            ),
            child: DropdownButtonHideUnderline(

              child: DropdownButton(
                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5), elevation: 2,

                  hint: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                    child: Text(suggestedServiceController.selectedCategoryName==''?
                    "select_category".tr:suggestedServiceController.selectedCategoryName,
                      style: context.subHeading.defaultSize.overrideWith(
                        color: suggestedServiceController.selectedCategoryName==''? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6): Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  icon: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                    child: SvgPicture.asset(Images.chevronDownArrowIcon,
                      width: 16, height: 16,
                      colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                    ),
                  ),
                  items: categoryController.categoryList?.map((CategoryModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(items.name ?? "",
                              style: context.body.defaultSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (CategoryModel? newValue) => suggestedServiceController.setCategory(newValue)
              ),
            ),
          );
        }),

        TextFieldTitle(title:"sub_category".tr, requiredMark: true),
        GetBuilder<CategoryController>(builder: (categoryController){
          return Container(width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.padding10),
                border: Border.all( color: Theme.of(context).hintColor.withValues(alpha: 0.2))
            ),
            child: DropdownButtonHideUnderline(

              child: DropdownButton(

                  isExpanded: true,
                  dropdownColor: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5), elevation: 2,

                  hint: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                    child: Text(suggestedServiceController.selectedSubCategoryName==''?
                    "sub_category".tr:suggestedServiceController.selectedSubCategoryName,
                      style: context.subHeading.defaultSize.overrideWith(
                        color: suggestedServiceController.selectedSubCategoryName==''? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.6): Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  icon: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                    child: SvgPicture.asset(Images.chevronDownArrowIcon,
                      width: 16, height: 16,
                      colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                    ),
                  ),
                  items: categoryController.subCategoryList?.map((CategoryModel items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(items.name ?? "",
                              style: context.body.defaultSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (CategoryModel? newValue) => suggestedServiceController.setSubCategory(newValue)
              ),
            ),
          );
        }),

        TextFieldTitle(title:"service_name".tr, requiredMark: true),

        CustomTextField(
          hintText: 'service_name_hint'.tr,
          controller: suggestedServiceController.serviceNameController,
          inputType: TextInputType.text,
          inputAction: TextInputAction.next,
          isShowBorder: true,
          focusNode: _serviceName,
          nextFocus: _serviceDetails,
        ),

        TextFieldTitle(title:"service_description".tr, requiredMark: true),
        CustomTextField(
          hintText: "enter_a_description".tr,
          inputType: TextInputType.text,
          maxLines: 4,
          isShowBorder: true,
          focusNode: _serviceDetails,
          inputAction: TextInputAction.done,
          controller: suggestedServiceController.serviceDetailsController,
        ),
      ],
      );
    });
  }
}
