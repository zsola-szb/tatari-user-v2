import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingHistoryTimeline extends StatelessWidget {
  final List<BookingTimelineEntry> entries;

  const BookingHistoryTimeline({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return BookingSectionCard(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(Dimensions.radius16),
        topRight: Radius.circular(Dimensions.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('booking_history'.tr, style: context.heading.large),
          const SizedBox(height: Dimensions.padding16),
          ...List<Widget>.generate(
            entries.length,
            (int index) => BookingTimelineTile(
              entry: entries[index],
              isLast: index == entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingTimelineTile extends StatelessWidget {
  final BookingTimelineEntry entry;
  final bool isLast;

  const BookingTimelineTile({super.key, required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
                child: const Icon(Icons.check, size: 13, color: Colors.white),
              ),
              if (!isLast)
                Expanded(child: _DashedConnector(color: accent.withValues(alpha: 0.35))),
            ],
          ),
          const SizedBox(width: Dimensions.padding12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Dimensions.padding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_title(), style: context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor)),
                  if (entry.actorName.isNotEmpty &&
                      entry.kind != BookingTimelineKind.booked) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(entry.actorName, style: context.body.small),
                  ],
                  if (entry.scheduledAt != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        DateConverter.dateMonthYearTime(entry.scheduledAt),
                        style: context.body.small,
                      ),
                    ),
                  ],
                  if (entry.occurredAt != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        DateConverter.dateMonthYearTime(entry.occurredAt),
                        style: context.body.small,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _title() {
    switch (entry.kind) {
      case BookingTimelineKind.booked:
        return '${'service_booked_by_customer'.tr} ${entry.actorName}'.trim();
      case BookingTimelineKind.statusChange:
        return '${'booking'.tr} ${entry.status.labelKey.tr} '
                '${'by'.tr} ${entry.actorType.tr}'
            .trim();
      case BookingTimelineKind.scheduleChange:
        return '${'schedule_changed_by'.tr} ${entry.actorType.tr}'.trim();
    }
  }
}

class _DashedConnector extends StatelessWidget {
  final Color color;

  const _DashedConnector({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(_DashedLinePainter.strokeWidth, double.infinity),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  static const double strokeWidth = 1.5;
  static const double _dashHeight = 3;
  static const double _gapHeight = 3;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double x = size.width / 2;
    for (double y = 0; y < size.height; y += _dashHeight + _gapHeight) {
      final double end = y + _dashHeight;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, end > size.height ? size.height : end),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => oldDelegate.color != color;
}
