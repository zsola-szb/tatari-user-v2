import 'package:tatarigigs_user/util/core_export.dart';

class PostModel {
  String? responseCode;
  String? message;
  int? allCount;
  int? pendingCount;
  int? acceptedCount;
  int? canceledCount;
  int? totalSize;
  int? limit;
  int? offset;
  List<MyPostData>? data;
  List<dynamic>? errors;

  PostModel({
    this.responseCode,
    this.message,
    this.allCount,
    this.pendingCount,
    this.acceptedCount,
    this.canceledCount,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    allCount = int.tryParse(json['all_count'].toString());
    pendingCount = int.tryParse(json['pending_count'].toString());
    acceptedCount = int.tryParse(json['accepted_count'].toString());
    canceledCount = int.tryParse(json['canceled_count'].toString());
    totalSize = int.tryParse(json['total_size'].toString());
    limit = int.tryParse(json['limit'].toString());
    offset = int.tryParse(json['offset'].toString());
    if (json['data'] != null) {
      data = <MyPostData>[];
      json['data'].forEach((v) {
        data!.add(MyPostData.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = List<dynamic>.from(json['errors']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['response_code'] = responseCode;
    map['message'] = message;
    map['all_count'] = allCount;
    map['pending_count'] = pendingCount;
    map['accepted_count'] = acceptedCount;
    map['canceled_count'] = canceledCount;
    map['total_size'] = totalSize;
    map['limit'] = limit;
    map['offset'] = offset;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }
}

class PostProvider {
  String? id;
  String? name;
  String? image;

  PostProvider({this.id, this.name, this.image});

  PostProvider.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name, 'image': image};
  }
}

class MyPostData {
  String? id;
  String? serviceName;
  String? serviceImage;
  String? categoryName;
  String? categoryImage;
  String? subCategoryName;
  double? offerPrice;
  String? bookingId;
  String? bookingReadableId;
  int? isBooked;
  int? isChecked;
  int? isCanceled;
  String? cancelNote;
  List<PostProvider>? providers;
  String? createdAt;

  MyPostData({
    this.id,
    this.serviceName,
    this.serviceImage,
    this.categoryName,
    this.categoryImage,
    this.subCategoryName,
    this.offerPrice,
    this.bookingId,
    this.isBooked,
    this.isChecked,
    this.isCanceled,
    this.cancelNote,
    this.providers,
    this.createdAt,
    this.bookingReadableId
  });

  MyPostData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    serviceName = json['service_name'];
    serviceImage = json['service_image'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    subCategoryName = json['sub_category_name'];
    offerPrice = double.tryParse(json['offer_price'].toString());
    bookingId = json['booking_id']?.toString();
    bookingReadableId = json['booking_readable_id']?.toString();
    isBooked = int.tryParse(json['is_booked'].toString());
    isChecked = int.tryParse(json['is_checked'].toString());
    isCanceled = int.tryParse(json['is_canceled'].toString());
    cancelNote = json['cancel_note'];
    if (json['providers'] != null) {
      providers = <PostProvider>[];
      json['providers'].forEach((v) {
        providers!.add(PostProvider.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['service_image'] = serviceImage;
    data['category_name'] = categoryName;
    data['category_image'] = categoryImage;
    data['sub_category_name'] = subCategoryName;
    data['offer_price'] = offerPrice;
    data['booking_id'] = bookingId;
    data['booking_readable_id'] = bookingReadableId;
    data['is_booked'] = isBooked;
    data['is_checked'] = isChecked;
    data['is_canceled'] = isCanceled;
    data['cancel_note'] = cancelNote;
    if (providers != null) {
      data['providers'] = providers!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

/// Full details for a single post, fetched on demand via
/// `GET /api/v2/customer/post/details/{postId}` for the post-details and
/// edit-request screens — the list endpoint above only returns a summary.
class PostFullDetails {
  String? id;
  String? serviceDescription;
  String? bookingSchedule;
  int? isBooked;
  int? isCanceled;
  String? cancelNote;
  String? serviceId;
  String? categoryId;
  String? subCategoryId;
  String? zoneId;
  String? serviceName;
  String? serviceImage;
  String? categoryName;
  String? categoryImage;
  String? subCategoryName;
  String? subCategoryImage;
  String? serviceAddressId;
  AddressModel? serviceAddressLocation;
  String? serviceAddress;
  String? contactPersonName;
  String? contactPersonNumber;
  String? bookingId;
  int? bookingReadableId;
  int? bidsCount;
  List<AdditionInstructions>? additionInstructions;

  PostFullDetails({
    this.id,
    this.serviceDescription,
    this.bookingSchedule,
    this.isBooked,
    this.isCanceled,
    this.cancelNote,
    this.serviceId,
    this.categoryId,
    this.subCategoryId,
    this.zoneId,
    this.serviceName,
    this.serviceImage,
    this.categoryName,
    this.categoryImage,
    this.subCategoryName,
    this.subCategoryImage,
    this.serviceAddressId,
    this.serviceAddressLocation,
    this.serviceAddress,
    this.contactPersonName,
    this.contactPersonNumber,
    this.bookingId,
    this.bookingReadableId,
    this.bidsCount,
    this.additionInstructions,
  });

  PostFullDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    serviceDescription = json['service_description'];
    bookingSchedule = json['booking_schedule'];
    isBooked = int.tryParse(json['is_booked'].toString());
    isCanceled = int.tryParse(json['is_canceled'].toString());
    cancelNote = json['cancel_note'];
    serviceId = json['service_id']?.toString();
    categoryId = json['category_id']?.toString();
    subCategoryId = json['sub_category_id']?.toString();
    zoneId = json['zone_id']?.toString();
    serviceName = json['service_name'];
    serviceImage = json['service_image'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
    subCategoryName = json['sub_category_name'];
    subCategoryImage = json['sub_category_image'];
    serviceAddressId = json['service_address_id']?.toString();

    final dynamic addressJson = json['service_address_location'];
    if (addressJson is Map<String, dynamic>) {
      serviceAddressLocation = AddressModel.fromJson(addressJson);
    }

    serviceAddress = json['service_address'];
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    bookingId = json['booking_id']?.toString();
    bookingReadableId = int.tryParse(json['booking_readable_id'].toString());
    bidsCount = int.tryParse(json['bids_count'].toString());

    final dynamic instructions = json['addition_instructions'];
    if (instructions is List) {
      additionInstructions = instructions.whereType<Map<String, dynamic>>().map(AdditionInstructions.fromJson).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_description'] = serviceDescription;
    data['booking_schedule'] = bookingSchedule;
    data['is_booked'] = isBooked;
    data['is_canceled'] = isCanceled;
    data['cancel_note'] = cancelNote;
    data['service_id'] = serviceId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['zone_id'] = zoneId;
    data['service_name'] = serviceName;
    data['service_image'] = serviceImage;
    data['category_name'] = categoryName;
    data['category_image'] = categoryImage;
    data['sub_category_name'] = subCategoryName;
    data['sub_category_image'] = subCategoryImage;
    data['service_address_id'] = serviceAddressId;
    if (serviceAddressLocation != null) {
      data['service_address_location'] = serviceAddressLocation!.toJson();
    }
    data['service_address'] = serviceAddress;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['booking_id'] = bookingId;
    data['booking_readable_id'] = bookingReadableId;
    data['bids_count'] = bidsCount;
    if (additionInstructions != null) {
      data['addition_instructions'] = additionInstructions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionInstructions {
  String? id;
  String? details;
  String? postId;
  String? createdAt;
  String? updatedAt;

  AdditionInstructions(
      {this.id, this.details, this.postId, this.createdAt, this.updatedAt});

  AdditionInstructions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    details = json['details'];
    postId = json['post_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['details'] = details;
    data['post_id'] = postId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
