import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  static const int _crossAxisCount = 4;
  static const int _maxVisibleCategories = 8;
  static const double _containerSize = 72;
  static const double _imageSize = 50;
  static const int _labelMaxLines = 2;

  static double tileExtent(BuildContext context) {
    final TextStyle labelStyle = context.body.small;
    final double lineHeight = MediaQuery.textScalerOf(context).scale(labelStyle.fontSize ?? Dimensions.fontSizeSmall) *
            (labelStyle.height ?? Dimensions.fontHeightMedium);
    return _containerSize + Dimensions.padding10 + (lineHeight * _labelMaxLines).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {

      return categoryController.categoryList != null && categoryController.categoryList!.isEmpty ? const SizedBox() :
      categoryController.categoryList != null ? Center(
        child: SizedBox(width: Dimensions.webMaxWidth,
          child: Padding(padding: const EdgeInsets.symmetric( vertical:Dimensions.padding4),
            child: Column(children: [

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemCount: categoryController.categoryList!.length > _maxVisibleCategories ? _maxVisibleCategories : categoryController.categoryList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  crossAxisSpacing: Dimensions.padding10,
                  mainAxisSpacing: Dimensions.padding16,
                  mainAxisExtent: tileExtent(context),
                ),
                itemBuilder: (context, index) {
                  final category = categoryController.categoryList![index];
                    return InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(category.slug ?? '', category.name ?? '')),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Stack(clipBehavior: Clip.none, children: [
                          Container(
                            height: _containerSize,
                            width: _containerSize,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                              color: context.customThemeColors.secondaryBackGroundColor,
                            ),
                            child: Center(child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius12),
                              child: CustomImage(
                                width: _imageSize,
                                height: _imageSize,
                                image: categoryController.categoryList?[index].imageFullPath ?? "",
                                fit: BoxFit.cover,
                              ),
                            )),
                          ),

                          PositionedDirectional(
                            top: -CategoryOfferBadge.overlapFromCorner,
                            end: -CategoryOfferBadge.overlapFromCorner,
                            child: CategoryOfferBadge(category: category),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.padding10),

                        Flexible(child: Text(
                          categoryController.categoryList?[index].name ?? '',
                          style: context.subHeading.small.overrideWith(
                            color: context.customThemeColors.textColor,
                          ),
                          maxLines: _labelMaxLines,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ]),
                    );
                },
              ),

              const SizedBox(height: Dimensions.padding12),

              InkWell(
                onTap: ()=> Get.bottomSheet(const HomeCategoryBottomSheetWidget(), backgroundColor: Colors.transparent, isScrollControlled: true),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Text('view_all'.tr, style: heading.defaultSize.overrideWith(
                    color: Theme.of(context).colorScheme.primary,
                  )),
                  const SizedBox(width: Dimensions.padding6),
                  SvgPicture.asset(
                    Images.chevronDownArrowIcon, width: 18, height: 18,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                ]),
              ),

            ]),
          ),
        ),
      ) : const CategoryShimmer();
    });
  }
}


class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
          child: Column(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: CategoryView._maxVisibleCategories,
                itemBuilder: (context, index) {
                  return Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        height: CategoryView._containerSize,
                        width: CategoryView._containerSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                      const SizedBox(height: Dimensions.padding10),
                      Container(
                        height: 12, width: CategoryView._containerSize * 0.7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6),
                        ),
                      ),
                    ]),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: CategoryView._crossAxisCount,
                  crossAxisSpacing: Dimensions.padding10,
                  mainAxisSpacing: Dimensions.padding16,
                  mainAxisExtent: CategoryView.tileExtent(context),
                ),
              ),
              const SizedBox(height: Dimensions.padding16),
              Container(
                height: 18, width: 90,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
