import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatViewToggleRow extends StatelessWidget {
  final int bookingCount;
  final bool showSingleBookingView;
  final VoidCallback? onToggle;

  const RepeatViewToggleRow({
    super.key,
    required this.bookingCount,
    required this.showSingleBookingView,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final String leftLabel = showSingleBookingView
        ? 'per_booking'.tr : '${'total_for'.tr} $bookingCount ${'bookings'.tr}';
    final String linkLabel =
        showSingleBookingView ? 'view_total'.tr : 'view_single_booking'.tr;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            leftLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.body.small,
          ),
        ),
        // const SizedBox(width: Dimensions.padding10),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: onToggle,
        //   child: Text(
        //     linkLabel,
        //     style: context.subHeading.small.medium.copyWith(color: Theme.of(context).colorScheme.primary),
        //   ),
        // ),
      ],
    );
  }
}
