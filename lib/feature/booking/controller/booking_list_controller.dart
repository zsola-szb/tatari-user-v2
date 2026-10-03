import 'package:tatarigigs_user/helper/debounce_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class BookingListController extends GetxController implements GetxService {
  final BookingRepo bookingRepo;

  BookingListController({required this.bookingRepo});

  static const int _pageSize = 10;

  final DebounceHelper _tabDebounce = DebounceHelper(milliseconds: 300);

  BookingListStatus _status = BookingListStatus.loading;
  BookingListStatus get status => _status;

  bool get isLoading => _status == BookingListStatus.loading;
  bool get isEmpty => _status == BookingListStatus.empty;

  BookingListTab _selectedTab = BookingListTab.all;
  BookingListTab get selectedTab => _selectedTab;

  ServiceType _serviceType = ServiceType.all;
  ServiceType get serviceType => _serviceType;
  bool get isFiltered => _serviceType != ServiceType.all;

  List<BookingListItemModel> _bookings = <BookingListItemModel>[];
  List<BookingListItemModel> get bookings => List<BookingListItemModel>.unmodifiable(_bookings);

  BookingListPageModel _page = const BookingListPageModel.empty();
  BookingListPageModel get page => _page;

  Map<BookingListTab, int> _statusCounts = <BookingListTab, int>{};
  bool get hasStatusCounts => _statusCounts.isNotEmpty;

  int _offset = 1;
  int get offset => _offset;

  int get totalSize => _page.total;

  Future<void> initData({BookingListTab? initialTab}) async {
    _selectedTab = initialTab ?? BookingListTab.all;
    _serviceType = ServiceType.all;
    _bookings = <BookingListItemModel>[];
    _status = BookingListStatus.loading;
    _notify();
    await loadBookings(offset: 1);
  }

  void selectTab(BookingListTab tab) {
    if (_selectedTab == tab) {
      return;
    }
    _selectedTab = tab;
    _bookings = <BookingListItemModel>[];
    _status = BookingListStatus.loading;
    _notify();

    _tabDebounce.run(() => loadBookings(offset: 1));
  }

  void selectServiceType(ServiceType type) {
    if (_serviceType == type) {
      return;
    }
    _serviceType = type;
    _bookings = <BookingListItemModel>[];
    _status = BookingListStatus.loading;
    _notify();
    loadBookings(offset: 1);
  }

  Future<void> refreshCurrentTab() => loadBookings(offset: 1);

  Future<void> loadBookings({required int offset, bool isPagination = false}) async {
    _offset = offset;
    if (!isPagination) {
      _bookings = <BookingListItemModel>[];
      _status = BookingListStatus.loading;
    } else {
      _status = BookingListStatus.paginating;
    }
    _notify();

    final Response response = await bookingRepo.getBookingList(
      offset: offset,
      bookingStatus: _selectedTab.apiKey,
      serviceType: _serviceType.name,
      limit: _pageSize,
    );

    if (response.statusCode == 200 && response.body is Map) {
      final BookingListPageModel page =
          BookingListPageModel.fromJson(Map<String, dynamic>.from(response.body as Map));
      _page = page;
      if (page.hasCounts) {
        _statusCounts = page.statusCounts;
      }
      if (isPagination) {
        _bookings = <BookingListItemModel>[..._bookings, ...page.bookings];
      } else {
        _bookings = page.bookings;
      }
      _status = _bookings.isEmpty ? BookingListStatus.empty : BookingListStatus.ready;
    } else {
      _status = _bookings.isEmpty ? BookingListStatus.error : BookingListStatus.ready;
      ApiChecker.checkApi(response);
    }
    _notify();
  }

  int countFor(BookingListTab tab) => _statusCounts[tab] ?? 0;

  List<BookingListSection> get sections {
    final List<BookingListSection> sections = <BookingListSection>[];
    DateTime? currentDay;
    List<BookingListItemModel> bucket = <BookingListItemModel>[];

    void flush() {
      if (bucket.isEmpty) {
        return;
      }
      sections.add(_sectionOf(currentDay, bucket));
      bucket = <BookingListItemModel>[];
    }

    for (final BookingListItemModel booking in _bookings) {
      final DateTime? date = booking.serviceAt ?? booking.placedAt;
      final DateTime? day = date == null ? null : DateTime(date.year, date.month, date.day);

      if (bucket.isNotEmpty && day != currentDay) {
        flush();
      }
      currentDay = day;
      bucket.add(booking);
    }
    flush();

    return List<BookingListSection>.unmodifiable(sections);
  }

  BookingListSection _sectionOf(DateTime? day, List<BookingListItemModel> bookings) {
    if (day == null) {
      return BookingListSection(bookings: List<BookingListItemModel>.unmodifiable(bookings));
    }

    final int daysAgo = DateConverter.countDays(day);
    final DateTime now = DateTime.now();
    final bool isToday = day.year == now.year && day.month == now.month && day.day == now.day;

    return BookingListSection(
      day: day,
      labelKey: isToday ? 'today' : daysAgo == 1 ? 'yesterday' : '',
      label: DateConverter.dateStringMonthYear(day),
      bookings: List<BookingListItemModel>.unmodifiable(bookings),
    );
  }

  /// `update()` that is safe to call while a frame is being built.
  ///
  /// The screens invoke [initData] from `initState`, which runs inside the
  /// build phase; notifying synchronously there would call `setState` on the
  /// `GetBuilder` mid-build. Outside a build this is just `update()`.
  void _notify() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => update());
      return;
    }
    update();
  }
}
