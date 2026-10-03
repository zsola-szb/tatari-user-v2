import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingListItemModel {
  final String id;
  final String readableId;
  final String rawStatus;
  final BookingStatus status;
  final BookingKind kind;
  final String subCategoryId;
  final double totalAmount;
  final DateTime? placedAt;
  final DateTime? serviceAt;
  final BookingProviderModel? provider;
  final List<BookingServiceItemModel> services;

  const BookingListItemModel({
    this.id = '',
    this.readableId = '',
    this.rawStatus = '',
    this.status = BookingStatus.unknown,
    this.kind = BookingKind.regular,
    this.subCategoryId = '',
    this.totalAmount = 0,
    this.placedAt,
    this.serviceAt,
    this.provider,
    this.services = const <BookingServiceItemModel>[],
  });

  factory BookingListItemModel.fromJson(Map<String, dynamic> json) {
    final String rawStatus = BookingParse.string(json['booking_status']) ?? '';
    final bool isRepeat = BookingParse.toBool(json['is_repeated']);
    final bool isCustomize = BookingParse.toBool(json['is_customized_booking']) ||
        BookingParse.toBool(json['is_customize_booking']);
    final Map<String, dynamic>? subCategory = BookingParse.object(json['sub_category']);

    return BookingListItemModel(
      id: BookingParse.string(json['id']) ?? '',
      readableId: BookingParse.string(json['readable_id']) ?? '',
      rawStatus: rawStatus,
      status: BookingStatus.fromApi(rawStatus),
      kind: BookingKind.fromFlags(isRepeat: isRepeat, isCustomize: isCustomize, isRepeatChild: false),
      subCategoryId: BookingParse.string(subCategory?['id']) ?? BookingParse.string(json['sub_category_id']) ?? '',
      totalAmount: BookingParse.toDouble(json['total_booking_amount']),
      placedAt: BookingParse.utcDate(json['created_at']),
      serviceAt: _currentScheduleOf(json),
      provider: _providerOf(json),
      services: json['services'] is List
          ? BookingParse.objectList<BookingServiceItemModel>(json['services'], BookingServiceItemModel.fromSummaryJson)
          : BookingServiceItemModel.listFrom(json['detail']),
    );
  }

  static BookingProviderModel? _providerOf(Map<String, dynamic> json) {
    final Map<String, dynamic>? provider = BookingParse.object(json['provider']);
    if (provider != null) {
      return BookingProviderModel.fromJson(provider);
    }

    final String? providerId = BookingParse.string(json['provider_id']);
    final String? providerName = BookingParse.string(json['provider_name']);
    if (providerId == null && providerName == null) {
      return null;
    }
    return BookingProviderModel(id: providerId ?? '', companyName: providerName ?? '');
  }

  static DateTime? _currentScheduleOf(Map<String, dynamic> json) {
    final List<Map<String, dynamic>> repeats = BookingParse.objectList<Map<String, dynamic>>(
      json['repeats'],
      (Map<String, dynamic> child) => child,
    );
    if (repeats.isEmpty) {
      return BookingParse.plainDate(json['service_schedule']);
    }

    const List<BookingStatus> precedence = <BookingStatus>[
      BookingStatus.ongoing,
      BookingStatus.accepted,
      BookingStatus.completed,
      BookingStatus.canceled,
      BookingStatus.pending,
    ];

    for (final BookingStatus wanted in precedence) {
      for (final Map<String, dynamic> child in repeats) {
        if (BookingStatus.fromApi(BookingParse.string(child['booking_status'])) == wanted) {
          final DateTime? schedule = BookingParse.plainDate(child['service_schedule']);
          if (schedule != null) {
            return schedule;
          }
        }
      }
    }
    return BookingParse.plainDate(json['service_schedule']);
  }

  String get providerDisplayName {
    final String name = provider?.companyName ?? '';
    return name.isEmpty ? '${AppConstants.appName} ${'will_choose'.tr}' : name;
  }

  List<String> get serviceThumbnails => services
      .map((BookingServiceItemModel service) => service.thumbnailFullPath ?? '').toList(growable: false);

  int get serviceCount => services.length;

  bool get isRepeat => kind.isRepeat;
}
