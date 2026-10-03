import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderDetailsShimmer extends StatelessWidget {
  const ProviderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: const Column(
            children: [
              _TopCardShimmer(),
              _CategoryTabBarShimmer(),
              _PopularSectionShimmer(),
              _ServiceListSectionShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;
  const _ShimmerBox({this.width, required this.height, this.radius = Dimensions.radius6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _TopCardShimmer extends StatelessWidget {
  const _TopCardShimmer();

  @override
  Widget build(BuildContext context) {
    final double coverHeight = ProviderDetailsTopCard.coverHeight(context);

    return Shimmer(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(width: double.infinity, height: coverHeight, color: Theme.of(context).shadowColor),

              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(Dimensions.padding16, ProviderDetailsTopCard.cardTopClearance, Dimensions.padding16, Dimensions.padding16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
                ),
                child: Column(
                  children: [
                    const _ShimmerBox(width: 160, height: 20),
                    const SizedBox(height: Dimensions.padding10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _ShimmerBox(width: 70, height: 14),
                        Container(
                          width: 1,
                          height: 16,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding12),
                          color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                        ),
                        const _ShimmerBox(width: 70, height: 14),
                      ],
                    ),
                    const SizedBox(height: Dimensions.padding10),

                    const _ShimmerBox(width: 200, height: 12),
                    const SizedBox(height: Dimensions.padding16),

                    SizedBox(
                      height: 78,
                      child: Row(
                        children: [
                          Expanded(child: _ShimmerBox(height: 78, radius: Dimensions.radius12)),
                          const SizedBox(width: Dimensions.padding12),
                          Expanded(child: _ShimmerBox(height: 78, radius: Dimensions.radius12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding12),

                    IntrinsicHeight(
                      child: Row(
                        children: [
                          const Expanded(child: _ChipPlaceholder()),
                          VerticalDivider(width: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                          const Expanded(child: _ChipPlaceholder()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: coverHeight - ProviderDetailsTopCard.avatarDiameter / 2,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                  child: Container(
                    width: ProviderDetailsTopCard.avatarDiameter,
                    height: ProviderDetailsTopCard.avatarDiameter,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Container(
                    width: 80,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      border: Border.all(color: Theme.of(context).cardColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipPlaceholder extends StatelessWidget {
  const _ChipPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ShimmerBox(width: 20, height: 20, radius: Dimensions.radius4),
          const SizedBox(height: Dimensions.padding6),
          _ShimmerBox(width: Get.width * 0.28, height: 10),
        ],
      ),
    );
  }
}

class _CategoryTabBarShimmer extends StatelessWidget {
  const _CategoryTabBarShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: 45,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(bottom: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.2))),
        ),
        child: const Row(
          children: [
            _ShimmerBox(width: 70, height: 16),
            SizedBox(width: Dimensions.padding24),
            _ShimmerBox(width: 70, height: 16),
            SizedBox(width: Dimensions.padding24),
            _ShimmerBox(width: 70, height: 16),
          ],
        ),
      ),
    );
  }
}

class _PopularSectionShimmer extends StatelessWidget {
  const _PopularSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding20, Dimensions.padding16, Dimensions.padding4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(child: const _ShimmerBox(width: 180, height: 20)),
          const SizedBox(height: Dimensions.padding16),

          SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding12),
              itemBuilder: (context, index) => const SizedBox(width: 160, child: ServiceVerticalCardShimmer()),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceVerticalCardShimmer extends StatelessWidget {
  const ServiceVerticalCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.padding10),
          const _ShimmerBox(height: 14, width: double.infinity),
          const SizedBox(height: Dimensions.padding4),
          const _ShimmerBox(height: 12, width: 80),
          const SizedBox(height: Dimensions.padding4),
          const _ShimmerBox(height: 16, width: 60),
        ],
      ),
    );
  }
}

class _ServiceListSectionShimmer extends StatelessWidget {
  const _ServiceListSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding20, Dimensions.padding16, Dimensions.padding4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(child: const _ShimmerBox(width: 140, height: 20)),
          const SizedBox(height: Dimensions.padding16),

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
            itemBuilder: (context, index) => const ServiceCardShimmer(),
          ),
        ],
      ),
    );
  }
}

class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: Dimensions.padding8),
                _ShimmerBox(height: 16, width: 140),
                SizedBox(height: Dimensions.padding10),
                _ShimmerBox(height: 14, width: 90),
                SizedBox(height: Dimensions.padding10),
                _ShimmerBox(height: 18, width: 70),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding12),
          const _ShimmerBox(width: 110, height: 110, radius: Dimensions.radius16),
        ],
      ),
    );
  }
}
