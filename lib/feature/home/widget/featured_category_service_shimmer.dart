import 'package:tatarigigs_user/util/core_export.dart';

class FeaturedCategoryServiceShimmer extends StatelessWidget {
  const FeaturedCategoryServiceShimmer({super.key});

  static const double cardHeight = 134;

  @override
  Widget build(BuildContext context) {
    final Color barColor = Theme.of(context).shadowColor;

    return Container(
      height: cardHeight,
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              FeaturedCategoryShimmerBar(color: barColor, height: 14, widthFactor: 0.5),
              const SizedBox(height: Dimensions.padding10),
              FeaturedCategoryShimmerBar(color: barColor, height: 14, widthFactor: 0.85),
              const SizedBox(height: Dimensions.padding10),
              FeaturedCategoryShimmerBar(color: barColor, height: 12, widthFactor: 0.35),
              const SizedBox(height: Dimensions.padding10),
              FeaturedCategoryShimmerBar(color: barColor, height: 16, widthFactor: 0.4),
            ]),
          ),
          const SizedBox(width: Dimensions.padding12),

          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
          ),
        ]),
      ),
    );
  }
}

class FeaturedCategoryShimmerBar extends StatelessWidget {
  final Color color;
  final double height;
  final double widthFactor;

  const FeaturedCategoryShimmerBar({super.key, required this.color, required this.height, required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(Dimensions.radius6),
        ),
      ),
    );
  }
}
