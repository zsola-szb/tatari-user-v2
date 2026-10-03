import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartExpandableRow extends StatelessWidget {
  static const double _chevronSize = 16;

  final String label;
  final String value;
  final bool isExpanded;
  final bool isExpandable;
  final VoidCallback onToggle;

  const CartExpandableRow({
    super.key,
    required this.label,
    required this.value,
    required this.isExpanded,
    required this.onToggle,
    this.isExpandable = true,
  });

  @override
  Widget build(BuildContext context) {
    final String text = '$label : $value';
    final TextStyle style = context.body.small;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool canToggle = isExpandable && _isOverflowing(
          context: context,
          text: text,
          style: style,
          maxWidth: constraints.maxWidth - _chevronSize - Dimensions.padding6,
        );

        final Text line = Text(
          text,
          maxLines: isExpanded && canToggle ? null : 1,
          overflow: isExpanded && canToggle ? TextOverflow.visible : TextOverflow.ellipsis,
          style: style,
        );

        if (!canToggle) {
          return line;
        }

        return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          onTap: onToggle,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: line),
              const SizedBox(width: Dimensions.padding6),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  Images.chevronDownArrowIcon, width: _chevronSize, height: _chevronSize,
                  colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isOverflowing({required BuildContext context, required String text, required TextStyle style, required double maxWidth}) {
    if (maxWidth <= 0) {
      return false;
    }

    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: DefaultTextStyle.of(context).style.merge(style)),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    final bool didExceedMaxLines = painter.didExceedMaxLines;
    painter.dispose();
    return didExceedMaxLines;
  }
}
