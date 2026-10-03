class SubscriptionTermsConditionModel {
  String? responseCode;
  String? message;
  Content? content;
  List<String>? errors;

  SubscriptionTermsConditionModel(
      {this.responseCode, this.message, this.content, this.errors});

  SubscriptionTermsConditionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
    errors = json['errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['errors'] = errors;
    return data;
  }
}

class Content {
  String? id;
  String? pageKey;
  String? title;
  String? content;
  String? image;
  int? isActive;
  int? isDefault;
  String? createdAt;
  String? updatedAt;
  String? imageFullPath;
  List<Translations>? translations;

  Content(
      {this.id,
        this.pageKey,
        this.title,
        this.content,
        this.image,
        this.isActive,
        this.isDefault,
        this.createdAt,
        this.updatedAt,
        this.imageFullPath,
        this.translations});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageKey = json['page_key'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    isActive = json['is_active'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageFullPath = json['image_full_path'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['page_key'] = pageKey;
    data['title'] = title;
    data['content'] = content;
    data['image'] = image;
    data['is_active'] = isActive;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_full_path'] = imageFullPath;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  String? translationableId;
  String? locale;
  String? key;
  String? value;

  Translations(
      {this.id,
        this.translationableType,
        this.translationableId,
        this.locale,
        this.key,
        this.value});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
