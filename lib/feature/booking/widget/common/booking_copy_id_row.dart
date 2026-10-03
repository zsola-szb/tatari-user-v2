import 'package:tatarigigs_user/feature/booking/widget/common/booking_repeat_badge.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_status_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingCopyIdRow extends StatelessWidget {
  final String readableId;
  final String status;
  final bool showRepeatGlyph;
  final VoidCallback onCopy;

  const BookingCopyIdRow({
    super.key,
    required this.readableId,
    required this.status,
    required this.onCopy,
    this.showRepeatGlyph = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            'ID #$readableId',
            style: context.heading.large,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: Dimensions.padding6),
        InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(Dimensions.radius4),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: SvgPicture.asset(Images.clipboardCopyIcon, height: 16, width: 16),
          ),
        ),
        const SizedBox(width: Dimensions.padding10),
        if (showRepeatGlyph) ...<Widget>[
          const BookingRepeatBadge(),
          const SizedBox(width: Dimensions.padding6),
        ],
        BookingStatusWidget(status: status),
      ],
    );
  }
}
