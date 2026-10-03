import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationQuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SetLocationQuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.fontSizeLarge,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: Dimensions.padding8),
            Text(
              label,
              style: context.subHeading.small
                  .overrideWith(color: context.customThemeColors.textColor)
                  .medium,
            ),
          ],
        ),
      ),
    );
  }
}
