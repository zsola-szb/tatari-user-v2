import 'package:flutter/material.dart';

class CategoryModel {
  String? id;
  String? slug;
  String? name;
  String? imageFullPath;
  String? description;
  bool? isActive;
  String? createdAt;
  int? serviceCount;
  String? parentId;
  int? position;
  CategoryOfferIcon? iconToShow;
  List<CategoryTranslation>? translations;
  GlobalKey? globalKey;

  CategoryModel(
      {this.id,
        this.slug,
        this.name,
        this.imageFullPath,
        this.description,
        this.isActive,
        this.createdAt,
        this.serviceCount,
        this.parentId,
        this.position,
        this.iconToShow,
        this.translations,
        this.globalKey,
      });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    imageFullPath = json['image_full_path'] ?? json['logo'];
    isActive = json['is_active'] == null ? true : int.tryParse(json['is_active'].toString()) == 1;
    createdAt = json['created_at'];
    serviceCount = int.tryParse((json['services_count'] ?? json['total_services']).toString());
    parentId = json['parent_id'];
    position = int.tryParse(json['position'].toString());
    iconToShow = _offerIconFrom(json['icon_to_show']);
    if (json['translations'] is List) {
      translations = (json['translations'] as List)
          .whereType<Map<String, dynamic>>()
          .map((translation) => CategoryTranslation.fromJson(translation)).toList();
    }
    // The v2 children endpoint drops the top-level `description` field and only sends it inside `translations`.
    description = json['description'] ?? _translationValue(translations, 'description');
    globalKey = GlobalKey(debugLabel: json['id']);
  }

  static String? _translationValue(List<CategoryTranslation>? translations, String key) {
    for (final CategoryTranslation translation in translations ?? const <CategoryTranslation>[]) {
      if (translation.key == key) {
        return translation.value;
      }
    }
    return null;
  }

  static CategoryOfferIcon? _offerIconFrom(dynamic value) {
    switch (value?.toString()) {
      case 'offer': return CategoryOfferIcon.offer;
      case 'coupon': return CategoryOfferIcon.coupon;
      default: return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['image_full_path'] = imageFullPath;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['services_count'] = serviceCount;
    data['parent_id'] = parentId;
    data['position'] = position;
    data['icon_to_show'] = iconToShow?.name;
    return data;
  }
}

enum CategoryOfferIcon { offer, coupon }

class CategoryTranslation {
  int? id;
  String? translationableType;
  String? translationableId;
  String? locale;
  String? key;
  String? value;

  CategoryTranslation({this.id, this.translationableType, this.translationableId, this.locale, this.key, this.value});

  CategoryTranslation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }
}
