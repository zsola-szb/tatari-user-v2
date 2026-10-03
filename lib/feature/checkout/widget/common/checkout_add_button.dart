import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutAddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const CheckoutAddButton({
    super.key,
    required this.label,
    this.icon = Icons.add_circle_outline_rounded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 14, color: context.customThemeColors.textColor),
            const SizedBox(width: Dimensions.padding10),
            Text(label, style: context.heading.defaultSize),
          ],
        ),
      ),
    );
  }
}
