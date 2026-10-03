import 'package:tatarigigs_user/feature/booking/widget/common/booking_copy_id_row.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingSummaryCard extends StatelessWidget {
  final BookingDetailModel booking;
  final bool isCompact;
  final VoidCallback? onSeeMore;

  const BookingSummaryCard({super.key, required this.booking, this.isCompact = false, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (BookingDetailsController controller) {
        return BookingSectionCard(
          radius: Dimensions.radius16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BookingCopyIdRow(
                readableId: booking.readableId,
                status: booking.rawStatus,
                showRepeatGlyph: booking.kind.isRepeat,
                onCopy: controller.copyBookingId,
              ),
              const SizedBox(height: Dimensions.padding10),
              Text(
                '${'booking_placed'.tr} : ${_placedAt()}',
                style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
              ),
              const SizedBox(height: Dimensions.padding4),
              Text(_bookingTypeSentence(controller), style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
              if (booking.kind.isRepeatParent) ...<Widget>[
                const SizedBox(height: Dimensions.padding4),
                Text(_repeatProgressSentence(), style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
              ],
              const SizedBox(height: Dimensions.padding10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(booking.billing.grandTotal, isShowLongPrice: true),
                  style: context.heading.overLarge,
                ),
              ),
              if (!isCompact) ...<Widget>[
                const SizedBox(height: Dimensions.padding6),
                InkWell(
                  onTap: onSeeMore,
                  child: Text(
                    'see_more'.tr,
                    style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _placedAt() {
    final DateTime? placedAt = booking.placedAt;
    return placedAt == null ? '-' : DateConverter.dateMonthYearTime(placedAt);
  }

  String _bookingTypeSentence(BookingDetailsController controller) {
    final String kindKey = booking.kind.isRepeat
        ? 'repeat_booking' : booking.kind.isCustomize ? 'customize_booking' : 'regular_booking';

    return 'booking_type_sentence'.trParams(<String, String>{
      'type': kindKey.tr,
      'detail': controller.bookingTypeDetailKey.tr,
      'payment': booking.payment.methodLabelKey.tr,
    });
  }

  String _repeatProgressSentence() {
    return 'repeat_progress_sentence'.trParams(<String, String>{
      'total': '${booking.repeat.totalCount}',
      'completed': '${booking.repeat.completedCount}',
    });
  }
}
