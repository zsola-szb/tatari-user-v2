import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ExploreCategoryTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  static const double height = 60;

  final Key? headerKey;

  const ExploreCategoryTabHeaderDelegate({this.headerKey});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _CategoryTabStrip(key: headerKey);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _CategoryTabStrip extends StatelessWidget {
  const _CategoryTabStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ExploreCategoryTabHeaderDelegate.height,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
      child: GetBuilder<CategoryController>(builder: (categoryController) {
        return GetBuilder<ExploreServicesController>(builder: (exploreController) {
          final List<CategoryModel> categories = categoryController.categoryList ?? [];
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            itemCount: categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: Dimensions.padding8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return SelectableChip(
                  label: 'all'.tr,
                  isSelected: exploreController.isAllSelected,
                  onTap: () => exploreController.selectCategory(null),
                );
              }
              final CategoryModel category = categories[index - 1];
              return SelectableChip(
                label: category.name ?? '',
                isSelected: exploreController.selectedCategoryId == category.id,
                onTap: () => exploreController.selectCategory(category),
              );
            },
          );
        });
      }),
    );
  }
}
