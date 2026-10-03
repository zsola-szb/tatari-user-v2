import 'package:tatarigigs_user/feature/booking/model/booking_list_item_model.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_enums.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';

class BookingListPageModel {
  final List<BookingListItemModel> bookings;
  final int currentPage;
  final int lastPage;
  final int total;
  final Map<BookingListTab, int> statusCounts;

  const BookingListPageModel({
    this.bookings = const <BookingListItemModel>[],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.statusCounts = const <BookingListTab, int>{},
  });

  const BookingListPageModel.empty() : this();

  factory BookingListPageModel.fromJson(Map<String, dynamic> json) {
    final int total = BookingParse.toInt(json['total_size']);
    final int limit = BookingParse.toInt(json['limit'], fallback: 10);

    return BookingListPageModel(
      bookings: BookingParse.objectList<BookingListItemModel>(json['data'], BookingListItemModel.fromJson),
      currentPage: BookingParse.toInt(json['offset'], fallback: 1),
      lastPage: limit > 0 ? (total / limit).ceil().clamp(1, double.infinity).toInt() : 1,
      total: total,
      statusCounts: _countsOf(json),
    );
  }

  static Map<BookingListTab, int> _countsOf(Map<String, dynamic> json) {
    final Map<BookingListTab, int> parsed = <BookingListTab, int>{};
    for (final BookingListTab tab in BookingListTab.values) {
      final int? value = BookingParse.intOrNull(json['${tab.apiKey}_count']);
      if (value != null) {
        parsed[tab] = value;
      }
    }
    return Map<BookingListTab, int>.unmodifiable(parsed);
  }

  bool get hasCounts => statusCounts.isNotEmpty;
}

class BookingListSection {
  final DateTime? day;
  final String labelKey;
  final String label;
  final List<BookingListItemModel> bookings;

  const BookingListSection({
    this.day,
    this.labelKey = '',
    this.label = '',
    this.bookings = const <BookingListItemModel>[],
  });

  bool get usesTranslationKey => labelKey.isNotEmpty;
}
