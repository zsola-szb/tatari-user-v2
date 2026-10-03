import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const CheckoutShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.radius = Dimensions.radius6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class CheckoutShimmerCard extends StatelessWidget {
  final double height;

  const CheckoutShimmerCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return CheckoutShimmerBox(height: height, radius: Dimensions.radius16);
  }
}
