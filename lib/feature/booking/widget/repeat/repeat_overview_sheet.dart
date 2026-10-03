import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_inset_panel.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatOverviewSheet extends StatelessWidget {
  final BookingDetailModel booking;

  const RepeatOverviewSheet({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final BookingRepeatSchedule schedule = booking.repeat;
    final List<DateTime> occurrences = schedule.occurrences;
    const String countToken = '@count';
    final String countTemplate = 'you_will_receive_service_times'.tr;
    final int countIndex = countTemplate.indexOf(countToken);
    final String countPrefix = countIndex < 0 ? '$countTemplate ' : countTemplate.substring(0, countIndex);
    final String countSuffix = countIndex < 0 ? '' : countTemplate.substring(countIndex + countToken.length);

    return BaseBottomSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding16 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text('repeat_booking_overview'.tr, style: context.heading.extraLarge),
            ),
            const SizedBox(height: Dimensions.padding6),
            Center(
              child: Text(
                'this_booking_will_be_continued'.tr,
                style: context.body.small,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.padding20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.padding12,
                vertical: Dimensions.padding16,
              ),
              decoration: BoxDecoration(
                color: context.customThemeColors.backGroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (schedule.hasDateRange) ...<Widget>[
                    Text.rich(
                      TextSpan(
                        style: context.body.defaultSize,
                        children: <InlineSpan>[
                          TextSpan(text: '${'from'.tr} '),
                          TextSpan(
                            text: DateConverter.dateStringMonthYear(schedule.startDate),
                            style: context.heading.defaultSize.overrideWith(fontWeight: AppWeight.medium),
                          ),
                          TextSpan(text: ' ${'to'.tr} '),
                          TextSpan(
                            text: DateConverter.dateStringMonthYear(schedule.endDate),
                            style: context.heading.defaultSize.overrideWith(fontWeight: AppWeight.medium),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.padding8),
                  ],
                  Text.rich(
                    TextSpan(
                      style: context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor),
                      children: <InlineSpan>[
                        TextSpan(text: countPrefix, style: context.heading.defaultSize.
                        overrideWith(color: context.customThemeColors.secondaryTextColor, fontWeight: AppWeight.medium)),
                        TextSpan(
                          text: '${schedule.totalCount}$countSuffix',
                          style: context.subHeading.defaultSize.strong,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (schedule.isWeekly && schedule.weekNames.isNotEmpty) ...<Widget>[
              const SizedBox(height: Dimensions.padding12),
              Wrap(
                spacing: Dimensions.padding8,
                runSpacing: Dimensions.padding6,
                children: schedule.weekNames
                    .map((String day) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.padding10,
                            vertical: Dimensions.padding4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(Dimensions.radius6),
                          ),
                          child: Text(day.toLowerCase().tr, style: context.body.small),
                        )).toList(growable: false),
              ),
            ],
            const SizedBox(height: Dimensions.padding24),
            Text(
              '${'scheduled_list'.tr} (${occurrences.length})',
              style: context.heading.large,
            ),
            const SizedBox(height: Dimensions.padding4),
            Text(
              'you_will_receive_your_service_in_the_days_bellow'.tr,
              style: context.body.small,
            ),
            const SizedBox(height: Dimensions.padding12),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.35),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: occurrences.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: Dimensions.padding8),
                itemBuilder: (BuildContext context, int index) => BookingInsetPanel(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today_outlined,
                          size: 15, color: context.customThemeColors.secondaryTextColor),
                      const SizedBox(width: Dimensions.padding8),
                      Expanded(
                        child: Text(
                          DateConverter.dateStringMonthYear(occurrences[index]),
                          style: context.heading.small.overrideWith(fontWeight: AppWeight.medium),
                        ),
                      ),
                      Icon(Icons.access_time_rounded,
                          size: 15, color: context.customThemeColors.secondaryTextColor),
                      const SizedBox(width: Dimensions.padding4),
                      Text(
                        DateConverter.convertDateTimeToTime(occurrences[index]),
                        style: context.heading.small.overrideWith(fontWeight: AppWeight.medium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
