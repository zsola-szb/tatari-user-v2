import 'dart:math' as math;
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceWidgetVertical extends StatelessWidget {
  final Service service;
  final String fromType;
  final String fromPage;
  final ProviderData? providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final bool showProviderName;

  const ServiceWidgetVertical({
    super.key, required this.service, required this.fromType,
    this.fromPage ="", this.providerData, this.signInShakeKey,
    this.showProviderName = true,
  }) ;

  static const double _ratingIconSize = 14;
  static const int _nameMaxLines = 2;

  static double _lineHeightOf(BuildContext context, TextStyle style) =>
      MediaQuery.textScalerOf(context).scale(style.fontSize ?? 0) * (style.height ?? 1);

  static double heightFor(BuildContext context, double width, {bool showProviderName = true}) {
    double lineOf(TextStyle style) => _lineHeightOf(context, style);

    return width + Dimensions.padding10
        + (showProviderName ? ServiceProviderNameWithAvatar.heightFor(context) : 0)
        + (lineOf(context.heading.large) * _nameMaxLines)
        + Dimensions.padding4 + math.max(lineOf(context.subHeading.defaultSize), _ratingIconSize)
        + Dimensions.padding4 + lineOf(context.heading.large);
  }

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice = false;
    showDiscountedPrice = ((service.lowestPrice ?? 0) > (service.discountedLowestPrice ?? 0));

    return OnHover(
      isItem: true,
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          onTap: () {
            if(fromPage=="search_page"){
              Get.toNamed(RouteHelper.getServiceRoute(service.slug!,fromPage:"search_page"),);
            }else{
              Get.toNamed(RouteHelper.getServiceRoute(service.slug!),);
            }
          },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Flexible(
              child: LayoutBuilder(builder: (context, constraints) {
                final double imageSize = math.min(constraints.maxWidth, constraints.maxHeight);

                return SizedBox(
                  width: imageSize, height: imageSize,
                  child: Stack(children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        child: CustomImage(
                          image: '${service.thumbnailFullPath}',
                          fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                        ),
                      ),
                    ),

                    if(showDiscountedPrice)
                      Positioned(
                        top: Dimensions.padding8, left: Dimensions.padding8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE9E7),
                            borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                            border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
                          ),
                          child: Text(service.maximumDiscount ?? '0', style: context.subHeading.small.overrideWith(color: Theme.of(context).colorScheme.error, fontWeight: AppWeight.medium)),
                        ),
                      ),

                    Positioned(
                      top: Dimensions.padding8, right: Dimensions.padding8,
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                        child: FavoriteIconWidget(
                          value: service.isFavorite,
                          serviceId: service.id!,
                          signInShakeKey: signInShakeKey,
                          size: 32, iconSize: 15,
                        ),
                      ),
                    ),

                    if(fromType != 'fromCampaign')
                      Positioned(
                        bottom: Dimensions.padding8, right: Dimensions.padding8,
                        child: ServiceCartStepper(
                          service: service,
                          providerData: providerData,
                        ),
                      ),
                  ]),
                );
              }),
            ),

            const SizedBox(height: Dimensions.padding10),

            if(showProviderName)
              ServiceProviderNameWithAvatar(
                providerName: service.providerName,
                providerImage: service.providerImage,
              ),

            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _lineHeightOf(context, context.heading.large) * _nameMaxLines,
              ),
              child: Text(
                service.name ?? "",
                style: context.heading.large.overrideWith(fontWeight: AppWeight.medium),
                maxLines: _nameMaxLines, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: Dimensions.padding4),

            Row(children: [
              Image(image: AssetImage(Images.starIcon), height: _ratingIconSize, width: _ratingIconSize),
              Gaps.horizontalGapOf(4),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  service.avgRating?.toStringAsFixed(1) ?? '0.0',
                  style: context.subHeading.defaultSize,
                ),
              ),
              Gaps.horizontalGapOf(4),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Text('(${service.ratingCount})', style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
              ),
            ]),
            const SizedBox(height: Dimensions.padding4),

            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(
                      showDiscountedPrice ? service.discountedLowestPrice ?? 0 : service.lowestPrice ?? 0,
                  ),
                  style: context.heading.large,
                ),
              ),

              if(showDiscountedPrice) ...[
                Gaps.horizontalGapOf(6),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    PriceConverter.convertPrice(service.lowestPrice),
                    style: context.subHeading.small.copyWith(color: context.customThemeColors.secondaryTextColor ,decoration: TextDecoration.lineThrough, fontWeight: AppWeight.regular),
                  ),
                ),
              ],
            ]),
          ]),
        );
      }),
    );
  }
}
