import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? valueWidget;
  final VoidCallback? onTap;

  const BookingDetailRow({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.valueWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: context.customThemeColors.secondaryTextColor),
        ),
        const SizedBox(width: Dimensions.padding10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: context.heading.defaultSize),
              if (valueWidget != null) ...<Widget>[
                const SizedBox(height: 2),
                valueWidget!,
              ] else if ((value ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 2),
                Text(value!, style: context.body.small),
              ],
            ],
          ),
        ),
        if (onTap != null) ...<Widget>[
          const SizedBox(width: Dimensions.padding8),
          Icon(Icons.arrow_forward_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
        ],
      ],
    );

    if (onTap == null) {
      return content;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      child: content,
    );
  }
}
