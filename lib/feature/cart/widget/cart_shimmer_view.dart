import 'package:tatarigigs_user/util/core_export.dart';

class CartShimmerView extends StatelessWidget {
  const CartShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Shimmer(
            duration: const Duration(seconds: 2),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Column(
                    children: const <Widget>[
                      CartShimmerBox(height: 84, radius: Dimensions.radius16),
                      SizedBox(height: Dimensions.padding16),
                      CartShimmerBox(height: 260, radius: Dimensions.radius16),
                      SizedBox(height: Dimensions.padding16),
                      CartShimmerBox(height: 60, radius: Dimensions.radius16),
                      SizedBox(height: Dimensions.padding16),
                      CartShimmerBox(height: 280, radius: Dimensions.radius16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const _ShimmerBottomBar(),
      ],
    );
  }
}

class CartShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const CartShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.radius = Dimensions.radius8,
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

class _ShimmerBottomBar extends StatelessWidget {
  const _ShimmerBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding12,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CartShimmerBox(height: 16, width: 120),
              CartShimmerBox(height: 16, width: 90),
            ],
          ),
          const SizedBox(height: Dimensions.padding10),
          const CartShimmerBox(height: 50, radius: Dimensions.radius12),
        ],
      ),
    );
  }
}
