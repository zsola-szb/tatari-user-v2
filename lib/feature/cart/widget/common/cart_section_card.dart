import 'package:tatarigigs_user/util/core_export.dart';

class CartSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const CartSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimensions.padding16),
    this.radius = Dimensions.radius16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
