import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';

class BookingProviderModel {
  final String id;
  final String userId;
  final String companyName;
  final String? companyPhone;
  final String? companyAddress;
  final String? logoFullPath;
  final double? avgRating;
  final int? ratingCount;
  final bool isVerified;
  final bool canChat;
  final double? latitude;
  final double? longitude;

  const BookingProviderModel({
    this.id = '',
    this.userId = '',
    this.companyName = '',
    this.companyPhone,
    this.companyAddress,
    this.logoFullPath,
    this.avgRating,
    this.ratingCount,
    this.isVerified = false,
    this.canChat = true,
    this.latitude,
    this.longitude,
  });

  factory BookingProviderModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? coordinates = BookingParse.object(json['coordinates']);
    return BookingProviderModel(
      id: BookingParse.string(json['id']) ?? '',
      userId: BookingParse.string(json['user_id']) ?? '',
      companyName: BookingParse.string(json['company_name']) ?? '',
      companyPhone: BookingParse.string(json['company_phone']),
      companyAddress: BookingParse.string(json['company_address']),
      logoFullPath: BookingParse.string(json['logo_full_path']),
      avgRating: BookingParse.doubleOrNull(json['avg_rating']),
      ratingCount: BookingParse.intOrNull(json['rating_count']),
      isVerified: BookingParse.toBool(json['verified_badge']) || BookingParse.toBool(json['is_verified']),
      canChat: json['chatEligibility'] == null || BookingParse.toBool(json['chatEligibility']),
      latitude: BookingParse.doubleOrNull(coordinates?['latitude']),
      longitude: BookingParse.doubleOrNull(coordinates?['longitude']),
    );
  }

  bool get hasRating => avgRating != null && avgRating! > 0;

  bool get hasPhone => (companyPhone ?? '').isNotEmpty;

  bool get hasCoordinates => latitude != null && longitude != null;
}

class BookingPersonModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImageFullPath;
  final String? userType;

  const BookingPersonModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.phone,
    this.profileImageFullPath,
    this.userType,
  });

  factory BookingPersonModel.fromJson(Map<String, dynamic> json) => BookingPersonModel(
        id: BookingParse.string(json['id']) ?? '',
        firstName: BookingParse.string(json['first_name']) ?? '',
        lastName: BookingParse.string(json['last_name']) ?? '',
        phone: BookingParse.string(json['phone']),
        profileImageFullPath: BookingParse.string(json['profile_image_full_path']),
        userType: BookingParse.string(json['user_type']),
      );

  String get fullName => '$firstName $lastName'.trim();

  bool get hasPhone => (phone ?? '').isNotEmpty;

  bool get isProviderAdmin => userType == 'provider-admin';
}

class BookingServicemanModel {
  final String id;
  final String userId;
  final BookingPersonModel user;

  const BookingServicemanModel({this.id = '', this.userId = '', this.user = const BookingPersonModel()});

  factory BookingServicemanModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? user = BookingParse.object(json['user']);
    return BookingServicemanModel(
      id: BookingParse.string(json['id']) ?? '',
      userId: BookingParse.string(json['user_id']) ?? '',
      user: user == null ? const BookingPersonModel() : BookingPersonModel.fromJson(user),
    );
  }

  bool get hasName => user.fullName.isNotEmpty;
}

class BookingAddressModel {
  final String? address;
  final String? addressLabel;
  final String? contactPersonName;
  final String? contactPersonNumber;
  final double? latitude;
  final double? longitude;

  const BookingAddressModel({
    this.address,
    this.addressLabel,
    this.contactPersonName,
    this.contactPersonNumber,
    this.latitude,
    this.longitude,
  });

  factory BookingAddressModel.fromJson(Map<String, dynamic> json) => BookingAddressModel(
        address: BookingParse.string(json['address']),
        addressLabel: BookingParse.string(json['address_label']),
        contactPersonName: BookingParse.string(json['contact_person_name']),
        contactPersonNumber: BookingParse.string(json['contact_person_number']),
        latitude: BookingParse.doubleOrNull(json['lat']),
        longitude: BookingParse.doubleOrNull(json['lon']),
      );

  bool get hasAddress => (address ?? '').isNotEmpty;
}
