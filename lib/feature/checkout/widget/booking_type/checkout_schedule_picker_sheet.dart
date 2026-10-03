import 'package:tatarigigs_user/feature/checkout/widget/booking_type/checkout_calendar_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/checkout_time_drum_field.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/picker_sheet_header.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

enum CheckoutSchedulePickerMode { single, daily, weekly}

class CheckoutSchedulePickerSheet extends StatefulWidget {
  final CheckoutSchedulePickerMode mode;
  final DateTime? initialDateTime;
  final DateTimeRange? initialRange;
  final TimeOfDay? initialTime;
  final List<bool> initialDayFlags;
  final VoidCallback? onInstantBooking;

  final ValueChanged<DateTime>? onSingleSaved;
  final void Function(DateTimeRange range, TimeOfDay time)? onDailySaved;
  final void Function(List<bool> dayFlags, DateTimeRange? range, TimeOfDay time)?onWeeklySaved;

  const CheckoutSchedulePickerSheet({
    super.key,
    required this.mode,
    this.initialDateTime,
    this.initialRange,
    this.initialTime,
    this.initialDayFlags = const <bool>[],
    this.onInstantBooking,
    this.onSingleSaved,
    this.onDailySaved,
    this.onWeeklySaved,
  });

  @override
  State<CheckoutSchedulePickerSheet> createState() => _CheckoutSchedulePickerSheetState();
}

class _CheckoutSchedulePickerSheetState extends State<CheckoutSchedulePickerSheet> {
  late List<bool> _dayFlags;
  late bool _repeatEveryWeek;
  late TimeOfDay _time;
  late DateTime _selectedDate;
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isSingle => widget.mode == CheckoutSchedulePickerMode.single;

  bool get _isWeekly => widget.mode == CheckoutSchedulePickerMode.weekly;

  bool get _showsCalendar => !_isWeekly || _repeatEveryWeek;

  bool get _canSave {
    switch (widget.mode) {
      case CheckoutSchedulePickerMode.single:
        return true;
      case CheckoutSchedulePickerMode.daily:
        return _startDate != null && _endDate != null;
      case CheckoutSchedulePickerMode.weekly:
        return _dayFlags.contains(true);
    }
  }

  @override
  void initState() {
    super.initState();
    final int dayCount = CheckoutScheduleController.weekDayKeys.length;
    _dayFlags = widget.initialDayFlags.length == dayCount ? List<bool>.from(widget.initialDayFlags) : List<bool>.filled(dayCount, false);

    _repeatEveryWeek = widget.initialRange != null;
    _selectedDate = widget.initialDateTime ?? DateTime.now();
    _startDate = widget.initialRange?.start;
    _endDate = widget.initialRange?.end;

    final DateTime? seed = widget.initialDateTime;
    _time = widget.initialTime ?? (seed != null ? TimeOfDay(hour: seed.hour, minute: seed.minute) : TimeOfDay.now());
  }

  void _onDateTapped(DateTime date) {
    if (_isSingle) {
      setState(() => _selectedDate = date);
      return;
    }
    setState(() {
      if (_startDate == null || _endDate != null) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
      } else {
        _endDate = date;
      }
    });
  }

  void _onSave() {
    switch (widget.mode) {
      case CheckoutSchedulePickerMode.single:
        _saveSingle();
        break;
      case CheckoutSchedulePickerMode.daily:
        _saveDaily();
        break;
      case CheckoutSchedulePickerMode.weekly:
        _saveWeekly();
        break;
    }
  }

  void _saveSingle() {
    final DateTime composed = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _time.hour,
      _time.minute,
    );
    if (composed.isBefore(DateTime.now())) {
      customSnackBar('selected_time_cannot_earlier'.tr, type: ToasterMessageType.info, showDefaultSnackBar: false);
      return;
    }
    Navigator.of(context).pop();
    widget.onSingleSaved?.call(composed);
  }

  void _saveDaily() {
    final DateTime? start = _startDate;
    final DateTime? end = _endDate;
    if (start == null || end == null) {
      customSnackBar('daily_select_time_and_date_hint'.tr, type: ToasterMessageType.info, showDefaultSnackBar: false);
      return;
    }
    Navigator.of(context).pop();
    widget.onDailySaved?.call(DateTimeRange(start: start, end: end), _time);
  }

  void _saveWeekly() {
    if (!_dayFlags.contains(true)) {
      customSnackBar('weekly_select_time_and_date_hint'.tr, type: ToasterMessageType.info, showDefaultSnackBar: false);
      return;
    }
    final DateTime? start = _startDate;
    final DateTime? end = _endDate;
    final DateTimeRange? range = (_repeatEveryWeek && start != null && end != null) ? DateTimeRange(start: start, end: end) : null;
    Navigator.of(context).pop();
    widget.onWeeklySaved?.call(List<bool>.from(_dayFlags), range, _time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PickerSheetHeader(
              title: _isWeekly ? 'select_days_and_time'.tr : 'select_date_and_time'.tr,
              subtitle: _isWeekly ? 'choose_your_preferred_weekly_schedule_and_time'.tr : 'choose_your_preferable_date_and_time'.tr,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.padding16,
                  vertical: Dimensions.padding10,
                ),
                child: Column(
                  children: <Widget>[
                    if (_isWeekly) ...<Widget>[
                      _DayCheckboxGrid(
                        dayFlags: _dayFlags,
                        onToggle: (int index) =>
                            setState(() => _dayFlags[index] = !_dayFlags[index]),
                      ),
                      const SizedBox(height: Dimensions.padding16),
                      _RepeatEveryWeekRow(
                        isChecked: _repeatEveryWeek,
                        onChanged: (bool value) => setState(() {
                          _repeatEveryWeek = value;
                          if (!value) {
                            _startDate = null;
                            _endDate = null;
                          }
                        }),
                      ),
                      const SizedBox(height: Dimensions.padding16),
                    ],

                    if (_showsCalendar) ...<Widget>[
                      CheckoutCalendarCard(
                        isRangeMode: !_isSingle,
                        selectedDate: _selectedDate,
                        startDate: _startDate,
                        endDate: _endDate,
                        onDateSelected: _onDateTapped,
                      ),
                      const SizedBox(height: Dimensions.padding16),
                    ],

                    CheckoutTimeDrumField(
                      label: 'preferable_time'.tr,
                      initialTime: _time,
                      onChanged: (TimeOfDay time) => _time = time,
                    ),

                    if (_isWeekly) ...<Widget>[
                      const SizedBox(height: Dimensions.padding16),
                      const _WeeklyInfoBox(),
                    ],
                  ],
                ),
              ),
            ),
            _PickerSheetActionBar(
              canSave: _canSave,
              onInstantBooking: widget.onInstantBooking == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      widget.onInstantBooking?.call();
                    },
              onCancel: () => Navigator.of(context).pop(),
              onSave: _onSave,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCheckboxGrid extends StatelessWidget {
  final List<bool> dayFlags;
  final ValueChanged<int> onToggle;

  const _DayCheckboxGrid({required this.dayFlags, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: Dimensions.padding4,
          crossAxisSpacing: Dimensions.padding4,
          mainAxisExtent: 32,
        ),
        itemCount: CheckoutScheduleController.weekDayKeys.length,
        itemBuilder: (BuildContext context, int index) => _DayCheckboxTile(
          label: CheckoutScheduleController.weekDayKeys[index].tr,
          isChecked: dayFlags[index],
          onTap: () => onToggle(index),
        ),
      ),
    );
  }
}

