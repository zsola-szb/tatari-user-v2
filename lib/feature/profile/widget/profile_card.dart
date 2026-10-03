import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class ProfileCardItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function()? onTap;
  const ProfileCardItem({super.key, required this.title, required this.leadingIcon, this.onTap}) ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
        child: Row(children: [
          Icon(leadingIcon, size: 20, color: context.customThemeColors.secondaryTextColor),
          const SizedBox(width: Dimensions.padding16),

          Expanded(child: Text(title, style: context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor))),
        ]),
      ),
    );
  }
}
