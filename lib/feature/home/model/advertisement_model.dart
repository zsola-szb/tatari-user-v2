import 'package:tatarigigs_user/feature/provider/model/provider_model.dart';

class AdvertisementModel {
  String? responseCode;
  String? message;
  AdvertisementContent? content;

  AdvertisementModel({this.responseCode, this.message, this.content});

  AdvertisementModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? AdvertisementContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class AdvertisementContent {
  List<Advertisement>? data;

  AdvertisementContent({this.data});

  AdvertisementContent.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Advertisement>[];
      json['data'].forEach((v) {
        data!.add(Advertisement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advertisement {
  String? id;
  String? readableId;
  String? title;
  String? description;
  String? providerId;
  String? type;
  String? promotionalVideo;
  String? promotionalVideoFullPath;
  String? providerCoverImageFullPath;
  String? providerProfileImageFullPath;
  bool showReview;
  bool showRating;
  ProviderData? providerData;

  Advertisement(
      {this.id,
        this.readableId,
        this.title,
        this.description,
        this.providerId,
        this.type,
        this.promotionalVideo,
        this.promotionalVideoFullPath,
        this.providerCoverImageFullPath,
        this.providerProfileImageFullPath,
        this.showReview = false,
        this.showRating = false,
        this.providerData
      });

  Advertisement.fromJson(Map<String, dynamic> json)
      : showReview = _isEnabled(json['show_review']),
        showRating = _isEnabled(json['show_rating']) {
    id = json['id'];
    readableId = json['readable_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    promotionalVideo = json['promotional_video'];
    promotionalVideoFullPath = json['promotional_video_full_path'];
    providerCoverImageFullPath = json['provider_cover_image_full_path'];
    providerProfileImageFullPath = json['provider_profile_image_full_path'];
    providerData = json['provider'] != null ? ProviderData.fromJson(json['provider']) : null;
    providerId = json['provider_id'] ?? providerData?.id;
  }

  static bool _isEnabled(dynamic value) {
    if (value is bool) {
      return value;
    }
    final String text = '$value'.toLowerCase();
    return text == '1' || text == 'true';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['readable_id'] = readableId;
    data['title'] = title;
    data['description'] = description;
    data['provider_id'] = providerId;
    data['type'] = type;
    data['promotional_video'] = promotionalVideo;
    data['promotional_video_full_path'] = promotionalVideoFullPath;
    data['provider_cover_image_full_path'] = providerCoverImageFullPath;
    data['provider_profile_image_full_path'] = providerProfileImageFullPath;
    data['show_review'] = showReview ? 1 : 0;
    data['show_rating'] = showRating ? 1 : 0;
    if (providerData != null) {
      data['provider'] = providerData!.toJson();
    }
    return data;
  }
}

