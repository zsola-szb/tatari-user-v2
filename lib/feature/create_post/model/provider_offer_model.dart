import 'package:tatarigigs_user/feature/provider/model/provider_model.dart';

class ProviderOfferModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  List<ProviderOfferData>? data;
  List<dynamic>? errors;

  ProviderOfferModel({
    this.responseCode,
    this.message,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
    this.errors,
  });

  ProviderOfferModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = int.tryParse(json['total_size'].toString());
    limit = int.tryParse(json['limit'].toString());
    offset = int.tryParse(json['offset'].toString());
    if (json['data'] != null) {
      data = <ProviderOfferData>[];
      json['data'].forEach((v) {
        data!.add(ProviderOfferData.fromJson(v));
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

class ProviderOfferData {
  String? id;
  String? offeredPrice;
  String? providerNote;
  String? status;
  String? postId;
  String? providerId;
  String? createdAt;
  String? updatedAt;
  bool? nextBookingEligibility;
  bool? scheduleBookingEligibility;
  ProviderData ? provider;

  ProviderOfferData(
      {this.id,
        this.offeredPrice,
        this.providerNote,
        this.status,
        this.postId,
        this.providerId,
        this.createdAt,
        this.updatedAt,
        this.nextBookingEligibility,
        this.scheduleBookingEligibility,
        this.provider});

  ProviderOfferData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offeredPrice = json['offered_price'];
    providerNote = json['provider_note'];
    status = json['status'];
    postId = json['post_id'];
    providerId = json['provider_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nextBookingEligibility = json['nextBookingEligibility'];
    scheduleBookingEligibility = json['scheduleBookingEligibility'];
    provider = json['provider'] != null
        ? ProviderData.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['offered_price'] = offeredPrice;
    data['provider_note'] = providerNote;
    data['status'] = status;
    data['post_id'] = postId;
    data['provider_id'] = providerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['nextBookingEligibility'] = nextBookingEligibility;
    data['scheduleBookingEligibility'] = scheduleBookingEligibility;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}
