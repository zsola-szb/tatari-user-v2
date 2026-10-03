import 'package:flutter/rendering.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryScreenShimmerWidget extends StatelessWidget {
  const SubCategoryScreenShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(
            children: List.generate(2, (index) => const SubCategorySectionShimmerWidget()),
          ),
        ),
      ),
    );
  }
}

class SubCategorySectionShimmerWidget extends StatelessWidget {
  const SubCategorySectionShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding16, Dimensions.padding16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _HeroCardShimmer(),

        Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Container(
            height: 16, width: 140,
            decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(Dimensions.radius6)),
          ),
        ),
        const SizedBox(height: Dimensions.padding16),

        Column(children: List.generate(3, (index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.padding6),
          child: SizedBox(height: 240, child: ServiceShimmer(isEnabled: true, hasDivider: false)),
        ))),
      ]),
    );
  }
}

class _HeroCardShimmer extends StatelessWidget {
  const _HeroCardShimmer();

  static const double _imageHeight = 220;
  static const double _overlap = 24;
  static const double _ambientHorizontalInset = Dimensions.padding16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final fullBleedWidth = constraints.maxWidth + _ambientHorizontalInset * 2;

      return OverflowBox(
        minWidth: fullBleedWidth,
        maxWidth: fullBleedWidth,
        fit: OverflowBoxFit.deferToChild,
        child: SizedBox(
          width: fullBleedWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(height: _imageHeight, width: fullBleedWidth, color: Theme.of(context).shadowColor),
                ),
                const SizedBox(height: _overlap),

                const Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: _InfoCardShimmer(),
                ),
              ]),

              const Positioned(top: _imageHeight - _overlap, left: 0, right: 0, child: _InfoCardShimmer()),
            ],
          ),
        ),
      );
    });
  }
}

class _InfoCardShimmer extends StatelessWidget {
  const _InfoCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(Dimensions.padding20, Dimensions.padding24, Dimensions.padding20, Dimensions.padding24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(children: [
          Container(
            height: 18, width: 160,
            decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(Dimensions.radius6)),
          ),
          const SizedBox(height: Dimensions.padding8),
          Container(
            height: 12, width: 220,
            decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(Dimensions.radius6)),
          ),
        ]),
      ),
    );
  }
}
