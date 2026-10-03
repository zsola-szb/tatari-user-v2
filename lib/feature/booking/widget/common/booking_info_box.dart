import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

enum BookingInfoTone { info, warning, error, success, neutral }

class BookingInfoBox extends StatelessWidget {
  final Widget child;
  final BookingInfoTone tone;
  final EdgeInsetsGeometry padding;

  const BookingInfoBox({
    super.key,
    required this.child,
    this.tone = BookingInfoTone.info,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Dimensions.padding12,
      vertical: Dimensions.padding10,
    ),
  });

  factory BookingInfoBox.text(
    BuildContext context, {
    required String message,
    BookingInfoTone tone = BookingInfoTone.info,
  }) {
    return BookingInfoBox(
      tone: tone,
      child: Text(message, style: context.body.small.overrideWith(color: context.customThemeColors.textColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _fill(context),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: child,
    );
  }

  Color _fill(BuildContext context) {
    switch (tone) {
      case BookingInfoTone.info:
        return context.customThemeColors.info.withValues(alpha: 0.10);
      case BookingInfoTone.warning:
        return context.customThemeColors.warning.withValues(alpha: 0.12);
      case BookingInfoTone.error:
        return context.customThemeColors.error.withValues(alpha: 0.10);
      case BookingInfoTone.success:
        return context.customThemeColors.success.withValues(alpha: 0.10);
      case BookingInfoTone.neutral:
        return Theme.of(context).hintColor.withValues(alpha: 0.10);
    }
  }
}
