import 'package:tatarigigs_user/util/core_export.dart';

class ServiceModel {
  String? responseCode;
  String? message;
  ServiceContent? content;


  ServiceModel({this.responseCode, this.message, this.content});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    final Map<String, dynamic>? contentJson = PaginatedEnvelope.resolve(json);
    content = contentJson != null ? ServiceContent.fromJson(contentJson) : null;
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

class ServiceContent {
  int? currentPage;
  List<Service>? serviceList;
  int? from;
  int? lastPage;
  int? total;

  ServiceContent({
    this.currentPage,
    this.serviceList,
    this.from,
    this.lastPage,
    this.total,
  });

  ServiceContent.fromJson(Map<String, dynamic> json) {
    final PaginatedEnvelope envelope = PaginatedEnvelope.fromJson(json);
    currentPage = envelope.currentPage;
    from = envelope.from;
    lastPage = envelope.lastPage;
    total = envelope.total;
    serviceList = envelope.rows
        .whereType<Map<String, dynamic>>()
        .map((Map<String, dynamic> row) => Service.fromJson(row))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (serviceList != null) {
      data['data'] = serviceList!.map((v) => v.toJson()).toList();
    }
    data['from'] = from;
    data['last_page'] = lastPage;
    data['total'] = total;
    return data;
  }
}

class Service {
  String? id;
  String? slug;
  String? name;
  String? shortDescription;
  String? description;
  String? coverImage;
  String? coverImageFullPath;
  String? thumbnail;
  String? thumbnailFullPath;
  String? categoryId;
  String? subCategoryId;
  double? tax;
  int? orderCount;
  int? isActive;
  int? isFavorite;
  int? ratingCount;
  double? avgRating;
  String? createdAt;
  String? updatedAt;
  ServiceCategory? category;
  ServiceCategory? subCategory;
  VariationsAppFormat? variationsAppFormat;
  List<Variations>? variations;
  List<Faqs>? faqs;
  List<Review>? review;
  List<ServiceProvider> providers;
  String? maximumDiscount;
  double? lowestPrice;
  double? discountedLowestPrice;

  ServiceProvider? get firstProvider => providers.isEmpty ? null : providers.first;
  String? get providerId => firstProvider?.id;
  String? get providerName => firstProvider?.name;
  String? get providerImage => firstProvider?.image;

  Service(
      {this.id,
        this.slug,
        this.name,
        this.shortDescription,
        this.description,
        this.coverImage,
        this.coverImageFullPath,
        this.thumbnail,
        this.thumbnailFullPath,
        this.categoryId,
        this.subCategoryId,
        this.tax,
        this.orderCount,
        this.isActive,
        this.isFavorite,
        this.ratingCount,
        this.avgRating,
        this.createdAt,
        this.updatedAt,
        this.category,
        this.subCategory,
        this.variationsAppFormat,
        this.variations,
        this.faqs,
        this.review,
        this.providers = const <ServiceProvider>[],
        this.discountedLowestPrice,
        this.lowestPrice,
        this.maximumDiscount
      });

  Service.fromJson(Map<String, dynamic> json) : providers = ServiceProvider.listFrom(json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    shortDescription = json['short_description'];
    description = json['description'];
    coverImage = json['cover_image'];
    coverImageFullPath = json['cover_image_full_path'];
    thumbnail = json['thumbnail'];
    thumbnailFullPath = json['thumbnail_full_path'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    tax = double.tryParse(json['tax'].toString());
    orderCount = json['order_count'];
    isActive = json['is_active'];
    isFavorite = json['is_favorite'];
    ratingCount = json['rating_count'];
    avgRating = double.tryParse(json['avg_rating'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    variationsAppFormat = json['variations_app_format'] != null
        ? VariationsAppFormat.fromJson(json['variations_app_format']) : null;

    if (json['variations'] != null) {
      variations = <Variations>[];
      json['variations'].forEach((v) {
        variations!.add(Variations.fromJson(v));
      });
    }

    if (json['reviews'] != null) {
      review = <Review>[];
      json['reviews'].forEach((v) {
        review!.add(Review.fromJson(v));
      });
    }

    category = json['category'] != null
        ? ServiceCategory.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? ServiceCategory.fromJson(json['sub_category'])
        : null;
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromJson(v));
      });
    }
    discountedLowestPrice = double.tryParse('${json['lowest_discounted_price']}');
    lowestPrice = double.tryParse('${json['lowest_price']}');
    maximumDiscount = json['maximum_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['cover_image'] = coverImage;
    data['cover_image_full_path'] = coverImageFullPath;
    data['thumbnail'] = thumbnail;
    data['thumbnail_full_path'] = thumbnailFullPath;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['tax'] = tax;
    data['order_count'] = orderCount;
    data['is_active'] = isActive;
    data['is_favorite'] = isFavorite;
    data['rating_count'] = ratingCount;
    data['avg_rating'] = avgRating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['providers'] = providers.map((ServiceProvider v) => v.toJson()).toList();
    if (variationsAppFormat != null) {
      data['variations_app_format'] = variationsAppFormat!.toJson();
    }

    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (review != null) {
      data['reviews'] = review!.map((v) => v.toJson()).toList();
    }

    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceProvider {
  final String? id;
  final String? name;
  final String? image;

  const ServiceProvider({this.id, this.name, this.image});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
        id: json['id']?.toString(),
        name: json['name'] ?? json['company_name'],
        image: json['image'] ?? json['logo_full_path'],
      );


  static List<ServiceProvider> listFrom(Map<String, dynamic> json) {
    if (json['providers'] is List) {
      return (json['providers'] as List<dynamic>).whereType<Map<String, dynamic>>().map(ServiceProvider.fromJson).toList();
    }

    final dynamic nested = json['service_provider'] is Map<String, dynamic>
        ? json['service_provider']['provider'] : null;
    if (nested is Map<String, dynamic>) {
      return <ServiceProvider>[ServiceProvider.fromJson(nested)];
    }

    if (json['provider_id'] != null || json['provider_name'] != null) {
      return <ServiceProvider>[ServiceProvider(
        id: json['provider_id']?.toString(),
        name: json['provider_name'],
        image: json['provider_image'],
      )];
    }

    return const <ServiceProvider>[];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name, 'image': image};
}

class VariationsAppFormat {
  String? zoneId;
  double? defaultPrice;
  List<ZoneWiseVariations>? zoneWiseVariations;

