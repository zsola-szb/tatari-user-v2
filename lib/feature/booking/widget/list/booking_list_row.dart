import 'package:tatarigigs_user/feature/booking/widget/common/booking_repeat_badge.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_status_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/booking_rebook_flow.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingListRow extends StatelessWidget {
  final BookingListItemModel booking;
  final int index;

  const BookingListRow({super.key, required this.booking, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openDetails(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    booking.providerDisplayName,
                    style: context.heading.large,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.padding6),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'ID #${booking.readableId}',
                          style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding8),
                      if (booking.isRepeat) ...<Widget>[
                        const BookingRepeatBadge(),
                        const SizedBox(width: Dimensions.padding6),
                      ],
                      BookingStatusWidget(status: booking.rawStatus),
                    ],
                  ),
                  const SizedBox(height: Dimensions.padding12),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('provided_at'.tr, style: context.body.small.overrideWith(fontWeight: AppWeight.regular)),
                            const SizedBox(height: 2),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                booking.serviceAt == null
                                    ? '-' : DateConverter.dateStringMonthYear(booking.serviceAt),
                                style: context.heading.small.medium.overrideWith(color: context.customThemeColors.textColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (booking.serviceCount > 0) ...<Widget>[
                        const SizedBox(width: Dimensions.padding12),
                        AvatarStack(imageUrls: booking.serviceThumbnails),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimensions.padding12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    PriceConverter.convertPrice(booking.totalAmount),
                    style: context.body.overLarge.regular.overrideWith(color: context.customThemeColors.textColor),
                  ),
                ),
                const SizedBox(height: Dimensions.padding20),
                _RowAction(booking: booking, index: index, onDetails: _openDetails),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetails() {
    if (booking.isRepeat) {
      Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId: booking.id));
    } else {
      Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId: booking.id));
    }
  }
}

class _RowAction extends StatelessWidget {
  final BookingListItemModel booking;
  final int index;
  final VoidCallback onDetails;

  const _RowAction({required this.booking, required this.index, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingRebookController>(
      builder: (BookingRebookController rebookController) {
        final bool canRebook = rebookController.canRebook(status: booking.status, kind: booking.kind);
        final bool isBusy =
            canRebook && rebookController.isLoading && rebookController.activeIndex == index;

        return InkWell(
          onTap: isBusy ?
          null : canRebook ?
              () => BookingRebookFlow.start(context, bookingId: booking.id, subCategoryId: booking.subCategoryId, index: index)
              : onDetails,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          child: Container(
            height: 34,
            constraints: const BoxConstraints(minWidth: 86),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(Dimensions.radius8),
            ),
            child: isBusy ?
            const SizedBox(
              height: 16, width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ) :
            Text(canRebook ? 'rebook'.tr : 'details'.tr, style: context.subHeading.small.overrideWith(
              color: Get.isDarkMode ? context.customThemeColors.textColor : Theme.of(context).cardColor,
              fontWeight: AppWeight.medium,
            )),
          ),
        );
      },
    );
  }
}
