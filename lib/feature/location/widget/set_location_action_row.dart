import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const SetLocationActionRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.showChevron = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.customThemeColors.secondaryTextColor,
              size: Dimensions.fontSizeLarge,
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: context.subHeading.defaultSize.medium),

                  if (subtitle != null) ...[
                    const SizedBox(height: Dimensions.padding4),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.body.small,
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.arrow_forward,
                color: context.customThemeColors.textColor,
              ),
          ],
        ),
      ),
    );
  }
}
