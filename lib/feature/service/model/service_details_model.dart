import 'package:tatarigigs_user/util/core_export.dart';

class ServiceDetailsModel {
  final String? responseCode;
  final String? message;
  final ServiceDetailsItemModel? service;

  const ServiceDetailsModel({this.responseCode, this.message, this.service});

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    final dynamic row = json['data'] ?? json['content'];

    return ServiceDetailsModel(
      responseCode: json['response_code'],
      message: json['message'],
      service: row is Map<String, dynamic> ? ServiceDetailsItemModel.fromJson(row) : null,
    );
  }
}

class ServiceDetailsItemModel {
  final String? id;
  final String? slug;
  final String? name;
  final String? shortDescription;
  final String? description;
  final String? coverImageFullPath;
  final String? thumbnailFullPath;
  final String? categoryId;
  final String? subCategoryId;
  final String? categoryName;
  final String? subCategoryName;
  final double? tax;
  final double? lowestPrice;
  final double? discountedLowestPrice;
  final String? maximumDiscount;
  final int? isFavorite;
  final int? ratingCount;
  final double? avgRating;
  final List<Variations> variations;
  final List<Faqs> faqs;
  final List<ServiceDiscount> serviceDiscount;
  final List<ServiceDiscount> campaignDiscount;
  final List<ProviderData> serviceProviders;
  final List<ServiceItemModel> relatedServices;

  const ServiceDetailsItemModel({
    this.id,
    this.slug,
    this.name,
    this.shortDescription,
    this.description,
    this.coverImageFullPath,
    this.thumbnailFullPath,
    this.categoryId,
    this.subCategoryId,
    this.categoryName,
    this.subCategoryName,
    this.tax,
    this.lowestPrice,
    this.discountedLowestPrice,
    this.maximumDiscount,
    this.isFavorite,
    this.ratingCount,
    this.avgRating,
    this.variations = const <Variations>[],
    this.faqs = const <Faqs>[],
    this.serviceDiscount = const <ServiceDiscount>[],
    this.campaignDiscount = const <ServiceDiscount>[],
    this.serviceProviders = const <ProviderData>[],
    this.relatedServices = const <ServiceItemModel>[],
  });

  factory ServiceDetailsItemModel.fromJson(Map<String, dynamic> json) => ServiceDetailsItemModel(
        id: json['id'],
        slug: json['slug'],
        name: json['name'],
        shortDescription: json['short_description'],
        description: json['description'],
        coverImageFullPath: json['cover_image_full_path'],
        thumbnailFullPath: json['thumbnail_full_path'],
        categoryId: json['category_id'],
        subCategoryId: json['sub_category_id'],
        categoryName: _nameOf(json['category_name'], json['category']),
        subCategoryName: _nameOf(json['sub_category_name'], json['sub_category']),
        tax: double.tryParse('${json['tax']}'),
        lowestPrice: double.tryParse('${json['lowest_price']}'),
        discountedLowestPrice: double.tryParse('${json['lowest_discounted_price']}'),
        maximumDiscount: json['maximum_discount'],
        isFavorite: PaginatedEnvelope.toInt(json['is_favorite']),
        ratingCount: PaginatedEnvelope.toInt(json['total_rating']),
        avgRating: double.tryParse('${json['rating']}'),
        variations: _listOf<Variations>(json['variations'], (Map<String, dynamic> row) => Variations.fromJson(row)),
        faqs: _listOf<Faqs>(json['faqs'], (Map<String, dynamic> row) => Faqs.fromJson(row)),
        serviceDiscount: _listOf<ServiceDiscount>(json['service_discount'], (Map<String, dynamic> row) => ServiceDiscount.fromJson(row)),
        campaignDiscount: _listOf<ServiceDiscount>(json['campaign_discount'], (Map<String, dynamic> row) => ServiceDiscount.fromJson(row)),
        serviceProviders: _listOf<ProviderData>(json['service_providers'], (Map<String, dynamic> row) => ProviderData.fromJson(row)),
        relatedServices: _listOf<ServiceItemModel>(json['services_you_also_like'], (Map<String, dynamic> row) => ServiceItemModel.fromJson(row)),
      );


  Service toService({String? fallbackSlug}) => Service(
        id: id,
        slug: slug ?? fallbackSlug,
        name: name,
        shortDescription: shortDescription,
        description: description,
        coverImageFullPath: coverImageFullPath,
        thumbnailFullPath: thumbnailFullPath,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        tax: tax,
        lowestPrice: lowestPrice,
        discountedLowestPrice: discountedLowestPrice,
        maximumDiscount: maximumDiscount,
        isFavorite: isFavorite,
        ratingCount: ratingCount,
        avgRating: avgRating,
        category: ServiceCategory(id: categoryId, name: categoryName),
        subCategory: ServiceCategory(id: subCategoryId, name: subCategoryName),
        variations: variations,
        variationsAppFormat: VariationsAppFormat(
          zoneId: variations.isEmpty ? null : variations.first.zoneId,
          zoneWiseVariations: variations
              .map((Variations variation) => ZoneWiseVariations(
                    variantKey: variation.variantKey,
                    variantName: variation.variant,
                    price: variation.price)).toList(),
        ),
        faqs: faqs,
      );

  List<Service> toRelatedServiceList() =>
      relatedServices.map((ServiceItemModel item) => item.toService()).toList();

  static List<T> _listOf<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
    if (value is! List) {
      return <T>[];
    }
    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  /// The API may send a category name flat (`category_name`) or nested inside its relation object.
  static String? _nameOf(dynamic flatName, dynamic relation) {
    if (flatName is String && flatName.isNotEmpty) {
      return flatName;
    }
    return relation is Map<String, dynamic> ? relation['name'] : null;
  }
}
