import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

enum CheckoutInfoTone { info, accent, error }

class CheckoutInfoBox extends StatelessWidget {
  final Widget child;
  final CheckoutInfoTone tone;
  final EdgeInsetsGeometry padding;

  const CheckoutInfoBox({
    super.key,
    required this.child,
    this.tone = CheckoutInfoTone.info,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Dimensions.padding16,
      vertical: Dimensions.padding10,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _fill(context),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: child,
    );
  }

  Color _fill(BuildContext context) {
    switch (tone) {
      case CheckoutInfoTone.info:
        return context.customThemeColors.warning.withValues(alpha: 0.10);
      case CheckoutInfoTone.accent:
        return Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
      case CheckoutInfoTone.error:
        return context.customThemeColors.error.withValues(alpha: 0.10);
    }
  }
}
