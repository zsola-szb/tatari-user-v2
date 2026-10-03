import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          border: isSelected ? null : Border.all(color: context.customThemeColors.borderColor, width: 1),
        ),
        child: Text(label,
          maxLines: 1,
          style: heading.large.strong
              .overrideWith(color: isSelected ? Colors.white : context.customThemeColors.secondaryTextColor),
        ),
      ),
    );
  }
}
