import 'package:tatarigigs_user/common/widgets/custom_time_picker.dart';
import 'package:tatarigigs_user/feature/checkout/view/custom_booking_picker_screen.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/repeat_range_info_box.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/repeat_type_option.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/schedule_conflict_banner.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/checkout_schedule_picker_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_inset_panel.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_tap_field.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MultipleBookingTypeSection extends StatelessWidget {
  const MultipleBookingTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return GetBuilder<CheckoutScheduleController>(
          builder: (CheckoutScheduleController schedule) {
            final DateTimeRange? occurrenceRange = schedule.occurrenceRange;
            final String? conflict = controller.scheduleAvailabilityError;

            return CheckoutSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'multiple_booking_type'.tr,
                    style: context.heading.defaultSize,
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        RepeatTypeOption(
                          label: 'daily'.tr,
                          isSelected: schedule.repeatType == RepeatBookingType.daily,
                          onTap: () =>
                              _onTypeChanged(controller, schedule, RepeatBookingType.daily),
                        ),
                        const SizedBox(width: Dimensions.padding16),
                        RepeatTypeOption(
                          label: 'weekly'.tr,
                          isSelected: schedule.repeatType == RepeatBookingType.weekly,
                          onTap: () =>
                              _onTypeChanged(controller, schedule, RepeatBookingType.weekly),
                        ),
                        const SizedBox(width: Dimensions.padding16),
                        RepeatTypeOption(
                          label: 'custom'.tr,
                          isSelected: schedule.repeatType == RepeatBookingType.custom,
                          onTap: () =>
                              _onTypeChanged(controller, schedule, RepeatBookingType.custom),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  _RepeatSchedulePanel(controller: controller, schedule: schedule),

                  if (conflict != null) ...<Widget>[
                    const SizedBox(height: Dimensions.padding10),
                    ScheduleConflictBanner(message: conflict),
                  ],

                  if (occurrenceRange != null) ...<Widget>[
                    const SizedBox(height: Dimensions.padding16),
                    if (schedule.repeatType == RepeatBookingType.weekly)
                      RepeatRangeInfoBox.weekDays(
                        weekDays: schedule.selectedWeekDays,
                        totalOccurrences: schedule.occurrenceCount,
                      )
                    else
                      RepeatRangeInfoBox.dateRange(
                        range: occurrenceRange,
                        totalOccurrences: schedule.occurrenceCount,
                      ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onTypeChanged(
    CheckoutController controller,
    CheckoutScheduleController schedule,
    RepeatBookingType type,
  ) {
    schedule.setRepeatType(type);
    controller.recalculateTotals();
  }
}

class _RepeatSchedulePanel extends StatelessWidget {
  final CheckoutController controller;
  final CheckoutScheduleController schedule;

  const _RepeatSchedulePanel({required this.controller, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final bool isCustom = schedule.repeatType == RepeatBookingType.custom;
    final bool isWeekly = schedule.repeatType == RepeatBookingType.weekly;

    return CheckoutInsetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(isCustom ? 'schedule_service'.tr : 'select_date_and_time'.tr,
                      style: context.heading.defaultSize,
                    ),
                    const SizedBox(height: Dimensions.padding2),
                    Text(
                      'custom_select_time_and_date_hint'.tr,
                      style: context.body.small,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.padding10),
              CheckoutEditIconButton(onTap: () => _openPrimaryPicker(context)),
            ],
          ),
          const SizedBox(height: Dimensions.padding16),
          if (isCustom)
            _CustomOccurrenceList(controller: controller, schedule: schedule)
          else ...<Widget>[
            CheckoutTapField(
              label: isWeekly ? 'select_days'.tr : 'preferable_date'.tr,
              placeholder: isWeekly ? 'select_days'.tr : 'select_date_range'.tr,
              icon: Icons.calendar_month_outlined,
              value: _primaryFieldValue(),
              onTap: () => _openPrimaryPicker(context),
            ),
            const SizedBox(height: Dimensions.padding16),
            CheckoutTapField(
              label: 'arrival_time'.tr,
              // Daily runs at one time across the whole range, so the label says
              // so; weekly repeats per selected day and needs no qualifier.
              labelNote: isWeekly ? null : 'everyday_at'.tr,
              placeholder: 'time_hint'.tr,
              icon: Icons.access_time_rounded,
              value: _arrivalTimeValue(),
              onTap: () => _openPrimaryPicker(context),
            ),
          ],
        ],
      ),
    );
  }

  String? _primaryFieldValue() {
    if (schedule.repeatType == RepeatBookingType.weekly) {
      final List<String> days = schedule.selectedWeekDays;
      return days.isEmpty ? null : days.map((String day) => day.tr).join(', ');
    }
    final DateTimeRange? range = schedule.dailyRange;
    return range == null ? null : DateConverter.convertDateTimeRangeToString(range);
  }

  String? _arrivalTimeValue() {
    final TimeOfDay? time = schedule.repeatType == RepeatBookingType.weekly ? schedule.weeklyTime : schedule.dailyTime;
    if (time == null) {
      return null;
    }
    return DateConverter.convertDateTimeToTime(
      DateTime(DateTime.now().year, 1, 1, time.hour, time.minute),
    );
  }

  /// Both repeating cadences share one sheet; only custom needs its own screen.
  void _openPrimaryPicker(BuildContext context) {
    if (schedule.repeatType == RepeatBookingType.custom) {
      _openCustomPicker(context);
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => CheckoutSchedulePickerSheet(
        mode: schedule.repeatType == RepeatBookingType.weekly
            ? CheckoutSchedulePickerMode.weekly
            : CheckoutSchedulePickerMode.daily,
        initialRange: schedule.repeatType == RepeatBookingType.weekly
            ? schedule.weeklyRange
            : schedule.dailyRange,
        initialTime: schedule.repeatType == RepeatBookingType.weekly
            ? schedule.weeklyTime
            : schedule.dailyTime,
        initialDayFlags: schedule.weeklyDayFlags,
        // Daily offers a way out of repeating altogether, matching the
        // reference: booking once is a click away rather than a tab away.
        onInstantBooking: schedule.repeatType == RepeatBookingType.daily
            ? () {
                schedule.setBookingMode(true);
                controller.recalculateTotals();
              }
            : null,
        onDailySaved: (DateTimeRange range, TimeOfDay time) {
          schedule.setDailySelection(range: range, time: time);
          controller.recalculateTotals();
        },
        onWeeklySaved: (List<bool> dayFlags, DateTimeRange? range, TimeOfDay time) {
          schedule.setWeeklySelection(dayFlags: dayFlags, range: range, time: time);
          controller.recalculateTotals();
        },
      ),
    );
  }

  void _openCustomPicker(BuildContext context) {
    Get.to<void>(
      () => CustomBookingPickerScreen(
        initialOccurrences: schedule.customOccurrences,
        onConfirmed: (List<DateTime> occurrences) {
          schedule.setCustomOccurrences(occurrences);
          controller.recalculateTotals();
        },
      ),
    );
  }

}

