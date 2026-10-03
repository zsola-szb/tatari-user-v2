import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool isLargeTitle;

  const CheckoutSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.isLargeTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? supporting = subtitle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                style: isLargeTitle
                    ? context.heading.large : context.heading.defaultSize,
              ),
              if (supporting != null && supporting.isNotEmpty) ...<Widget>[
                const SizedBox(height: Dimensions.padding4),
                Text(supporting, style: context.body.defaultSize),
              ],
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: Dimensions.padding16),
          trailing!,
        ],
      ],
    );
  }
}
