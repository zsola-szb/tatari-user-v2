import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchResultTabs extends StatelessWidget {
  const SearchResultTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (AllSearchController searchController){
      return Row(mainAxisSize: MainAxisSize.min, children: [
        for (final SearchResultType tab in SearchResultType.values)
          Padding(
            padding: EdgeInsetsDirectional.only(end: tab == SearchResultType.values.last ? 0 : Dimensions.padding8),
            child: _SearchResultTabItem(
              tab: tab,
              isSelected: searchController.selectedResultTab == tab,
              onTap: () => searchController.selectResultTab(tab),
            ),
          ),
      ]);
    });
  }
}

class _SearchResultTabItem extends StatelessWidget {
  final SearchResultType tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchResultTabItem({required this.tab, required this.isSelected, required this.onTap});

  String get _labelKey {
    switch(tab){
      case SearchResultType.all:
        return 'all';
      case SearchResultType.services:
        return 'services';
      case SearchResultType.providers:
        return 'providers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radiusFull,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withValues(alpha: 0.25),
          ),
        ),
        child: Text(_labelKey.tr,
          style: context.heading.defaultSize.strong.overrideWith(
            color: isSelected ? Theme.of(context).cardColor : context.customThemeColors.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
