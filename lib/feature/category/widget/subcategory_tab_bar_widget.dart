import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryTabBarWidget extends StatelessWidget {
  final List<CategoryModel>? subCategories;
  final TabController? controller;
  final ValueChanged<int> onTabTap;

  const SubCategoryTabBarWidget({super.key, required this.subCategories, required this.controller, required this.onTabTap});

  @override
  Widget build(BuildContext context) {
    if(subCategories == null){
      return SizedBox(
        height: 35,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Row(children: List.generate(4, (index) => Padding(
            padding: const EdgeInsetsDirectional.only(end: Dimensions.padding24),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                height: 10, width: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius6),
                ),
              ),
            ),
          ))),
        ),
      );
    }

    if(subCategories!.isEmpty || controller == null){
      return const SizedBox();
    }

    return TabBar(
      controller: controller,
      isScrollable: true,
      indicator: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2))),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Theme.of(context).hintColor,
      labelStyle: heading.large.strong,
      unselectedLabelStyle: heading.large.strong,
      onTap: onTabTap,
      tabs: subCategories!.map((subCategory) => Tab(height: 35, text: subCategory.name ?? '')).toList(),
    );
  }
}
