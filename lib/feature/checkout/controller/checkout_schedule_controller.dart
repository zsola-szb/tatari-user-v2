import 'dart:convert';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckoutScheduleController extends GetxController implements GetxService {
  final CheckoutRepo checkoutRepo;

  CheckoutScheduleController({required this.checkoutRepo});

  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static const List<String> weekDayKeys = <String>['saturday', 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday'];

  bool _isSingleBooking = true;
  bool get isSingleBooking => _isSingleBooking;
  ServiceType get serviceType => _isSingleBooking ? ServiceType.regular : ServiceType.repeat;
  DateTime? _singleScheduleAt;
  DateTime? get singleScheduleAt => _singleScheduleAt;
  bool get isInstantBooking => _isSingleBooking && _singleScheduleAt == null;


  RepeatBookingType _repeatType = RepeatBookingType.daily;
  RepeatBookingType get repeatType => _repeatType;

  DateTimeRange? _dailyRange;
  DateTimeRange? get dailyRange => _dailyRange;

  TimeOfDay? _dailyTime;
  TimeOfDay? get dailyTime => _dailyTime;

  DateTimeRange? _weeklyRange;
  DateTimeRange? get weeklyRange => _weeklyRange;

  TimeOfDay? _weeklyTime;
  TimeOfDay? get weeklyTime => _weeklyTime;

  List<bool> _weeklyDayFlags = List<bool>.filled(weekDayKeys.length, false);
  List<bool> get weeklyDayFlags => List<bool>.unmodifiable(_weeklyDayFlags);

  List<DateTime> _customOccurrences = <DateTime>[];
  List<DateTime> get customOccurrences => List<DateTime>.unmodifiable(_customOccurrences);

  List<String> get selectedWeekDays {
    final List<String> days = <String>[];
    for (int index = 0; index < _weeklyDayFlags.length; index++) {
      if (_weeklyDayFlags[index]) {
        days.add(weekDayKeys[index]);
      }
    }
    return days;
  }

  List<DateTime> _repeatOccurrences = <DateTime>[];
  List<DateTime> get repeatOccurrences => List<DateTime>.unmodifiable(_repeatOccurrences);

  bool get hasRepeatSelection => _repeatOccurrences.isNotEmpty;

  int get occurrenceCount => _isSingleBooking ? 1 : _repeatOccurrences.length;

  DateTimeRange? get occurrenceRange {
    if (_repeatOccurrences.isEmpty) {
      return null;
    }
    final List<DateTime> sorted = List<DateTime>.from(_repeatOccurrences)..sort();
    return DateTimeRange(start: sorted.first, end: sorted.last);
  }

  void initData({DateTime? initialScheduleAt, bool notify = false}) {
    _isSingleBooking = true;
    _singleScheduleAt = initialScheduleAt;
    _repeatType = RepeatBookingType.daily;
    _dailyRange = null;
    _dailyTime = null;
    _weeklyRange = null;
    _weeklyTime = null;
    _weeklyDayFlags = List<bool>.filled(weekDayKeys.length, false);
    _customOccurrences = <DateTime>[];
    _repeatOccurrences = <DateTime>[];

    if (notify) {
      update();
    }
  }

  void setBookingMode(bool single, {bool notify = true}) {
    if (_isSingleBooking == single) {
      return;
    }
    _isSingleBooking = single;

    if (single) {
      _clearRepeatSelection();
    } else {
      _singleScheduleAt = null;
    }

    if (notify) {
      update();
    }
  }

  void setSingleSchedule(DateTime? dateTime, {bool notify = true}) {
    _singleScheduleAt = dateTime;
    if (notify) {
      update();
    }
  }

  void setRepeatType(RepeatBookingType type, {bool notify = true}) {
    if (_repeatType == type) {
      return;
    }
    _repeatType = type;
    _clearRepeatSelection();
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void setDailySelection({
    required DateTimeRange range,
    required TimeOfDay time,
    bool notify = true,
  }) {
    _dailyRange = range;
    _dailyTime = time;
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void setWeeklySelection({
    required List<bool> dayFlags,
    required DateTimeRange? range,
    required TimeOfDay time,
    bool notify = true,
  }) {
    if (dayFlags.length == weekDayKeys.length) {
      _weeklyDayFlags = List<bool>.from(dayFlags);
    }
    _weeklyRange = range;
    _weeklyTime = time;
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void setCustomOccurrences(List<DateTime> occurrences, {bool notify = true}) {
    _customOccurrences = List<DateTime>.from(occurrences)..sort();
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void updateCustomOccurrenceTime(int index, TimeOfDay time, {bool notify = true}) {
    if (index < 0 || index >= _customOccurrences.length) {
      return;
    }
    final DateTime occurrence = _customOccurrences[index];
    _customOccurrences[index] =
        DateTime(occurrence.year, occurrence.month, occurrence.day, time.hour, time.minute);
    _customOccurrences.sort();
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void removeCustomOccurrence(int index, {bool notify = true}) {
    if (index < 0 || index >= _customOccurrences.length) {
      return;
    }
    _customOccurrences.removeAt(index);
    _recomputeOccurrences();
    if (notify) {
      update();
    }
  }

  void _clearRepeatSelection() {
    _dailyRange = null;
    _dailyTime = null;
    _weeklyRange = null;
    _weeklyTime = null;
    _weeklyDayFlags = List<bool>.filled(weekDayKeys.length, false);
    _customOccurrences = <DateTime>[];
    _repeatOccurrences = <DateTime>[];
  }

  String? buildRepeatDatesPayload() {
    if (_isSingleBooking) {
      return null;
    }
    return CheckoutHelper.getRepeatBookingScheduleList(
      repeatBookingType: _repeatType,
      dateRange: _repeatType == RepeatBookingType.daily ? _dailyRange : _weeklyRange,
      time: _repeatType == RepeatBookingType.daily ? _dailyTime : _weeklyTime,
      dateTimeList: _customOccurrences,
      selectedDays: selectedWeekDays,
    );
  }

  String? get scheduleTimeString {
    if (!_isSingleBooking) {
      final DateTimeRange? range = occurrenceRange;
      return range == null ? null : _dateTimeFormat.format(range.start);
    }
    final DateTime? scheduledAt = _singleScheduleAt;
    if (scheduledAt != null) {
      return _dateTimeFormat.format(scheduledAt);
    }
    return _dateTimeFormat.format(DateTime.now().add(const Duration(minutes: 2)));
  }

  void _recomputeOccurrences() {
    if (_isSingleBooking) {
      _repeatOccurrences = <DateTime>[];
      return;
    }

    final String? payload = buildRepeatDatesPayload();
    if (payload == null || payload.isEmpty) {
      _repeatOccurrences = <DateTime>[];
      return;
    }

    try {
      final dynamic decoded = jsonDecode(payload);
      if (decoded is! List) {
        _repeatOccurrences = <DateTime>[];
        return;
      }
      final List<DateTime> parsed = <DateTime>[];
      for (final dynamic entry in decoded) {
        if (entry is Map && entry['date'] != null) {
          parsed.add(_dateTimeFormat.parse(entry['date'].toString()));
        }
      }
      parsed.sort();
      _repeatOccurrences = parsed;
    } catch (e) {
      printLog('checkout: could not expand repeat schedule -> $e');
      _repeatOccurrences = <DateTime>[];
    }
  }

  String? validateSelection() {
    if (_isSingleBooking) {
      return null;
    }
    switch (_repeatType) {
      case RepeatBookingType.daily:
        if (_dailyRange == null) {
          return 'daily_select_time_and_date_hint';
        }
        if (_dailyTime == null) {
          return 'select_time_hint';
        }
        break;
      case RepeatBookingType.weekly:
        if (selectedWeekDays.isEmpty) {
          return 'weekly_select_time_and_date_hint';
        }
        if (_weeklyTime == null) {
          return 'select_time_hint';
        }
        break;
      case RepeatBookingType.custom:
        if (_customOccurrences.isEmpty) {
          return 'custom_select_time_and_date_hint';
        }
        break;
    }
    return _repeatOccurrences.isEmpty ? 'custom_select_time_and_date_hint' : null;
  }

  String? checkLeadTimeRestriction(AdvanceBooking? advanceBooking) {
    final DateTime? scheduledAt = _singleScheduleAt;
    if (advanceBooking == null || scheduledAt == null) {
      return null;
    }
    final int? restrictionValue = advanceBooking.advancedBookingRestrictionValue;
    if (restrictionValue == null || restrictionValue <= 0) {
      return null;
    }

    final Duration difference = scheduledAt.difference(DateTime.now());
    final String type = advanceBooking.advancedBookingRestrictionType ?? '';

    if (type == 'day' && difference.inDays < restrictionValue) {
      return '${'you_can_not_select_schedule_before'.tr} '
          '${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(days: restrictionValue)))}';
    }
    if (type == 'hour' && difference.inHours < restrictionValue) {
      return '${'you_can_not_select_schedule_before'.tr} '
          '${DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.now().add(Duration(hours: restrictionValue)))}';
    }
    return null;
  }

  Future<bool> updatePostSchedule({required String postId, required String schedule}) async {
    final Response response = await checkoutRepo.updatePostSchedule(
      postId: postId,
      schedule: schedule,
    );
    final dynamic body = response.body;
    final bool isSuccess = response.statusCode == 200 &&
        body is Map &&
        body['response_code'] == 'default_update_200';

    if (isSuccess) {
      customSnackBar(
        'service_schedule_updated_successfully'.tr,
        type: ToasterMessageType.success,
      );
    }
    return isSuccess;
  }
}
