import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_radio_indicator.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class RepeatTypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const RepeatTypeOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          border: Border.all(
            color: isSelected
                ? context.customThemeColors.textColor : Theme.of(context).hintColor.withValues(alpha: 0.30),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckoutRadioIndicator(isSelected: isSelected),
            const SizedBox(width: Dimensions.padding8),
            Text(
              label,
              style: isSelected ? context.heading.small : context.subHeading.defaultSize,
            ),
          ],
        ),
      ),
    );
  }
}
