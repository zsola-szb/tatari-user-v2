import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceLocationRow extends StatelessWidget {
  static const double _iconCircleSize = 24;

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onEdit;
  final bool forceLtrSubtitle;

  const ServiceLocationRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onEdit,
    this.forceLtrSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget subtitleText = Text(
      subtitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.body.small,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: _iconCircleSize,
          width: _iconCircleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.customThemeColors.secondaryBackGroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 12, color: context.customThemeColors.secondaryTextColor),
        ),
        const SizedBox(width: Dimensions.padding10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: context.heading.defaultSize),
              const SizedBox(height: Dimensions.padding2),
              if (forceLtrSubtitle)
                Directionality(textDirection: TextDirection.ltr, child: subtitleText)
              else
                subtitleText,
            ],
          ),
        ),
        if (onEdit != null) ...<Widget>[
          const SizedBox(width: Dimensions.padding10),
          CheckoutEditIconButton(size: 28, showBackground: false, onTap: onEdit),
        ],
      ],
    );
  }
}
