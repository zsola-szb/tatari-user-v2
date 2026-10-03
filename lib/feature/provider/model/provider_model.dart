import 'package:tatarigigs_user/util/core_export.dart';

class ProviderModel {
  ProviderContent? content;
  ProviderModel({this.content});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    content = ProviderContent.fromJson(
      json['content'] is Map<String, dynamic> ? json['content'] as Map<String, dynamic> : json,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final ProviderContent? content = this.content;
    if (content != null) {
      data['content'] = content.toJson();
    }
    return data;
  }
}

class ProviderContent {
  int? currentPage;
  List<ProviderData>? data;
  String? path;
  int? total;
  int? perPage;

  ProviderContent({this.currentPage, this.data, this.path, this.total, this.perPage});

  ProviderContent.fromJson(Map<String, dynamic> json) {
    currentPage = BookingParse.intOrNull(json['current_page'] ?? json['offset']);
    perPage = BookingParse.intOrNull(json['per_page'] ?? json['limit']);
    total = BookingParse.intOrNull(json['total'] ?? json['total_size']);
    path = BookingParse.string(json['path']);
    data = json['data'] is List
        ? (json['data'] as List).whereType<Map<String, dynamic>>().map((Map<String, dynamic> provider) => ProviderData.fromJson(provider)).toList()
        : <ProviderData>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['data'] = this.data?.map((ProviderData provider) => provider.toJson()).toList();
    data['path'] = path;
    data['total'] = total;
    data['per_page'] = perPage;
    return data;
  }
}

class ProviderData {
  String? id;
  String? userId;
  String? name;
  String? phone;
  String? address;
  String? logo;
  String? logoFullPath;
  String? coverImageFullPath;
  String? contactPersonName;
  String? contactPersonPhone;
  int? ratingCount;
  double? rating;
  int? isActive;
  int? isFavorite;
  String? createdAt;
  String? updatedAt;
  bool? isAvailable;
  bool? nextBookingEligibility;
  bool? scheduleBookingEligibility;
  bool? chatEligibility;
  List<String>? weekends;
  List<String>? serviceLocations;
  TimeSchedule? timeSchedule;
  int? totalCompletedServices;
  Coordinates? coordinates;
  bool? isVerified;
  int? serviceCount;
  bool? isCertificationAndLicenseAvailable;
  List<String> categoryNames;
  double? distance;
  int? serviceAvailability;
  List<String>? serviceImages;

  ProviderData({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.address,
    this.logo,
    this.logoFullPath,
    this.coverImageFullPath,
    this.contactPersonName,
    this.contactPersonPhone,
    this.ratingCount,
    this.rating,
    this.isActive,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
    this.isAvailable,
    this.nextBookingEligibility,
    this.scheduleBookingEligibility,
    this.chatEligibility,
    this.weekends,
    this.serviceLocations,
    this.timeSchedule,
    this.totalCompletedServices,
    this.coordinates,
    this.isVerified,
    this.serviceCount,
    this.isCertificationAndLicenseAvailable,
    this.categoryNames = const <String>[],
    this.distance,
    this.serviceAvailability,
    this.serviceImages
  });

