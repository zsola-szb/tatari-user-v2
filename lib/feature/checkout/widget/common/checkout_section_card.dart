import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool showShadow;

  const CheckoutSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimensions.padding20),
    this.radius = Dimensions.radius16,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow && Theme.of(context).brightness == Brightness.light ? cardShadow : null,
      ),
      child: child,
    );
  }
}
