import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingListTabs extends StatelessWidget {
  const BookingListTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingListController>(
      builder: (BookingListController controller) {
        return Container(
          color: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Row(
              children: BookingListTab.values
                  .map((BookingListTab tab) => _TabItem(
                        tab: tab,
                        isSelected: controller.selectedTab == tab,
                        count: controller.countFor(tab),
                        showCount: controller.hasStatusCounts,
                        onTap: () => controller.selectTab(tab),
                      )).toList(growable: false),
            ),
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final BookingListTab tab;
  final bool isSelected;
  final int count;
  final bool showCount;
  final VoidCallback onTap;

  const _TabItem({
    required this.tab,
    required this.isSelected,
    required this.count,
    required this.showCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isSelected ? Theme.of(context).colorScheme.primary : context.customThemeColors.secondaryTextColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding12,
          vertical: Dimensions.padding12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          showCount ? '${tab.labelKey.tr} ($count)' : tab.labelKey.tr,
          style: isSelected
              ? context.heading.defaultSize.overrideWith(color: color, fontWeight: AppWeight.strong)
              : context.heading.defaultSize.overrideWith(color: color, fontWeight: AppWeight.strong),
        ),
      ),
    );
  }
}

class BookingListFilterMenu extends StatelessWidget {
  const BookingListFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingListController>(
      builder: (BookingListController controller) {
        return PopupMenuButton<ServiceType>(
          position: PopupMenuPosition.under,
          elevation: 8,
          color: Theme.of(context).cardColor,
          surfaceTintColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
          ),
          onSelected: controller.selectServiceType,
          itemBuilder: (BuildContext context) => ServiceType.values
              .map((ServiceType type) => PopupMenuItem<ServiceType>(
                    value: type,
                    height: 42,
                    child: Text(
                      _labelKeyOf(type).tr,
                      style: controller.serviceType == type
                          ? context.heading.defaultSize.copyWith(
                                color: Theme.of(context).colorScheme.primary) : context.subHeading.defaultSize,
                    ))).toList(growable: false),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: <Widget>[
                Icon(Icons.filter_list_rounded, color: context.customThemeColors.textColor),
                if (controller.isFiltered)
                  Positioned(
                    right: -2,
                    top: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _labelKeyOf(ServiceType type) {
    switch (type) {
      case ServiceType.regular:
        return 'regular_booking';
      case ServiceType.repeat:
        return 'repeat_booking';
      case ServiceType.all:
        return 'all_booking';
    }
  }
}
