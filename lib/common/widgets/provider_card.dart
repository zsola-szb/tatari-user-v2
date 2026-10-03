import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProviderCard extends StatelessWidget {
  final String? coverImage;
  final String? providerImage;
  final int? discountPercent;
  final String companyName;
  final bool isVerified;
  final List<String> serviceTypeTags;
  final double avgRating;
  final int ratingCount;
  final double? distanceKm;
  final int? totalServiceServed;
  final bool isAvailable;
  final bool isAd;
  final bool isFavorite;
  final String? providerId;
  final VoidCallback? onTap;
  final bool showFavoriteRemoveDialog;

  const ProviderCard({
    super.key,
    this.coverImage,
    this.providerImage,
    this.discountPercent,
    required this.companyName,
    this.isVerified = false,
    this.serviceTypeTags = const [],
    required this.avgRating,
    required this.ratingCount,
    this.distanceKm,
    this.totalServiceServed,
    this.isAvailable = false,
    this.isAd = false,
    this.isFavorite = false,
    this.providerId,
    this.onTap,
    this.showFavoriteRemoveDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12)
        ),
        padding: EdgeInsets.all(Dimensions.padding4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              child: CustomImage(image: coverImage, placeholder: Images.userPlaceHolder, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),

            if(discountPercent != null && discountPercent! > 0) Positioned(
              top: Dimensions.padding10, left: Dimensions.padding10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                  border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2), width: 1),
                ),
                child: Text('-$discountPercent%', style: subHeading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.error, fontWeight: AppWeight.strong)),
              ),
            ),

            Positioned(
              top: Dimensions.padding10, right: Dimensions.padding10,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                child: FavoriteIconWidget(
                  value: isFavorite ? 1 : 0,
                  providerId: providerId,
                  isTap: providerId != null,
                  showDialog: showFavoriteRemoveDialog,
                  size: 32,
                  iconSize: 18,
                ),
              ),
            ),

            if(isAvailable) Positioned(
              bottom: Dimensions.padding10, left: Dimensions.padding10,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEBFFEE),
                  border: Border.all(color: context.customThemeColors.success.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding6),
                child: Text('available'.tr,
                    style: context.subHeading.small.overrideWith(color: context.customThemeColors.success, fontWeight: AppWeight.regular)),
              ),
            ),

            if(isAd) Positioned(
              bottom: Dimensions.padding10, right: Dimensions.padding10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding6),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(Dimensions.radiusFull)),
                child: Text('ad_label'.tr, style: subHeading.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.medium)),
              ),
            ),
          ]),

          const SizedBox(height: Dimensions.padding10),

          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
             Padding(
              padding: const EdgeInsetsDirectional.only(end: Dimensions.padding6),
              child: ProviderVerifiedAvatar(imageUrl: providerImage, isVerified: isVerified, size: 20),
            ),

            Expanded(
              child: Text(companyName, style: context.heading.large, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: Dimensions.padding6),

            Directionality(textDirection: TextDirection.ltr, child: Row(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(Images.starIcon, height: 14, width: 14),
              const SizedBox(width: Dimensions.padding4),

              Text(avgRating.toStringAsFixed(1), style: context.subHeading.small),
              const SizedBox(width: Dimensions.padding4),

              Text('($ratingCount)', style: context.body.small),
            ])),
          ]),

          if(serviceTypeTags.isNotEmpty) ...[
            const SizedBox(height: Dimensions.padding6),
            Text(serviceTypeTags.join(', '),
              style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,),
          ],

          const SizedBox(height: Dimensions.padding10),

          Row(children: [
            if(distanceKm != null) ...[
              SvgPicture.asset(Images.locationMarker, width: 14, height: 14, colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn)),
              const SizedBox(width: Dimensions.padding6),
              Text.rich(TextSpan(children: [
                TextSpan(text: distanceKm!.toStringAsFixed(1), style: context.body.small.overrideWith(fontWeight: AppWeight.medium)),
                TextSpan(text: ' ${'km_away_from_you'.tr}',
                    style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor ,fontWeight: AppWeight.regular)),
              ])),
            ],

            if(distanceKm != null && totalServiceServed != null)
              const SizedBox(width: Dimensions.padding16),

            if(totalServiceServed != null) ...[
              SvgPicture.asset(Images.serviceFilledIcon, width: 14, height: 14, colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn),),
              const SizedBox(width: Dimensions.padding6),
              Text.rich(TextSpan(children: [
                TextSpan(text: '$totalServiceServed', style: context.body.small.overrideWith(fontWeight: AppWeight.medium)),
                TextSpan(text: ' ${'services_completed'.tr}',
                    style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor ,fontWeight: AppWeight.regular)),
              ])),
            ],
          ]),

        ]),
      ),
    );
  }
}