  VariationsAppFormat(
      {this.zoneId, this.defaultPrice, this.zoneWiseVariations});

  VariationsAppFormat.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    defaultPrice = double.tryParse('${json['default_price']}');
    if (json['zone_wise_variations'] != null) {
      zoneWiseVariations = <ZoneWiseVariations>[];
      json['zone_wise_variations'].forEach((v) {
        zoneWiseVariations!.add(ZoneWiseVariations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['zone_id'] = zoneId;
    data['default_price'] = defaultPrice;
    if (zoneWiseVariations != null) {
      data['zone_wise_variations'] =
          zoneWiseVariations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variations {
  int? id;
  String? variant;
  String? variantKey;
  String? serviceId;
  String? zoneId;
  num? price;
  String? createdAt;
  double? discountedPrice;


  Variations(
      {this.id,
        this.variant,
        this.variantKey,
        this.serviceId,
        this.zoneId,
        this.price,
        this.createdAt,
        this.discountedPrice
      });

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variant = json['variant'];
    variantKey = json['variant_key'];
    serviceId = json['service_id'];
    zoneId = json['zone_id'];
    price = json['price'];
    createdAt = json['created_at'];
    discountedPrice = double.tryParse('${json['discounted_price']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['variant'] = variant;
    data['variant_key'] = variantKey;
    data['service_id'] = serviceId;
    data['zone_id'] = zoneId;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['discounted_price'] = discountedPrice;
    return data;
  }
}

class ZoneWiseVariations {
  String? variantKey;
  String? variantName;
  num? price;

  ZoneWiseVariations({this.variantKey, this.variantName, this.price,});

  ZoneWiseVariations.fromJson(Map<String, dynamic> json) {
    variantKey = json['variant_key'];
    variantName = json['variant_name'];
    price = num.tryParse('${json['price']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variant_key'] = variantKey;
    data['variant_name'] = variantName;
    data['price'] = price;
    return data;
  }
}
class ServiceCategory {
  String? id;
  String? parentId;
  String? name;
  String? slug;
  String? image;
  String? imageFullPath;
  int? position;
  String? description;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  ServiceCategory(
      {this.id,
        this.parentId,
        this.name,
        this.slug,
        this.image,
        this.imageFullPath,
        this.position,
        this.description,
        this.isActive,
        this.createdAt,
        this.updatedAt,
      });

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    imageFullPath = json['image_full_path'];
    position = json['position'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['image_full_path'] = imageFullPath;
    data['position'] = position;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class ZonesBasicInfo {
  String? id;
  String? name;
  List<Coordinates>? coordinates;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  ZonesBasicInfo(
      {this.id,
        this.name,
        this.coordinates,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  ZonesBasicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(Coordinates.fromJson(v));
      });
    }
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}
class Faqs {
  String? id;
  String? question;
  String? answer;
  String? serviceId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Faqs(
      {this.id,
        this.question,
        this.answer,
        this.serviceId,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  Faqs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    serviceId = json['service_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['service_id'] = serviceId;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class ServiceDiscount {
  int? id;
  String? discountId;
  String? discountType;
  String? typeWiseId;
  String? createdAt;
  String? updatedAt;
  Discount? discount;

  ServiceDiscount(
      {this.id,
        this.discountId,
        this.discountType,
        this.typeWiseId,
        this.createdAt,
        this.updatedAt,
        this.discount});

  ServiceDiscount.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discount_id'] = discountId;
    data['discount_type'] = discountType;
    data['type_wise_id'] = typeWiseId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    return data;
  }
}
