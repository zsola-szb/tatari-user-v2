import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationTabToggle extends StatelessWidget {
  final SetLocationTab selectedTab;
  final ValueChanged<SetLocationTab> onChanged;

  const SetLocationTabToggle({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: SetLocationTab.values.map((tab) {
        final bool isSelected = tab == selectedTab;
        return Padding(
          padding: EdgeInsets.only(
            right: tab != SetLocationTab.values.last ? Dimensions.padding10 : 0,
          ),
          child: CustomInkWell(
            radius: Dimensions.radius28,
            onTap: () => onChanged(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.padding20,
                vertical: Dimensions.padding8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : context.customThemeColors.secondaryBackGroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radius28),
              ),
              child: Text(
                (tab == SetLocationTab.recent ? 'recent' : 'saved').tr,
                style: context.body.small.overrideWith(
                  color: isSelected
                      ? Theme.of(context).cardColor
                      : context.customThemeColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
