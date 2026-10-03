import 'package:tatarigigs_user/feature/booking/model/booking_enums.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_party_model.dart';

enum BookingTimelineKind { booked, statusChange, scheduleChange }

class BookingTimelineEntry {
  final BookingTimelineKind kind;
  final BookingStatus status;
  final String actorName;
  final String actorType;
  final DateTime? occurredAt;
  final DateTime? scheduledAt;

  const BookingTimelineEntry({
    required this.kind,
    this.status = BookingStatus.unknown,
    this.actorName = '',
    this.actorType = '',
    this.occurredAt,
    this.scheduledAt,
  });

  static List<BookingTimelineEntry> listFrom({
    required dynamic statusHistories,
    required dynamic scheduleHistories,
    required String customerName,
    required String providerCompanyName,
  }) {
    final List<Map<String, dynamic>> statuses =
        BookingParse.objectList<Map<String, dynamic>>(statusHistories, (Map<String, dynamic> j) => j);
    final List<Map<String, dynamic>> schedules =
        BookingParse.objectList<Map<String, dynamic>>(scheduleHistories, (Map<String, dynamic> j) => j);

    final List<BookingTimelineEntry> entries = <BookingTimelineEntry>[];

    entries.add(BookingTimelineEntry(
      kind: BookingTimelineKind.booked,
      actorName: customerName,
      occurredAt: schedules.isEmpty ? null : BookingParse.utcDate(schedules.first['created_at']),
    ));

    for (final Map<String, dynamic> row in statuses) {
      entries.add(BookingTimelineEntry(
        kind: BookingTimelineKind.statusChange,
        status: BookingStatus.fromApi(BookingParse.string(row['booking_status'])),
        actorName: _actorNameOf(row, providerCompanyName),
        actorType: _actorTypeOf(row),
        occurredAt: BookingParse.utcDate(row['created_at']),
      ));
    }

    for (int index = 1; index < schedules.length; index++) {
      final Map<String, dynamic> row = schedules[index];
      entries.add(BookingTimelineEntry(
        kind: BookingTimelineKind.scheduleChange,
        actorName: _actorNameOf(row, providerCompanyName),
        actorType: _actorTypeOf(row),
        occurredAt: BookingParse.utcDate(row['created_at']),
        scheduledAt: BookingParse.plainDate(row['schedule']),
      ));
    }

    entries.sort((BookingTimelineEntry a, BookingTimelineEntry b) {
      final DateTime? left = a.occurredAt;
      final DateTime? right = b.occurredAt;
      if (left == null || right == null) {
        return 0;
      }
      return left.compareTo(right);
    });

    return List<BookingTimelineEntry>.unmodifiable(entries);
  }

  static String _actorTypeOf(Map<String, dynamic> row) {
    final Map<String, dynamic>? user = BookingParse.object(row['user']);
    return user == null ? '' : BookingParse.string(user['user_type']) ?? '';
  }

  static String _actorNameOf(Map<String, dynamic> row, String providerCompanyName) {
    final Map<String, dynamic>? user = BookingParse.object(row['user']);
    if (user == null) {
      return providerCompanyName;
    }
    final BookingPersonModel person = BookingPersonModel.fromJson(user);
    return person.isProviderAdmin ? providerCompanyName : person.fullName;
  }
}
