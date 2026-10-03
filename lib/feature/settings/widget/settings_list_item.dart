import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final Function()? onTap;

  const SettingsListItem({super.key, required this.icon, required this.title, required this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
          child: Row(children: [
            Icon(icon, size: 18, color: context.customThemeColors.secondaryTextColor),
            const SizedBox(width: Dimensions.padding16),

            Expanded(child: Text(title, style: context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor))),
            const SizedBox(width: Dimensions.padding12),

            trailing,
          ]),
        ),
      ),
    );
  }
}
