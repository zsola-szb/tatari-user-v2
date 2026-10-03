import 'package:tatarigigs_user/common/models/config_model.dart';
import 'package:tatarigigs_user/feature/service/model/service_list_model.dart';
import 'package:tatarigigs_user/feature/service/model/service_model.dart';

enum SearchResultType { all, services, providers }

class SearchResultModel {
  String? responseCode;
  String? message;
  int? totalSize;
  int? limit;
  int? offset;
  Data? data;
  List<String>? errors;
  double? filterMinPrice;
  double? filterMaxPrice;
  double? initialMinPrice;
  double? initialMaxPrice;
  bool hasMoreServices;
  bool hasMoreProviders;

  SearchResultModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        this.errors,
        this.filterMinPrice,
        this.filterMaxPrice,
        this.initialMinPrice,
        this.initialMaxPrice,
        this.hasMoreServices = false,
        this.hasMoreProviders = false});

  SearchResultModel.fromJson(Map<String, dynamic> json, {SearchResultType type = SearchResultType.all})
      : hasMoreServices = _hasMoreFrom(json, 'has_more_services'),
        hasMoreProviders = _hasMoreFrom(json, 'has_more_providers') {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = int.tryParse('${json['total_size']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    data = json['data'] != null ? Data.fromJson(json['data'], type: type) : null;
    errors = (json['errors'] as List<dynamic>?)?.map((dynamic error) => error.toString()).toList();
    filterMinPrice = double.tryParse('${json['filter_min_price']}');
    filterMaxPrice = double.tryParse('${json['filter_max_price']}');
    initialMinPrice = double.tryParse("${json['initial_min_price']}");
    initialMaxPrice = double.tryParse("${json['initial_max_price']}");
  }

  static bool _hasMoreFrom(Map<String, dynamic> json, String key) {
    final Map<String, dynamic>? data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null;
    final dynamic value = json[key] ?? data?[key];

    return value == 1 || value == true || value == '1';
  }

}

class Data {
  List<Service>? services;
  List<Providers>? providers;
  List<CategoriesList>? categories;
  Data({this.services, this.providers, this.categories});


  Data.fromJson(dynamic data, {SearchResultType type = SearchResultType.all}) {
    final List<dynamic>? paginatedItems = data is List<dynamic> ? data
        : (data is Map<String, dynamic> && data['data'] is List<dynamic> ? data['data'] as List<dynamic> : null);

    if (paginatedItems != null) {
      final Iterable<Map<String, dynamic>> rows = paginatedItems.whereType<Map<String, dynamic>>();
      if (type == SearchResultType.providers) {
        providers = rows.map((Map<String, dynamic> v) => Providers.fromJson(v)).toList();
      } else {
        services = rows.map((Map<String, dynamic> v) => ServiceItemModel.fromJson(v).toService()).toList();
      }
      return;
    }

    if (data is! Map<String, dynamic>) {
      return;
    }
    final Map<String, dynamic> json = data;

    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(ServiceItemModel.fromJson(v).toService());
      });
    }
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(Providers.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <CategoriesList>[];
      json['categories'].forEach((v) {
        categories!.add(CategoriesList.fromJson(v));
      });
    }
  }

}

class Category {
  String? id;
  String? parentId;
  String? name;
  String? slug;
  String? image;
  int? position;
  String? description;
  int? isActive;
  int? isFeatured;
  String? createdAt;
  String? updatedAt;
  String? imageFullPath;
  List<CategoryDiscount>? categoryDiscount;
  List<ServiceDiscount>? campaignDiscount;
  List<Translations>? translations;

  Category(
      {this.id,
        this.parentId,
        this.name,
        this.slug,
        this.image,
        this.position,
        this.description,
        this.isActive,
        this.isFeatured,
        this.createdAt,
        this.updatedAt,
        this.imageFullPath,
        this.categoryDiscount,
        this.campaignDiscount,
        this.translations});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    position = json['position'];
    description = json['description'];
    isActive = json['is_active'];
    isFeatured = json['is_featured'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageFullPath = json['image_full_path'];
    if (json['category_discount'] != null) {
      categoryDiscount = <CategoryDiscount>[];
      json['category_discount'].forEach((v) {
        categoryDiscount!.add(CategoryDiscount.fromJson(v));
      });
    }
    if (json['campaign_discount'] != null) {
      campaignDiscount = <ServiceDiscount>[];
      json['campaign_discount'].forEach((v) {
        campaignDiscount!.add(ServiceDiscount.fromJson(v));
      });
    }
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }
}

class CategoryDiscount {
  int? id;
  String? discountId;
  String? discountType;
  String? typeWiseId;
  String? createdAt;
  String? updatedAt;
  Discount? discount;

