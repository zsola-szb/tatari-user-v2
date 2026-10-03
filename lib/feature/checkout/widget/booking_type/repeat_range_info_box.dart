import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatRangeInfoBox extends StatelessWidget {
  final DateTimeRange? range;
  final List<String> weekDays;
  final int totalOccurrences;

  const RepeatRangeInfoBox.dateRange({
    super.key,
    required DateTimeRange this.range,
    required this.totalOccurrences,
  }) : weekDays = const <String>[];

  const RepeatRangeInfoBox.weekDays({
    super.key,
    required this.weekDays,
    required this.totalOccurrences,
  }) : range = null;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = context.subHeading.small;
    final TextStyle boldStyle = context.heading.small;
    final DateTimeRange? range = this.range;

    return CheckoutInfoBox(
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: <InlineSpan>[
            if (range != null) ...<InlineSpan>[
              TextSpan(text: '${'date_range'.tr}  '),
              TextSpan(text: DateConverter.dateStringMonthYear(range.start), style: boldStyle),
              TextSpan(text: ' ${'to'.tr.toLowerCase()} '),
              TextSpan(text: DateConverter.dateStringMonthYear(range.end), style: boldStyle),
            ] else ...<InlineSpan>[
              TextSpan(text: '${'day_range'.tr}  '),
              TextSpan(
                text: weekDays.map((String day) => day.tr).join(', '),
                style: boldStyle,
              ),
            ],
            TextSpan(text: '. ${'you_will_receive_this_services_total'.tr} '),
            TextSpan(text: '$totalOccurrences ${'times'.tr}', style: boldStyle),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
