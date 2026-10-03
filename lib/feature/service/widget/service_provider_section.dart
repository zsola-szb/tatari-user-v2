import 'dart:math' as math;
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ServiceProviderSection extends StatelessWidget {
  const ServiceProviderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceDetailsController>(
      builder: (serviceDetailsController) {
        final List<ProviderData> providers = serviceDetailsController.serviceProviders;

        if(providers.isEmpty){
          return const SizedBox.shrink();
        }

        final double cardWidth = ResponsiveHelper.isTab(context) ? 320 : Get.width * 0.82;

        return Container(
          color: context.customThemeColors.backGroundColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Text('${'service_provider'.tr} (${providers.length})', style: context.heading.extraLarge.strong),
              ),
              Gaps.verticalGapOf(Dimensions.padding12),

              SizedBox(
                height: _ServiceProviderCard.heightFor(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  itemCount: providers.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Dimensions.padding12),
                  itemBuilder: (context, index) => SizedBox(
                    width: cardWidth,
                    child: _ServiceProviderCard(provider: providers[index], index: index),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceProviderCard extends StatelessWidget {
  final ProviderData provider;
  final int index;
  const _ServiceProviderCard({required this.provider, required this.index});

  static const double _logoSize = 48;
  static const double _ratingIconSize = 14;
  static const double _favoriteSize = 36;

  /// A horizontal list needs a bounded height, so the card reports the height its own
  /// content needs at the reader's text scale instead of hard-coding one.
  static double heightFor(BuildContext context) {
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    double lineOf(TextStyle style) => textScaler.scale(style.fontSize ?? 0) * (style.height ?? 1);

    final double textBlock = lineOf(context.heading.large)
        + Dimensions.padding6
        + math.max(lineOf(context.subHeading.defaultSize), _ratingIconSize);

    return (Dimensions.padding12 * 2) + math.max(_logoSize, textBlock);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: provider.id == null ? null : () => Get.toNamed(RouteHelper.getProviderDetails(provider.id!)),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding12),
        decoration: BoxDecoration(
          color: context.customThemeColors.secondaryBackGroundColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            child: CustomImage(
              image: provider.logoFullPath,
              placeholder: Images.userPlaceHolder,
              height: _logoSize, width: _logoSize,
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding12),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(
                      provider.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.heading.large.strong,
                    ),
                  ),
                  if(provider.isVerified ?? false) ...[
                    Gaps.horizontalGapOf(Dimensions.padding4),
                    SvgPicture.asset(Images.verifiedProvider, height: 16, width: 16),
                  ],
                ]),
                Gaps.verticalGapOf(Dimensions.padding6),

                Row(children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(Images.starIcon, height: _ratingIconSize, width: _ratingIconSize),
                      Gaps.horizontalGapOf(Dimensions.padding4),

                      Text(provider.rating?.toStringAsFixed(1) ?? '0.0',
                          style: context.heading.defaultSize.medium.overrideWith(color: context.customThemeColors.secondaryTextColor)),
                      Gaps.horizontalGapOf(Dimensions.padding4),

                      Text('(${provider.ratingCount ?? 0})', style: context.body.small.regular),
                    ]),
                  ),
                  Gaps.horizontalGapOf(Dimensions.padding10),

                  Container(width: 1.5, height: 12, color: context.customThemeColors.backGroundColor),
                  Gaps.horizontalGapOf(Dimensions.padding10),

                  Flexible(
                    child: Text(
                      '${provider.totalCompletedServices ?? 0} ${'services'.tr}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.heading.defaultSize.medium.overrideWith(color: context.customThemeColors.secondaryTextColor),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding10),

          DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: context.customThemeColors.backGroundColor),
            child: FavoriteIconWidget(
              value: provider.isFavorite,
              providerId: provider.id,
              index: index,
              size: _favoriteSize,
              iconSize: 18,
            ),
          ),
        ]),
      ),
    );
  }
}