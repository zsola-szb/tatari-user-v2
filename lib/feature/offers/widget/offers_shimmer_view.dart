import 'package:tatarigigs_user/util/core_export.dart';

class OffersShimmerView extends StatelessWidget {
  final int itemCount;

  const OffersShimmerView({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimensions.padding16),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: Dimensions.padding20),
        itemBuilder: (BuildContext context, int index) => const OffersShimmerRow(),
      ),
    );
  }
}

class OffersShimmerRow extends StatelessWidget {
  const OffersShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          OffersShimmerBox(height: 16, width: 180),
          SizedBox(height: Dimensions.padding10),
          OffersShimmerBox(height: 12, width: 90),
          SizedBox(height: Dimensions.padding10),
          OffersShimmerBox(height: 14, width: 120),
          SizedBox(height: Dimensions.padding10),
          OffersShimmerBox(height: 20, width: 60, radius: Dimensions.radius20),
        ]),
      ),
      const SizedBox(width: Dimensions.padding12),

      const OffersShimmerBox(height: 110, width: 110, radius: Dimensions.radius12),
    ]);
  }
}

class OffersShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const OffersShimmerBox({super.key, this.height = 12, this.width, this.radius = Dimensions.radius4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}