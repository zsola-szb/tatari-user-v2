import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class HomeSearchField extends StatelessWidget {
  final double height;
  const HomeSearchField({super.key, this.height = 48});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: () => Get.toNamed(RouteHelper.getSearchInitRoute()),
      child: Container(
        height: height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.padding16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
          border: Border.all(
            color: context.customThemeColors.secondaryBackGroundColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          color: Theme.of(context).cardColor,
        ),
        child: Row(children: [
          Image.asset(
            Images.searchIcon,
            width: 20,
            height: 20,
            color: context.customThemeColors.secondaryTextColor,
            colorBlendMode: BlendMode.srcIn,
          ),
          const SizedBox(width: Dimensions.padding8),
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (categoryController) => RollingSearchHint(words: categoryController.searchHintNames),
            ),
          ),
        ]),
      ),
    );
  }
}
