import 'package:flutter/rendering.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryHeroCardWidget extends StatelessWidget {
  final CategoryModel subCategory;
  const SubCategoryHeroCardWidget({super.key, required this.subCategory});

  static const double _imageHeight = 220;
  static const double _overlap = 24;
  static const double _ambientHorizontalInset = Dimensions.padding16;

  @override
  Widget build(BuildContext context) {
    final card = _SubCategoryInfoCard(subCategory: subCategory);

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
                SizedBox(
                  height: _imageHeight,
                  width: fullBleedWidth,
                  child: CustomImage(image: subCategory.imageFullPath ?? '', fit: BoxFit.cover),
                ),
                const SizedBox(height: _overlap),

                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: card,
                ),
              ]),

              Positioned(top: _imageHeight - _overlap, left: 0, right: 0, child: card),
            ],
          ),
        ),
      );
    });
  }
}

class _SubCategoryInfoCard extends StatelessWidget {
  final CategoryModel subCategory;
  const _SubCategoryInfoCard({required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(Dimensions.padding20, Dimensions.padding24, Dimensions.padding20, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      child: Column(children: [
        Text(subCategory.name ?? '', textAlign: TextAlign.center, style: context.heading.large),
        const SizedBox(height: Dimensions.padding8),

        Text(subCategory.description ?? '', textAlign: TextAlign.center, style: context.body.defaultSize),
      ]),
    );
  }
}
