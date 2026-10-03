import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

const Color _kStarColor = Color(0xFFF5A623);

class ServiceTitlePriceSection extends StatelessWidget {
  final Service service;
  const ServiceTitlePriceSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {

    final String categorySubcategoryName = <String>[
      service.category?.name ?? '', service.subCategory?.name ?? '',
    ].where((String name) => name.isNotEmpty).join(' • ');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customThemeColors.backGroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
      ),
      padding: const EdgeInsets.all(Dimensions.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius12)),
                      border: Border.all(color: context.customThemeColors.borderColor, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius12)),
                      child: CustomImage(
                        image: service.thumbnailFullPath ?? '',
                        height: 80,
                        width: 80,
                        placeholder: Images.placeholder,
                      ),
                    ),
                  ),
                  if((service.lowestPrice ?? 0) > (service.discountedLowestPrice ?? 0))
                    Positioned(
                      top: 5, left: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding4),
                        decoration: BoxDecoration(
                          color: Color(0xFFFEE9E7),
                          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                          border: Border.all(color: Color(0xFFFCB3AD), width: 1.2),
                        ),
                        child: Text(
                          service.maximumDiscount ?? '0',
                          style: context.heading.defaultSize.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    )
                ],
              ),
              Gaps.horizontalGapOf(Dimensions.padding12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.heading.extraLarge.strong,
                    ),
                    if (categorySubcategoryName.isNotEmpty) ...[
                      Gaps.verticalGapOf(Dimensions.padding2),
                      Text(
                        categorySubcategoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.body.small,
                      ),
                    ],
                    Gaps.verticalGapOf(Dimensions.padding6),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.star_rounded, size: 18, color: _kStarColor),
                        Gaps.horizontalGapOf(Dimensions.padding4),

                        Text(service.avgRating?.toStringAsFixed(1) ?? '0.0', style: context.subHeading.defaultSize.medium),
                        Gaps.horizontalGapOf(Dimensions.padding4),

                        Text('(${service.ratingCount ?? 0})', style: context.body.small),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if ((service.shortDescription ?? '').isNotEmpty) ...[
            Gaps.verticalGapOf(Dimensions.padding12),

            Text(service.shortDescription!,
              textAlign: TextAlign.justify,
              style: context.body.defaultSize.regular.overrideWith(color: context.customThemeColors.secondaryTextColor),
            ),
          ],
        ],
      ),
    );
  }
}
