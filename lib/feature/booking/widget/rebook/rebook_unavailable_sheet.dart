import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const double _iconButtonSize = 36;

class RebookUnavailableSheet extends StatelessWidget {
  final String bookingId;

  const RebookUnavailableSheet({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<BookingRebookController>(
        builder: (BookingRebookController controller) {
          final BookingAvailabilityModel availability = controller.availability;
          final bool priceChanged = controller.hasPriceChange;
          final bool unavailable = controller.hasUnavailableService;
          final bool allGone = controller.isEverythingUnavailable;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: Dimensions.padding10),
                Image.asset(Images.serviceNotAvailable, width: 56, height: 56),
                const SizedBox(height: Dimensions.padding20),
                Text(
                  _titleKey(priceChanged: priceChanged, unavailable: unavailable).tr,
                  style: context.heading.extraLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.35),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: availability.services.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: Dimensions.padding12),
                    itemBuilder: (BuildContext context, int index) => _ServiceRow(
                      position: index + 1,
                      service: availability.services[index],
                      showPrices: priceChanged,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.padding20),
                Text(
                  _messageKey(
                    priceChanged: priceChanged,
                    unavailable: unavailable,
                    allGone: allGone,
                  ).tr,
                  style: context.body.small,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding24),
                Row(
                  children: <Widget>[
                    if (!allGone) ...<Widget>[
                      Expanded(
                        child: CustomButton(
                          buttonText: 'cancel'.tr,
                          backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.65),
                          radius: Dimensions.radius8,
                          onPressed: () {
                            controller.setActiveIndex(-1);
                            Get.back<void>();
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding12),
                    ],
                    Expanded(
                      child: CustomButton(
                        buttonText: allGone ? 'ok'.tr : 'yes_continue'.tr,
                        radius: Dimensions.radius8,
                        isLoading: controller.isLoading,
                        onPressed: () async {
                          if (allGone) {
                            controller.setActiveIndex(-1);
                            Get.back<void>();
                            return;
                          }
                          Get.back<void>();
                          await controller.addToCart(bookingId: bookingId);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.padding20),
              ],
            ),
          );
        },
      ),
    );
  }

  String _titleKey({required bool priceChanged, required bool unavailable}) {
    if (priceChanged && unavailable) {
      return 'please_review_the_changes';
    }
    return priceChanged ? 'some_services_price' : 'some_services_are_not';
  }

  String _messageKey({
    required bool priceChanged,
    required bool unavailable,
    required bool allGone,
  }) {
    if (priceChanged && unavailable) {
      return 'since_you_have_last_ordered';
    }
    if (priceChanged) {
      return 'services_price_has_been_updates';
    }
    return allGone ? 'all_services_from_this_booking' : 'some_services_has_been_changed';
  }
}

class _ServiceRow extends StatelessWidget {
  final int position;
  final RebookServiceAvailability service;
  final bool showPrices;

  const _ServiceRow({
    required this.position,
    required this.service,
    required this.showPrices,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGone = !service.isAvailable;
    final Color accent =
        isGone ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;

    final Widget name = Text(
      service.displayName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isGone
          ? context.body.defaultSize.copyWith(decoration: TextDecoration.lineThrough,
                decorationColor: context.customThemeColors.secondaryTextColor)
          : context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: showPrices ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent),
            color: isGone ? accent.withValues(alpha: 0.10) : Colors.transparent,
          ),
          child: isGone ? Icon(Icons.close_rounded, size: 10, color: accent)
              : Text('$position', style: context.subHeading.extraSmall.copyWith(color: accent)),
        ),
        const SizedBox(width: Dimensions.padding8),

        showPrices ? Expanded(child: name) : Flexible(child: name),
        if (showPrices && !isGone) ...<Widget>[
          const SizedBox(width: Dimensions.padding10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (service.showPreviousPrice)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    PriceConverter.convertPrice(service.bookedPrice, isShowLongPrice: true),
                    style: context.body.small.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: context.customThemeColors.secondaryTextColor,
                        ),
                  ),
                ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(service.currentPrice, isShowLongPrice: true),
                  style: context.heading.defaultSize.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ],
        if (showPrices && isGone) const SizedBox(width: _iconButtonSize),
      ],
    );
  }
}
