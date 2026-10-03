import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingDetailsTabBar extends StatelessWidget {
  final List<String> labelKeys;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const BookingDetailsTabBar({
    super.key,
    required this.labelKeys,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: List<Widget>.generate(
          labelKeys.length,
          (int index) => Expanded(
            child: _TabItem(
              labelKey: labelKeys[index],
              isSelected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.labelKey,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isSelected ? Theme.of(context).colorScheme.primary : context.customThemeColors.secondaryTextColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        child: Text(
          labelKey.tr,
          textAlign: TextAlign.center,
          style: context.heading.defaultSize.overrideWith(color: color, fontWeight: AppWeight.strong),
        ),
      ),
    );
  }
}
