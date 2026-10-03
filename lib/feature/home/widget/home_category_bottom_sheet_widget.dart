import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class HomeCategoryBottomSheetWidget extends StatelessWidget {
  const HomeCategoryBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const double containerSize = 65;
    const double imageSize = 40;

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return Container(
        width: Dimensions.webMaxWidth,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
          color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface,
        ),
        child: SafeArea(
          top: false,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: Dimensions.padding32),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('all_categories'.tr, style: context.heading.extraLarge),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding20),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.6),
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: Dimensions.padding8),
                        itemCount: categoryController.categoryList?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 6,
                          crossAxisSpacing: Dimensions.padding10,
                          mainAxisSpacing: Dimensions.padding16,
                          childAspectRatio: Get.height * 0.0008,
                        ),
                        itemBuilder: (context, index) {
                            final CategoryModel? category = categoryController.categoryList?[index];
                            if (category == null) {
                              return const SizedBox();
                            }

                            return InkWell(
                              onTap: () {
                                Get.back();
                                Get.toNamed(RouteHelper.getCategoryProductRoute(category.slug ?? '', category.name ?? ''));
                              },
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Stack(clipBehavior: Clip.none, children: [
                                  Container(
                                    height: containerSize,
                                    width: containerSize,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                                      color: context.customThemeColors.secondaryBackGroundColor,
                                    ),
                                    child: Center(child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                                      child: CustomImage(
                                        width: imageSize,
                                        height: imageSize,
                                        image: category.imageFullPath ?? "",
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
                                  category.name ?? '',
                                  style: context.body.small.overrideWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ]),
                            );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding20),
                ]),
              ),

              Positioned(
                top: 10,
                right: 0,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.customThemeColors.backGroundColor,
                    ),
                    padding: const EdgeInsets.all(Dimensions.padding3),
                    child: Icon(Icons.close, size: 20, color: context.customThemeColors.secondaryTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
