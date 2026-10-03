import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_status_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const double _iconButtonSize = 36;

class NextServiceCard extends StatelessWidget {
  final BookingRepeatChild child;
  final VoidCallback onReturn;

  const NextServiceCard({super.key, required this.child, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      radius: Dimensions.radius16,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('next_service'.tr, style: context.heading.large),
                const SizedBox(height: Dimensions.padding8),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'ID #${child.readableId}',
                        style: context.body.small,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.padding8),
                    BookingStatusWidget(status: child.rawStatus),
                  ],
                ),
                const SizedBox(height: Dimensions.padding6),
                Text(
                  '${'schedule_at'.tr} : ${child.scheduledAt == null ? '-' : DateConverter.dateMonthYearTime(child.scheduledAt)}',
                  style: context.body.small,
                ),
                const SizedBox(height: Dimensions.padding8),
                Row(
                  children: <Widget>[
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice(child.totalAmount),
                        style: context.heading.large,
                      ),
                    ),
                    const SizedBox(width: Dimensions.padding8),
                    _PaymentChip(isPaid: child.isPaid),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding12),
          InkWell(
            onTap: _openChild,
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            child: Container(
              height: _iconButtonSize,
              width: _iconButtonSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radius8),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openChild() async {
    await Get.toNamed<void>(
      RouteHelper.getBookingDetailsRoute(subBookingId: child.id),
    );
    onReturn();
  }
}

class _PaymentChip extends StatelessWidget {
  final bool isPaid;

  const _PaymentChip({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final Color color =
        isPaid ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding8,
        vertical: Dimensions.padding2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius6),
      ),
      child: Text(
        isPaid ? 'paid'.tr : 'unpaid'.tr,
        style: context.subHeading.small.medium.copyWith(color: color),
      ),
    );
  }
}
