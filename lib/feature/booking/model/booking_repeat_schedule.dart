import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingRepeatChild {
  final String id;
  final String readableId;
  final BookingStatus status;
  final String rawStatus;
  final bool isPaid;
  final double totalAmount;
  final DateTime? scheduledAt;

  const BookingRepeatChild({
    this.id = '',
    this.readableId = '',
    this.status = BookingStatus.unknown,
    this.rawStatus = '',
    this.isPaid = false,
    this.totalAmount = 0,
    this.scheduledAt,
  });

  factory BookingRepeatChild.fromJson(Map<String, dynamic> json) {
    final String rawStatus = BookingParse.string(json['booking_status']) ?? '';
    return BookingRepeatChild(
      id: BookingParse.string(json['id']) ?? '',
      readableId: BookingParse.string(json['readable_id']) ?? '',
      status: BookingStatus.fromApi(rawStatus),
      rawStatus: rawStatus,
      isPaid: BookingParse.toBool(json['is_paid']),
      totalAmount: BookingParse.toDouble(json['total_booking_amount']),
      scheduledAt: BookingParse.plainDate(json['service_schedule']),
    );
  }
}

class BookingRepeatSchedule {
  final RepeatBookingType type;
  final String rawType;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? time;
  final List<String> weekNames;
  final int totalCount;
  final int completedCount;
  final int canceledCount;
  final List<BookingRepeatChild> children;

  const BookingRepeatSchedule({
    this.type = RepeatBookingType.daily,
    this.rawType = '',
    this.startDate,
    this.endDate,
    this.time,
    this.weekNames = const <String>[],
    this.totalCount = 0,
    this.completedCount = 0,
    this.canceledCount = 0,
    this.children = const <BookingRepeatChild>[],
  });

  const BookingRepeatSchedule.empty() : this();

  factory BookingRepeatSchedule.fromJson(Map<String, dynamic> json) {
    final String rawType = BookingParse.string(json['bookingType']) ?? '';
    return BookingRepeatSchedule(
      type: _typeOf(rawType),
      rawType: rawType,
      startDate: BookingParse.plainDate(json['startDate']),
      endDate: BookingParse.plainDate(json['endDate']),
      time: BookingParse.plainDate(json['time']),
      weekNames: BookingParse.stringList(json['weekNames']),
      totalCount: BookingParse.toInt(json['totalCount']),
      completedCount: BookingParse.toInt(json['completedCount']),
      canceledCount: BookingParse.toInt(json['canceledCount']),
      children: BookingParse.objectList<BookingRepeatChild>(json['repeats'], BookingRepeatChild.fromJson),
    );
  }

  static RepeatBookingType _typeOf(String value) {
    switch (value.toLowerCase()) {
      case 'weekly':
        return RepeatBookingType.weekly;
      case 'custom':
        return RepeatBookingType.custom;
      default:
        return RepeatBookingType.daily;
    }
  }

  bool get isDaily => type == RepeatBookingType.daily;

  bool get isWeekly => type == RepeatBookingType.weekly;

  bool get isCustom => type == RepeatBookingType.custom;

  String get typeLabelKey => rawType.isEmpty ? type.name : rawType.toLowerCase();

  BookingRepeatChild? get nextService {
    for (final BookingRepeatChild child in children) {
      if (child.status == BookingStatus.ongoing) {
        return child;
      }
    }
    for (final BookingRepeatChild child in children) {
      if (child.status == BookingStatus.accepted) {
        return child;
      }
    }
    return null;
  }

  List<BookingRepeatChild> get alreadyProvided => children.where((BookingRepeatChild c) => c.status.isTerminal).toList(growable: false);

  List<BookingRepeatChild> get upcoming => upcomingExcluding(nextService);

  List<BookingRepeatChild> upcomingExcluding(BookingRepeatChild? next) => children
      .where((BookingRepeatChild c) => !c.status.isTerminal && (next == null || c.readableId != next.readableId)).toList(growable: false);

  List<DateTime> get occurrences => children.map((BookingRepeatChild c) => c.scheduledAt).whereType<DateTime>().toList(growable: false);

  bool get hasDateRange => startDate != null && endDate != null;
}

class RepeatBookingEditEntry {
  final String readableId;
  final int oldQuantity;
  final int newQuantity;
  final bool appliedToAll;
  final double serviceDiscount;
  final double vat;
  final DateTime? editedAt;
  final List<RepeatBookingEditLine> lines;

  const RepeatBookingEditEntry({
    this.readableId = '',
    this.oldQuantity = 0,
    this.newQuantity = 0,
    this.appliedToAll = false,
    this.serviceDiscount = 0,
    this.vat = 0,
    this.editedAt,
    this.lines = const <RepeatBookingEditLine>[],
  });

  factory RepeatBookingEditEntry.fromJson(Map<String, dynamic> json) => RepeatBookingEditEntry(
        readableId: BookingParse.string(json['readable_id']) ?? '',
        oldQuantity: BookingParse.toInt(json['old_quantity']),
        newQuantity: BookingParse.toInt(json['new_quantity']),
        appliedToAll: BookingParse.toBool(json['is_multiple']),
        serviceDiscount: BookingParse.toDouble(json['total_discount_amount']),
        vat: BookingParse.toDouble(json['total_tax_amount']),
        editedAt: BookingParse.utcDate(json['created_at']),
        lines: BookingParse.objectList<RepeatBookingEditLine>(json['log_details'], RepeatBookingEditLine.fromJson));

  double get subTotal => lines.fold(0, (double sum, RepeatBookingEditLine line) => sum + line.lineTotal);

  String get scopeLabelKey => appliedToAll ? 'edited_multiple_booking' : 'edited_only_this_single_booking';
}

class RepeatBookingEditLine {
  final String serviceName;
  final String variantKey;
  final int quantity;
  final double unitPrice;

  const RepeatBookingEditLine({
    this.serviceName = '',
    this.variantKey = '',
    this.quantity = 1,
    this.unitPrice = 0,
  });

  factory RepeatBookingEditLine.fromJson(Map<String, dynamic> json) => RepeatBookingEditLine(
        serviceName: BookingParse.string(json['service_name']) ?? '',
        variantKey: BookingParse.string(json['variant_key']) ?? '',
        quantity: BookingParse.toInt(json['quantity'], fallback: 1),
        unitPrice: BookingParse.toDouble(json['service_cost']),
      );

  String get label => variantKey.replaceAll('-', ' ').capitalizeFirst ?? variantKey;

  double get lineTotal => unitPrice * (quantity <= 0 ? 1 : quantity);
}