class _CustomOccurrenceList extends StatefulWidget {
  final CheckoutController controller;
  final CheckoutScheduleController schedule;

  const _CustomOccurrenceList({required this.controller, required this.schedule});

  @override
  State<_CustomOccurrenceList> createState() => _CustomOccurrenceListState();
}

class _CustomOccurrenceListState extends State<_CustomOccurrenceList> {
  static const Duration _expandDuration = Duration(milliseconds: 200);

  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final List<DateTime> occurrences = widget.schedule.customOccurrences;

    if (occurrences.isEmpty) {
      return Text('no_schedule_date_picked'.tr, style: context.body.small.overrideWith(color: context.customThemeColors.textColor));
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: AnimatedSize(
        duration: _expandDuration,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('${'selected_days_and_time'.tr} (${occurrences.length})',
                      style: context.heading.small,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: _expandDuration,
                    child: SvgPicture.asset(
                      Images.chevronDownArrowIcon, width: 16, height: 16,
                      colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...<Widget>[
              const SizedBox(height: Dimensions.padding10),
              ...List<Widget>.generate(
                occurrences.length,
                (int index) => Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.padding6),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          DateConverter.dateStringMonthYear(occurrences[index]),
                          style: context.subHeading.small,
                        ),
                      ),
                      Text(
                        DateConverter.convertDateTimeToTime(occurrences[index]),
                        style: context.subHeading.small,
                      ),
                      const SizedBox(width: Dimensions.padding10),
                      _OccurrenceIconButton(
                        asset: Images.editIcon,
                        onTap: () => _editOccurrenceTime(context, index),
                      ),
                      const SizedBox(width: Dimensions.padding4),
                      _OccurrenceIconButton(
                        asset: Images.deleteOutlinedIcon,
                        onTap: () {
                          widget.schedule.removeCustomOccurrence(index);
                          widget.controller.recalculateTotals();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editOccurrenceTime(BuildContext context, int index) async {
    final List<DateTime> occurrences = widget.schedule.customOccurrences;
    if (index < 0 || index >= occurrences.length) {
      return;
    }
    final DateTime occurrence = occurrences[index];
    final TimeOfDay? time = await CustomTimePicker.pick(
      context,
      initialTime: TimeOfDay(hour: occurrence.hour, minute: occurrence.minute),
      selectedDate: occurrence,
    );
    if (time == null) {
      return;
    }
    widget.schedule.updateCustomOccurrenceTime(index, time);
    widget.controller.recalculateTotals();
  }
}

class _OccurrenceIconButton extends StatelessWidget {
  static const double _iconSize = 18;

  final String asset;
  final VoidCallback onTap;

  const _OccurrenceIconButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius20,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding4),
        child: SvgPicture.asset(asset, height: _iconSize, width: _iconSize),
      ),
    );
  }
}
