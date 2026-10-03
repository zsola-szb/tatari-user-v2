import 'package:tatarigigs_user/util/core_export.dart';

class BookingSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BorderRadiusGeometry? borderRadius;

  const BookingSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimensions.padding16),
    this.radius = 0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
