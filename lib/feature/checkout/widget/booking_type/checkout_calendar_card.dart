import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:intl/intl.dart';

class CheckoutCalendarCard extends StatefulWidget {
  final bool isRangeMode;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CheckoutCalendarCard({
    super.key,
    required this.onDateSelected,
    this.isRangeMode = false,
    this.startDate,
    this.endDate,
    this.selectedDate,
  });

  @override
  State<CheckoutCalendarCard> createState() => _CheckoutCalendarCardState();
}

class _CheckoutCalendarCardState extends State<CheckoutCalendarCard> {
  static const List<String> _dayHeaders = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final DateTime anchor = widget.startDate ?? widget.selectedDate ?? DateTime.now();
    _displayedMonth = DateTime(anchor.year, anchor.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + delta);
    });
  }

  List<DateTime> _buildDays() {
    final int leading = (_displayedMonth.weekday - 1) % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);

    final List<DateTime> days = <DateTime>[];
    for (int i = leading; i > 0; i--) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, 1 - i));
    }
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, i));
    }
    final int trailing = (7 - days.length % 7) % 7;
    for (int i = 1; i <= trailing; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month + 1, i));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = _buildDays();

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _MonthArrow(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () => _shiftMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_displayedMonth),
                style: context.subHeading.defaultSize.medium,
              ),
              _MonthArrow(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: () => _shiftMonth(1),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding16),

          Row(
            children: _dayHeaders
                .map((String day) => Expanded(
                    child: Center(child: Text(day, style: context.body.small)))).toList(),
          ),
          const SizedBox(height: Dimensions.padding10),

          for (int row = 0; row < days.length ~/ 7; row++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding2),
              child: Row(
                children: List<Widget>.generate(
                  7,
                  (int col) => Expanded(
                    child: _CalendarDayCell(
                      date: days[row * 7 + col],
                      isSelected: _isSelected(days[row * 7 + col]),
                      isInRange: _isInRange(days[row * 7 + col]),
                      onTap: widget.onDateSelected,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isSelected(DateTime date) {
    if (!widget.isRangeMode) {
      final DateTime? selected = widget.selectedDate;
      return selected != null && DateUtils.isSameDay(date, selected);
    }
    final DateTime? start = widget.startDate;
    final DateTime? end = widget.endDate;
    return (start != null && DateUtils.isSameDay(date, start)) || (end != null && DateUtils.isSameDay(date, end));
  }

  bool _isInRange(DateTime date) {
    if (!widget.isRangeMode) {
      return false;
    }
    final DateTime? start = widget.startDate;
    final DateTime? end = widget.endDate;
    if (start == null || end == null) {
      return false;
    }
    return date.isAfter(start) && date.isBefore(end);
  }
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MonthArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding4),
        child: Icon(icon, size: 14, color: context.customThemeColors.secondaryTextColor),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isInRange;
  final ValueChanged<DateTime> onTap;

  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.isInRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool isPast = date.isBefore(DateUtils.dateOnly(DateTime.now()));

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      );
    } else if (isInRange) {
      decoration = BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      );
    } else if (isPast) {
      decoration = BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isPast ? null : () => onTap(date),
      child: Center(
        child: Container(
          height: 34,
          width: 34,
          alignment: Alignment.center,
          decoration: decoration,
          child: Text(
            '${date.day}',
            style: isSelected
                ? context.heading.small.copyWith(color: Colors.white)
                : isPast ? context.body.small : context.subHeading.small,
          ),
        ),
      ),
    );
  }
}
