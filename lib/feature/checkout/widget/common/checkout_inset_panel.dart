import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutInsetPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CheckoutInsetPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimensions.padding10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: child,
    );
  }
}
