import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationSuggestionRow extends StatelessWidget {
  final IconData icon;
  final String? boldPrefix;
  final String text;
  final VoidCallback onTap;

  const SetLocationSuggestionRow({
    super.key,
    required this.icon,
    this.boldPrefix,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.customThemeColors.secondaryBackGroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: Dimensions.fontSizeDefault,
                color: context.customThemeColors.secondaryTextColor,
              ),
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.padding6),
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      if (boldPrefix != null)
                        TextSpan(
                          text: boldPrefix,
                          style: context.heading.small,
                        ),
                      TextSpan(text: text, style: context.body.small),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
