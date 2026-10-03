import 'package:tatarigigs_user/util/core_export.dart';

class BookingDetailModel {
  final String id;
  final String parentBookingId;
  final String readableId;
  final String subCategoryId;
  final String rawStatus;
  final BookingStatus status;
  final BookingKind kind;
  final DateTime? placedAt;
  final DateTime? scheduledAt;
  final String rawServiceLocation;
  final String? otp;
  final List<String> evidencePhotos;
  final List<BookingServiceItemModel> services;
  final BookingBillingTotals billing;
  final RepeatBookingBillingTotals repeatBilling;
  final BookingPaymentState payment;
  final BookingProviderModel? provider;
  final BookingServicemanModel? serviceman;
  final BookingPersonModel? customer;
  final BookingAddressModel? serviceAddress;
  final BookingRepeatSchedule repeat;
  final List<RepeatBookingEditEntry> editHistory;
  final List<BookingTimelineEntry> timeline;

  const BookingDetailModel({
    this.id = '',
    this.parentBookingId = '',
    this.readableId = '',
    this.subCategoryId = '',
    this.rawStatus = '',
    this.status = BookingStatus.unknown,
    this.kind = BookingKind.regular,
    this.placedAt,
    this.scheduledAt,
    this.rawServiceLocation = '',
    this.otp,
    this.evidencePhotos = const <String>[],
    this.services = const <BookingServiceItemModel>[],
    this.billing = const BookingBillingTotals.empty(),
    this.repeatBilling = const RepeatBookingBillingTotals.empty(),
    this.payment = const BookingPaymentState.empty(),
    this.provider,
    this.serviceman,
    this.customer,
    this.serviceAddress,
    this.repeat = const BookingRepeatSchedule.empty(),
    this.editHistory = const <RepeatBookingEditEntry>[],
    this.timeline = const <BookingTimelineEntry>[],
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json, {bool isRepeatChild = false}) {
    final String rawStatus = BookingParse.string(json['booking_status']) ?? '';
    final bool isRepeat = BookingParse.toBool(json['is_repeated']);
    final bool isCustomize = BookingParse.toBool(json['is_customize_booking']);

    final List<BookingServiceItemModel> services =
        BookingServiceItemModel.listFrom(json['services'] ?? json['detail']);
    final BookingRepeatSchedule repeat = BookingRepeatSchedule.fromJson(json);

    final Map<String, dynamic>? parent = BookingParse.object(json['booking']);
    final Map<String, dynamic>? address = BookingParse.object(json['service_address']) ??
        (parent == null ? null : BookingParse.object(parent['service_address']));

    final Map<String, dynamic>? providerJson = BookingParse.object(json['provider']) ??
        (parent == null ? null : BookingParse.object(parent['provider']));
    final Map<String, dynamic>? servicemanJson = BookingParse.object(json['serviceman']);
    final Map<String, dynamic>? customerJson = BookingParse.object(json['customer']);

    final BookingProviderModel? provider =
        providerJson == null ? null : BookingProviderModel.fromJson(providerJson);

    final List<RepeatBookingEditEntry> editHistory =
        BookingParse.objectList<RepeatBookingEditEntry>(json['repeatHistory'], RepeatBookingEditEntry.fromJson);

    final BookingPersonModel? customer =
        customerJson == null ? null : BookingPersonModel.fromJson(customerJson);
    final BookingAddressModel? serviceAddress =
        address == null ? null : BookingAddressModel.fromJson(address);

    return BookingDetailModel(
      id: BookingParse.string(json['id']) ?? '',
      parentBookingId: BookingParse.string(json['booking_id']) ?? (parent == null ? '' : BookingParse.string(parent['id']) ?? ''),
      readableId: BookingParse.string(json['readable_id']) ?? '',
      subCategoryId: BookingParse.string(json['sub_category_id']) ??
          BookingParse.string(BookingParse.object(json['sub_category'])?['id']) ??
          (parent == null ? '' : BookingParse.string(parent['sub_category_id']) ?? ''),
      rawStatus: rawStatus,
      status: BookingStatus.fromApi(rawStatus),
      kind: BookingKind.fromFlags(isRepeat: isRepeat, isCustomize: isCustomize, isRepeatChild: isRepeatChild),
      placedAt: BookingParse.utcDate(json['created_at']),
      scheduledAt: BookingParse.plainDate(json['service_schedule']),
      rawServiceLocation: BookingParse.string(json['service_location']) ?? '',
      otp: BookingParse.string(json['booking_otp']),
      evidencePhotos: BookingParse.stringList(json['evidence_photos_full_path']),
      services: services,
      billing: BookingBillingTotals.fromJson(json, services: services),
      repeatBilling: RepeatBookingBillingTotals.fromJson(
        json,
        services: services,
        children: BookingParse.objectList<Map<String, dynamic>>(
          json['repeats'],
          (Map<String, dynamic> child) => child,
        ),
        isEdited: editHistory.isNotEmpty,
      ),
      payment: BookingPaymentState.fromJson(json),
      provider: provider,
      serviceman: servicemanJson == null ? null : BookingServicemanModel.fromJson(servicemanJson),
      customer: customer,
      serviceAddress: serviceAddress,
      repeat: repeat,
      editHistory: editHistory,
      timeline: BookingTimelineEntry.listFrom(
        statusHistories: json['status_histories'],
        scheduleHistories: json['schedule_histories'],
        customerName: customer?.fullName.isNotEmpty == true
            ? customer!.fullName : serviceAddress?.contactPersonName ?? '',
        providerCompanyName: provider?.companyName ?? '',
      ),
    );
  }
}