  CategoryDiscount(
      {this.id,
        this.discountId,
        this.discountType,
        this.typeWiseId,
        this.createdAt,
        this.updatedAt,
        this.discount});

  CategoryDiscount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountId = json['discount_id'];
    discountType = json['discount_type'];
    typeWiseId = json['type_wise_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
  }
}

class Discount {
  String? id;
  String? discountTitle;
  String? discountType;
  int? discountAmount;
  String? discountAmountType;
  double? minDiscountPercent;
  double? maxDiscountPercent;
  int? minPurchase;
  int? maxDiscountAmount;
  int? limitPerUser;
  String? promotionType;
  int? isActive;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  Discount(
      {this.id,
        this.discountTitle,
        this.discountType,
        this.discountAmount,
        this.discountAmountType,
        this.minDiscountPercent,
        this.maxDiscountPercent,
        this.minPurchase,
        this.maxDiscountAmount,
        this.limitPerUser,
        this.promotionType,
        this.isActive,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt,
      });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountTitle = json['discount_title'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    discountAmountType = json['discount_amount_type'];
    minDiscountPercent = json['min_discount_percent'];
    maxDiscountPercent = json['max_discount_percent'];
    minPurchase = json['min_purchase'];
    maxDiscountAmount = json['max_discount_amount'];
    limitPerUser = json['limit_per_user'];
    promotionType = json['promotion_type'];
    isActive = json['is_active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

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
}

class VariationsAppFormat {
  String? zoneId;
  int? defaultPrice;
  List<ZoneWiseVariations>? zoneWiseVariations;

  VariationsAppFormat(
      {this.zoneId, this.defaultPrice, this.zoneWiseVariations});

  VariationsAppFormat.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    defaultPrice = json['default_price'];
    if (json['zone_wise_variations'] != null) {
      zoneWiseVariations = <ZoneWiseVariations>[];
      json['zone_wise_variations'].forEach((v) {
        zoneWiseVariations!.add(ZoneWiseVariations.fromJson(v));
      });
    }
  }
}

class ZoneWiseVariations {
  String? variantKey;
  String? variantName;
  int? price;

  ZoneWiseVariations({this.variantKey, this.variantName, this.price});

  ZoneWiseVariations.fromJson(Map<String, dynamic> json) {
    variantKey = json['variant_key'];
    variantName = json['variant_name'];
    price = json['price'];
  }
}

class Variations {
  int? id;
  String? variant;
  String? variantKey;
  String? serviceId;
  String? zoneId;
  int? price;
  String? createdAt;
  String? updatedAt;
  Zone? zone;

  Variations(
      {this.id,
        this.variant,
        this.variantKey,
        this.serviceId,
        this.zoneId,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.zone});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variant = json['variant'];
    variantKey = json['variant_key'];
    serviceId = json['service_id'];
    zoneId = json['zone_id'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zone = json['zone'] != null ? Zone.fromJson(json['zone']) : null;
  }
}

class Zone {
  String? id;
  String? name;
  List<Translations>? translations;

  Zone({this.id, this.name, this.translations});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }
}

class Providers {
  String? id;
  String? name;
  int? isVerified;
  int? verifiedBadge;
  double? rating;
  int? ratingCount;
  List<Categories>? categories;
  Coordinates? coordinates;
  int? isAdvertisementOngoing;
  int? totalCompletedServices;
  int? isAvailable;
  int? isFavorite;
  String? providerImage;
  String? coverImage;
  int? serviceAvailability;

  Providers(
      {this.id,
        this.name,
        this.isVerified,
        this.verifiedBadge,
        this.rating,
        this.ratingCount,
        this.categories,
        this.coordinates,
        this.isAdvertisementOngoing,
        this.totalCompletedServices,
        this.isAvailable,
        this.isFavorite,
        this.coverImage,
        this.providerImage,
        this.serviceAvailability
      });

  Providers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isVerified = json['is_verified'];
    verifiedBadge = json['verified_badge'];
    rating = double.tryParse('${json['rating']}');
    ratingCount = json['rating_count'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    isAdvertisementOngoing = json['is_advertisement_ongoing'];
    totalCompletedServices = json['total_completed_services'];
    isAvailable = json['is_available'];
    isFavorite = json['is_favorite'];
    coverImage = json['cover_image_full_path'];
    providerImage = json['logo_full_path'];
    serviceAvailability = int.tryParse('${json['service_availability']}');
  }
}

class Categories {
  String? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class CategoriesList {
  String? id;
  String? name;
  String? slug;
  String? logo;
  int? totalServices;

  CategoriesList({this.id, this.name, this.slug, this.logo, this.totalServices});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    totalServices = json['total_services'];
  }
}