class _DayCheckboxTile extends StatelessWidget {
  final String label;
  final bool isChecked;
  final VoidCallback onTap;

  const _DayCheckboxTile({
    required this.label,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          _PickerCheckbox(isChecked: isChecked, onChanged: (_) => onTap()),
          const SizedBox(width: Dimensions.padding4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isChecked ? context.heading.small : context.subHeading.small,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepeatEveryWeekRow extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const _RepeatEveryWeekRow({required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!isChecked),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'repeat_this_every_week'.tr,
                style: context.subHeading.defaultSize.medium,
              ),
            ),
            const SizedBox(width: Dimensions.padding10),
            _PickerCheckbox(isChecked: isChecked, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _PickerCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const _PickerCheckbox({required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: isChecked,
        activeColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius4),
        ),
        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.30), width: 1.5),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onChanged: (bool? value) => onChanged(value ?? false),
      ),
    );
  }
}

class _WeeklyInfoBox extends StatelessWidget {
  const _WeeklyInfoBox();

  @override
  Widget build(BuildContext context) {
    return CheckoutInfoBox(
      child: Text.rich(
        TextSpan(
          style: context.subHeading.small,
          children: <InlineSpan>[
            TextSpan(text: '${'you_will_receive_this_services_in_the_upcoming'.tr} '),
            TextSpan(
              text: 'week_days'.tr,
              style: context.heading.small,
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}

class _PickerSheetActionBar extends StatelessWidget {
  final bool canSave;
  final VoidCallback? onInstantBooking;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _PickerSheetActionBar({
    required this.canSave,
    required this.onCancel,
    required this.onSave,
    this.onInstantBooking,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding16,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding16,
      ),
      child: Row(
        children: <Widget>[
          if (onInstantBooking != null) ...<Widget>[
            _PickerAction(
              label: 'instant_booking'.tr,
              background: Theme.of(context).hintColor.withValues(alpha: 0.10),
              foreground: context.customThemeColors.textColor,
              onTap: onInstantBooking,
            ),
            const Spacer(),
            _PickerAction(
              label: 'cancel'.tr,
              background: Colors.transparent,
              foreground: context.customThemeColors.textColor,
              onTap: onCancel,
            ),
            const SizedBox(width: Dimensions.padding8),
            _PickerAction(
              label: 'save'.tr,
              background: canSave ? primary : primary.withValues(alpha: 0.4),
              foreground: Colors.white,
              onTap: canSave ? onSave : null,
            ),
          ] else ...<Widget>[
            Expanded(
              child: _PickerAction(
                label: 'cancel'.tr,
                background: Theme.of(context).hintColor.withValues(alpha: 0.10),
                foreground: context.customThemeColors.textColor,
                onTap: onCancel,
              ),
            ),
            const SizedBox(width: Dimensions.padding16),
            Expanded(
              child: _PickerAction(
                label: 'save'.tr,
                background: canSave ? primary : primary.withValues(alpha: 0.4),
                foreground: Colors.white,
                onTap: canSave ? onSave : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickerAction extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  const _PickerAction({
    required this.label,
    required this.background,
    required this.foreground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding20,
          vertical: Dimensions.padding16,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.heading.defaultSize.copyWith(color: foreground),
        ),
      ),
    );
  }
}
