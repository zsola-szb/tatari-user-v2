import 'package:tatarigigs_user/common/widgets/custom_image.dart';
import 'package:tatarigigs_user/common/widgets/title_widget.dart';
import 'package:tatarigigs_user/feature/booking/controller/booking_rebook_controller.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_easy_rebook_model.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/rebook_icon_button.dart';
import 'package:tatarigigs_user/feature/splash/controller/theme_controller.dart';
import 'package:tatarigigs_user/helper/date_converter.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EasyBookingCardWidget extends StatelessWidget {
  const EasyBookingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingRebookController>(builder: (rebookController) {
      final List<EasyRebookItem> bookings = rebookController.providerRebookableBookings;

      if (bookings.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        color: context.customThemeColors.backGroundColor,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.padding32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: TitleWidget(
              title: 'recent_bookings',
              isShowSeeAllButton: false,
            ),
          ),
          const SizedBox(height: Dimensions.padding8),

          Padding(
            padding: const EdgeInsets.only(left: Dimensions.padding16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(bookings.length, (index) => Padding(
                  padding: EdgeInsets.only(right: index == bookings.length - 1 ? 0 : Dimensions.padding12),
                  child: _RecentBookingCard(booking: bookings[index], index: index),
                )),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.padding32),
        ]),
      );
    });
  }
}

class _RecentBookingCard extends StatelessWidget {
  final EasyRebookItem booking;
  final int index;
  const _RecentBookingCard({required this.booking, required this.index});

  static const double _cardWidth = 250;
  static const double _cardPadding = 12;
  static const double _thumbnailToPriceGap = 8;
  static const double _priceToDateGap = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _cardWidth,
      padding: const EdgeInsets.all(_cardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _OverlappingServiceThumbnails(services: booking.services, totalCount: booking.serviceCount),
        const SizedBox(height: _thumbnailToPriceGap),

        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(PriceConverter.convertPrice(booking.totalAmount), style: context.heading.extraLarge,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: _priceToDateGap),
              Text(
                DateConverter.dateStringMonthYear(booking.placedAt),
                style: context.body.small,
              ),
            ]),
          ),
          const SizedBox(width: Dimensions.padding10),

          RebookIconButton(
            bookingId: booking.id,
            subCategoryId: booking.subCategoryId,
            index: index,
          ),
        ]),
      ]),
    );
  }
}

class _OverlappingServiceThumbnails extends StatelessWidget {
  final List<EasyRebookService> services;
  final int totalCount;
  const _OverlappingServiceThumbnails({required this.services, required this.totalCount});

  static const int _maxVisible = 3;
  static const double _size = 40;
  static const double _overlap = 14;

  @override
  Widget build(BuildContext context) {
    final int visible = services.length.clamp(0, _maxVisible);
    final int extra = totalCount - visible;
    final double width = visible == 0 ? 0 : _size + (visible - 1) * (_size - _overlap);

    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: width, height: _size,
        child: Stack(children: List.generate(visible, (i) => Positioned(
          left: i * (_size - _overlap),
          child: Container(
            width: _size, height: _size,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius8),
              child: CustomImage(
                image: services[i].imageFullPath,
                placeholder: Images.placeholder,
                height: _size, width: _size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )),),
      ),
      if(extra > 0) ...[
        const SizedBox(width: Dimensions.padding8),
        Text('$extra+', style: context.heading.defaultSize),
      ],
    ]);
  }
}
