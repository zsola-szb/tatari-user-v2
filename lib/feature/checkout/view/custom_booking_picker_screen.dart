import 'package:tatarigigs_user/common/widgets/custom_time_picker.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/picker_sheet_header.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomBookingPickerScreen extends StatefulWidget {
  final List<DateTime> initialOccurrences;
  final ValueChanged<List<DateTime>> onConfirmed;

  const CustomBookingPickerScreen({
    super.key,
    required this.onConfirmed,
    this.initialOccurrences = const <DateTime>[],
  });

  @override
  State<CustomBookingPickerScreen> createState() => _CustomBookingPickerScreenState();
}

class _CustomBookingPickerScreenState extends State<CustomBookingPickerScreen> {
  final Map<DateTime, TimeOfDay> _entries = <DateTime, TimeOfDay>{};
  final DateRangePickerController _calendarController = DateRangePickerController();

  static const double _calendarHeight = 320;

  @override
  void initState() {
    super.initState();
    for (final DateTime occurrence in widget.initialOccurrences) {
      _entries[_dateOnly(occurrence)] = TimeOfDay(hour: occurrence.hour, minute: occurrence.minute);
    }
    _calendarController.selectedDates = _sortedDates;
  }

  static DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

  List<DateTime> get _sortedDates => _entries.keys.toList()..sort();

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = _sortedDates;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PickerSheetHeader(
              title: 'select_date_and_time'.tr,
              subtitle: 'choose_your_preferred_date_schedule_and_time'.tr,
              showDivider: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.padding10,
                        vertical: Dimensions.padding6,
                      ),
                      child: SizedBox(
                        height: _calendarHeight,
                        child: SfDateRangePicker(
                          controller: _calendarController,
                          backgroundColor: Theme.of(context).cardColor,
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          selectionColor: Colors.transparent,
                          todayHighlightColor: Colors.transparent,
                          enablePastDates: false,
                          toggleDaySelection: true,
                          showNavigationArrow: true,
                          headerHeight: 50,
                          headerStyle: DateRangePickerHeaderStyle(
                            backgroundColor: Theme.of(context).cardColor,
                            textAlign: TextAlign.center,
                            textStyle: context.heading.defaultSize,
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(
                            viewHeaderHeight: 36,
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              backgroundColor: Theme.of(context).cardColor,
                              textStyle: context.body.small,
                            ),
                          ),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                            disabledDatesTextStyle: context.body.small,
                            textStyle: context.subHeading.small,
                            todayTextStyle: context.subHeading.small,
                          ),
                          cellBuilder: (BuildContext context, DateRangePickerCellDetails details) =>
                              _CalendarDayCell(
                            date: details.date,
                            isSelected: _entries.containsKey(_dateOnly(details.date)),
                            isDisabled:
                                _dateOnly(details.date).isBefore(_dateOnly(DateTime.now())),
                          ),
                          onSelectionChanged: _onCalendarSelectionChanged,
                        ),
                      ),
                    ),

                    if (dates.isNotEmpty) ...<Widget>[
                      const SizedBox(height: Dimensions.padding16),
                      _DayWiseArrivalTimeSection(
                        dates: dates,
                        timeOf: (DateTime date) => _entries[date] ?? TimeOfDay.now(),
                        onTimeChanged: (DateTime date, TimeOfDay time) =>
                            setState(() => _entries[date] = time),
                        onRemove: (DateTime date) => setState(() {
                          _entries.remove(date);
                          _calendarController.selectedDates = _sortedDates;
                        }),
                      ),
                    ],
                    const SizedBox(height: Dimensions.padding24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PickerConfirmBar(
        canConfirm: dates.isNotEmpty,
        onCancel: () => Navigator.of(context).pop(),
        onConfirm: _onConfirm,
      ),
    );
  }

  void _onCalendarSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final dynamic value = args.value;
    if (value is! List) {
      return;
    }
    final Set<DateTime> selected = value.whereType<DateTime>().map(_dateOnly).toSet();

    setState(() {
      _entries.removeWhere((DateTime date, _) => !selected.contains(date));
      for (final DateTime date in selected) {
        _entries.putIfAbsent(date, () => TimeOfDay.now());
      }
    });
  }

  void _onConfirm() {
    final List<DateTime> occurrences = _sortedDates
        .map((DateTime date) => DateConverter.combineDateTimeAndTimeOfDay(
              date: date,
              time: _entries[date] ?? TimeOfDay.now(),
            ))
        .toList();

    final DateTime now = DateConverter.nowWithoutSeconds();
    final List<DateTime> pastOccurrences =
        occurrences.where((DateTime occurrence) => occurrence.isBefore(now)).toList();
    if (pastOccurrences.isNotEmpty) {
      customSnackBar(
        '${DateConverter.dateStringMonthYear(pastOccurrences.first)}: ${'selected_time_cannot_earlier'.tr}',
        type: ToasterMessageType.info,
      );
      return;
    }

    Navigator.of(context).pop();
    widget.onConfirmed(occurrences);
  }
}

