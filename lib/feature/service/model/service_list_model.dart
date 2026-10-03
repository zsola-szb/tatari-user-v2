import 'package:tatarigigs_user/feature/service/model/service_model.dart';

class ServiceListModel {
  final String? responseCode;
  final String? message;
  final int totalSize;
  final int limit;
  final int offset;
  final List<ServiceItemModel> services;

  const ServiceListModel({
    this.responseCode,
    this.message,
    this.totalSize = 0,
    this.limit = 10,
    this.offset = 1,
    this.services = const <ServiceItemModel>[],
  });

  const ServiceListModel.empty() : this();

  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    final dynamic content = json['content'];
    final dynamic rows = json['data'] is List ? json['data'] : (content is Map ? content['data'] : null);

    return ServiceListModel(
      responseCode: json['response_code'],
      message: json['message'],
      totalSize: _toInt(json['total_size'] ?? (content is Map ? content['total'] : null)),
      limit: _toInt(json['limit'], fallback: 10),
      offset: _toInt(json['offset'] ?? (content is Map ? content['current_page'] : null), fallback: 1),
      services: rows is List
          ? rows.whereType<Map<String, dynamic>>().map((Map<String, dynamic> row) => ServiceItemModel.fromJson(row)).toList()
          : const <ServiceItemModel>[],
    );
  }

  List<Service> toServiceList() => services.map((ServiceItemModel item) => item.toService()).toList();

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value') ?? fallback;
  }
}

class ServiceItemModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? thumbnailFullPath;
  final String? categoryId;
  final String? subCategoryId;
  final int? isFavorite;
  final int? ratingCount;
  final double? avgRating;
  final ServiceCategory? category;
  final ServiceCategory? subCategory;
  final VariationsAppFormat? variationsAppFormat;
  final List<Variations> variations;
  // final List<ServiceDiscount> serviceDiscount;
  // final List<ServiceDiscount> campaignDiscount;
  final List<ServiceProvider> providers;
  final double? lowestPrice;
  final double? discountedLowestPrice;
  final String? maximumDiscount;

  const ServiceItemModel({
    this.id,
    this.name,
    this.slug,
    this.thumbnailFullPath,
    this.categoryId,
    this.subCategoryId,
    this.isFavorite,
    this.ratingCount,
    this.avgRating,
    this.category,
    this.subCategory,
    this.variationsAppFormat,
    this.variations = const <Variations>[],
    this.providers = const <ServiceProvider>[],
    this.lowestPrice,
    this.discountedLowestPrice,
    this.maximumDiscount
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) => ServiceItemModel(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        thumbnailFullPath: json['thumbnail_full_path'],
        categoryId: json['category_id'],
        subCategoryId: json['sub_category_id'],
        isFavorite: json['is_favorite'],
        ratingCount: json['rating_count'],
        avgRating: double.tryParse('${json['avg_rating']}'),
        category: json['category'] is Map<String, dynamic> ? ServiceCategory.fromJson(json['category']) : null,
        subCategory: json['sub_category'] is Map<String, dynamic> ? ServiceCategory.fromJson(json['sub_category']) : null,
        variationsAppFormat: json['variations_app_format'] is Map<String, dynamic>
            ? VariationsAppFormat.fromJson(json['variations_app_format']) : null,
        variations: _listOf<Variations>(json['variations'], (Map<String, dynamic> row) => Variations.fromJson(row)),
        lowestPrice: double.tryParse('${json['lowest_price']}'),
        discountedLowestPrice: double.tryParse('${json['lowest_discounted_price']}'),
        maximumDiscount:  json['maximum_discount'],
        providers: ServiceProvider.listFrom(json),
      );

  Service toService() => Service(
        id: id,
        slug: slug,
        name: name,
        thumbnailFullPath: thumbnailFullPath,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        isFavorite: isFavorite,
        ratingCount: ratingCount,
        avgRating: avgRating,
        category: category,
        subCategory: subCategory,
        variationsAppFormat: variationsAppFormat,
        variations: variations,
        lowestPrice: lowestPrice,
        discountedLowestPrice: discountedLowestPrice,
        providers: providers,
        maximumDiscount: maximumDiscount
      );

  static List<T> _listOf<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
    if (value is! List) {
      return <T>[];
    }
    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
}