  ProviderData.fromJson(Map<String, dynamic> json) : categoryNames = _categoryNamesOf(json) {
    final Map<String, dynamic>? availability =
        json['availability'] is Map<String, dynamic> ? json['availability'] as Map<String, dynamic> : null;
    final dynamic schedule = json['time_schedule'] ?? availability;
    final dynamic active = json['is_active'] ?? json['is_available'];

    id = BookingParse.string(json['id']);
    userId = BookingParse.string(json['user_id']);
    name = BookingParse.string(json['name'] ?? json['company_name']);
    phone = BookingParse.string(json['phone'] ?? json['company_phone']);
    address = BookingParse.string(json['address'] ?? json['company_address']);
    logo = BookingParse.string(json['logo']);
    logoFullPath = BookingParse.string(json['logo_full_path']);
    coverImageFullPath = BookingParse.string(json['cover_image_full_path']) ?? '';
    contactPersonName = BookingParse.string(json['contact_person_name']);
    contactPersonPhone = BookingParse.string(json['contact_person_phone']) ?? BookingParse.string(json['phone']);
    ratingCount = BookingParse.intOrNull(json['rating_count']);
    rating = BookingParse.doubleOrNull(json['rating'] ?? json['avg_rating']);
    isActive = active == null ? null : (BookingParse.toBool(active) ? 1 : 0);
    isFavorite = BookingParse.intOrNull(json['is_favorite']);
    createdAt = BookingParse.string(json['created_at']);
    updatedAt = BookingParse.string(json['updated_at']);
    isAvailable = _boolOrNull(json['is_available'] ?? json['service_availability']);
    nextBookingEligibility = _boolOrNull(json['nextBookingEligibility']);
    scheduleBookingEligibility = _boolOrNull(json['scheduleBookingEligibility']);
    chatEligibility = _boolOrNull(json['chatEligibility']);
    weekends = _lowercaseListOf(json['weekends'] ?? availability?['weekends']);
    serviceLocations = _lowercaseListOf(json['service_locations']);
    timeSchedule = schedule is Map<String, dynamic> ? TimeSchedule.fromJson(schedule) : null;
    totalCompletedServices =
        BookingParse.intOrNull(json['total_completed_services'] ?? json['total_service_served']);
    coordinates = json['coordinates'] is Map<String, dynamic>
        ? Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>) : null;
    isVerified = _boolOrNull(json['is_verified'] ?? json['verified_badge']);
    serviceCount = BookingParse.intOrNull(json['service_count']);
    isCertificationAndLicenseAvailable = _boolOrNull(json['is_certification_and_license_available']);
    serviceAvailability = int.tryParse('${json['service_availability']}');
    serviceImages = _stringListOf(json['service_images']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['logo'] = logo;
    data['logo_full_path'] = logoFullPath;
    data['cover_image_full_path'] = coverImageFullPath;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_phone'] = contactPersonPhone;
    data['rating_count'] = ratingCount;
    data['rating'] = rating;
    data['is_active'] = isActive;
    data['is_favorite'] = isFavorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_available'] = isAvailable;
    data['nextBookingEligibility'] = nextBookingEligibility;
    data['scheduleBookingEligibility'] = scheduleBookingEligibility;
    data['chatEligibility'] = chatEligibility;
    data['weekends'] = weekends;
    data['service_locations'] = serviceLocations;
    data['time_schedule'] = timeSchedule?.toJson();
    data['total_completed_services'] = totalCompletedServices;
    data['coordinates'] = coordinates?.toJson();
    data['is_verified'] = isVerified;
    data['service_count'] = serviceCount;
    data['service_availability'] = serviceAvailability;
    data['is_certification_and_license_available'] = isCertificationAndLicenseAvailable;
    data['categories'] = categoryNames.map((String name) => <String, dynamic>{'name': name}).toList();
    data['service_images'] = serviceImages;
    return data;
  }

  static List<String> _categoryNamesOf(Map<String, dynamic> json) {
    final dynamic categories = json['categories'];
    if (categories is List) {
      return categories
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> category) => BookingParse.string(category['name']))
          .whereType<String>()
          .toList();
    }

    final dynamic subscribedServices = json['subscribed_services'];
    if (subscribedServices is List) {
      return subscribedServices
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> subscribedService) => subscribedService['sub_category'])
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> subCategory) => BookingParse.string(subCategory['name']))
          .whereType<String>()
          .toList();
    }

    return <String>[];
  }

  static bool? _boolOrNull(dynamic value) => value == null ? null : BookingParse.toBool(value);

  static List<String> _lowercaseListOf(dynamic value) => value is List
      ? value.map((dynamic entry) => '$entry'.toLowerCase()).toList() : <String>[];

  static List<String> _stringListOf(dynamic value) => value is List
      ? value.whereType<String>().toList() : <String>[];
}