class _CalendarDayCell extends StatelessWidget {
  static const double _cellMargin = 3;
  static const double _cellRadius = Dimensions.radius8;

  final DateTime date;
  final bool isSelected;
  final bool isDisabled;

  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    final Color background;
    final Color textColor;
    if (isSelected) {
      background = primary;
      textColor = Colors.white;
    } else if (isDisabled) {
      background = Colors.transparent;
      textColor = context.customThemeColors.secondaryTextColor;
    } else {
      background = Theme.of(context).hintColor.withValues(alpha: 0.10);
      textColor = context.customThemeColors.textColor;
    }

    return Container(
      margin: const EdgeInsets.all(_cellMargin),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(_cellRadius),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text('${date.day}',
          style: isSelected
              ? context.heading.small.copyWith(color: textColor) : context.subHeading.small.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _DayWiseArrivalTimeSection extends StatelessWidget {
  final List<DateTime> dates;
  final TimeOfDay Function(DateTime date) timeOf;
  final void Function(DateTime date, TimeOfDay time) onTimeChanged;
  final ValueChanged<DateTime> onRemove;

  const _DayWiseArrivalTimeSection({
    required this.dates,
    required this.timeOf,
    required this.onTimeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${'scheduled_list'.tr} (${dates.length})', style: context.heading.defaultSize),
          const SizedBox(height: Dimensions.padding2),

          Text('you_will_receive_this_service_on'.tr, style: context.body.small),
          const SizedBox(height: Dimensions.padding10),

          ...dates.map(
            (DateTime date) => Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.padding10),
              child: _DayTimeRow(
                date: date,
                time: timeOf(date),
                onTimeChanged: (TimeOfDay time) => onTimeChanged(date, time),
                onRemove: () => onRemove(date),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTimeRow extends StatelessWidget {
  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final VoidCallback onRemove;

  const _DayTimeRow({
    required this.date,
    required this.time,
    required this.onTimeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding16,
        vertical: Dimensions.padding10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateConverter.dateStringMonthYear(date),
                style: context.subHeading.defaultSize,
              ),
            ],
          ),
          const Spacer(),
          CustomTimePicker(
            time: time,
            isExpandedRow: false,
            selectedDate: date,
            onTimeChanged: onTimeChanged,
          ),
          const SizedBox(width: Dimensions.padding8),
          CustomInkWell(
            radius: Dimensions.radius20,
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding4),
              child: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerConfirmBar extends StatelessWidget {
  static const double _buttonHeight = 50;

  final bool canConfirm;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _PickerConfirmBar({
    required this.canConfirm,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding10,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding10,
      ),
      child: SizedBox(
        height: _buttonHeight,
        child: Row(
        children: <Widget>[
          Expanded(
            child: CustomButton(
              buttonText: 'cancel'.tr,
              width: double.infinity,
              height: _buttonHeight,
              radius: Dimensions.radius12,
              backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.10),
              textColor: context.customThemeColors.textColor,
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: Dimensions.padding16),
          Expanded(
            child: CustomButton(
              buttonText: 'confirm'.tr,
              width: double.infinity,
              height: _buttonHeight,
              radius: Dimensions.radius12,
              backgroundColor: canConfirm ? primary : primary.withValues(alpha: 0.4),
              textStyle: context.heading.defaultSize.copyWith(color: Colors.white),
              onPressed: canConfirm ? onConfirm : null,
            ),
          ),
        ],
        ),
      ),
    );
  }
}
