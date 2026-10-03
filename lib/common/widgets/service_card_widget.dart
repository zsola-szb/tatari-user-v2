import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceCardWidget extends StatelessWidget {
  final Service service;
  final String fromType;
  final String fromPage;
  final ProviderData? providerData;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;
  final EdgeInsetsGeometry padding;
  final bool showCardColor;
  final bool showProviderName;
  final int nameMaxLines;

  const ServiceCardWidget({
    super.key, required this.service, required this.fromType,
    this.fromPage = "", this.providerData, this.signInShakeKey,
    this.showCardColor = true,
    this.showProviderName = true,
    this.nameMaxLines = 2,
    this.padding = const EdgeInsets.all(Dimensions.padding12)});

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice = false;
    showDiscountedPrice = ((service.discountedLowestPrice ?? 0) < (service.lowestPrice ?? 0));
    return OnHover(
      isItem: true,
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          onTap: () {
            if(fromPage == "search_page"){
              Get.toNamed(RouteHelper.getServiceRoute(service.slug!, fromPage: "search_page"));
            }else{
              Get.toNamed(RouteHelper.getServiceRoute(service.slug!));
            }
          },
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: showCardColor ? Theme.of(context).cardColor : null,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    service.name ?? "",
                    style: context.heading.large.overrideWith(fontWeight: AppWeight.medium),
                    maxLines: nameMaxLines, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.padding4),

                  Row(children: [
                    Image(image: AssetImage(Images.starIcon), height: 14, width: 14),
                    Gaps.horizontalGapOf(4),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        service.avgRating?.toStringAsFixed(1) ?? '0.0',
                        style: context.subHeading.small.overrideWith(fontWeight: AppWeight.regular),
                      ),
                    ),
                    Gaps.horizontalGapOf(4),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text("(${service.ratingCount})",
                          style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor, fontWeight: AppWeight.regular)),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.padding6),

                  Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice(
                          showDiscountedPrice ? service.discountedLowestPrice ?? 0 : service.lowestPrice ?? 0,
                        ),
                        style: context.heading.large.overrideWith(fontWeight: AppWeight.strong),
                      ),
                    ),

                    if(showDiscountedPrice) ...[
                      Gaps.horizontalGapOf(6),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          PriceConverter.convertPrice(service.lowestPrice),
                          style: context.subHeading.small.copyWith(color: context.customThemeColors.secondaryTextColor, fontWeight: AppWeight.regular, decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    ],
                  ]),

                  if (showDiscountedPrice)...[
                    const SizedBox(height: Dimensions.padding8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                        border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
                      ),
                      child: Text(service.maximumDiscount ?? '', style: context.subHeading.small.overrideWith(color: Theme.of(context).colorScheme.error, fontWeight: AppWeight.medium)),
                    ),
                  ],

                  if(showProviderName) ...[
                    const SizedBox(height: Dimensions.padding6),

                    ServiceProviderNameWithAvatar(
                      providerName: service.providerName,
                      providerImage: service.providerImage,
                    ),
                  ],
                ]),
              ),
              const SizedBox(width: Dimensions.padding12),

              SizedBox(
                width: 110, height: 110,
                child: Stack(clipBehavior: Clip.none, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                    child: CustomImage(
                      image: '${service.thumbnailFullPath}',
                      fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                    ),
                  ),

                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                      child: FavoriteIconWidget(
                        value: service.isFavorite,
                        serviceId: service.id!,
                        signInShakeKey: signInShakeKey,
                        size: 28,
                        iconSize: 14,
                      ),
                    ),
                  ),

                  if(fromType != 'fromCampaign')
                    Positioned(
                      bottom: 8, right: 8,
                      child: ServiceCartStepper(
                        service: service,
                        providerData: providerData,
                      ),
                    ),
                ]),
              ),
            ]),
          ),
        );
      }),
    );
  }
}
