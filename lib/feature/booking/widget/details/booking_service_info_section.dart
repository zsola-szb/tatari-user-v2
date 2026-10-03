import 'package:tatarigigs_user/feature/booking/widget/common/booking_expandable_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingServiceInfoSection extends StatelessWidget {
  final List<BookingServiceItemModel> services;
  final BookingDetailsController controller;

  const BookingServiceInfoSection({super.key, required this.services, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return BookingExpandableSection(
      title: '${'service_info'.tr} (${services.length})',
      child: Column(
        children: List<Widget>.generate(services.length * 2 - 1, (int index) {
          if (index.isOdd) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
              child: Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
            );
          }
          return _ServiceTile(service: services[index ~/ 2], controller: controller);
        }),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final BookingServiceItemModel service;
  final BookingDetailsController controller;

  const _ServiceTile({required this.service, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius6),
              child: CustomImage(
                image: service.thumbnailFullPath ?? '',
                height: 44,
                width: 44,
                fit: BoxFit.cover,
                placeholder: Images.placeholder,
              ),
            ),
            const SizedBox(width: Dimensions.padding10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    service.name,
                    style: context.heading.defaultSize.medium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.padding4),
                  Row(
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          PriceConverter.convertPrice(
                            controller.hasDiscount(service)
                                ? controller.discountedLineTotalOf(service) : controller.lineTotalOf(service),
                            isShowLongPrice: true,
                          ),
                          style: context.heading.defaultSize,
                        ),
                      ),
                      if (controller.hasDiscount(service)) ...<Widget>[
                        const SizedBox(width: Dimensions.padding6),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            PriceConverter.convertPrice(
                              controller.lineTotalOf(service),
                              isShowLongPrice: true,
                            ),
                            style: context.body.small.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: context.customThemeColors.secondaryTextColor,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.padding8),
            _QuantityChip(quantity: controller.totalQuantityOf(service)),
          ],
        ),
        if (controller.hasVariations(service)) ...<Widget>[
          const SizedBox(height: Dimensions.padding10),
          BookingInlineDisclosure(
            title: '${'view_variations'.tr} (${controller.variationCountOf(service)})',
            child: Column(
              children: service.variations
                  .map((BookingServiceVariation variation) => _VariationRow(variation: variation)).toList(growable: false),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuantityChip extends StatelessWidget {
  final int quantity;

  const _QuantityChip({required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding8,
        vertical: Dimensions.padding2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Text('${'qty'.tr} : $quantity', style: context.subHeading.small.medium),
    );
  }
}

class _VariationRow extends StatelessWidget {
  final BookingServiceVariation variation;

  const _VariationRow({required this.variation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding4),
      child: Row(
        children: <Widget>[
          Text('${variation.quantity}x', style: context.subHeading.small),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: Text(
              variation.label,
              style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (variation.hasDiscount) ...<Widget>[
            const SizedBox(width: Dimensions.padding6),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                PriceConverter.convertPrice(variation.lineTotal, isShowLongPrice: true),
                style: context.body.extraSmall.copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: context.customThemeColors.secondaryTextColor,
                ),
              ),
            ),
          ],
          const SizedBox(width: Dimensions.padding8),

          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              PriceConverter.convertPrice(
                variation.hasDiscount ? variation.discountedLineTotal : variation.lineTotal,
                isShowLongPrice: true,
              ),
              style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
