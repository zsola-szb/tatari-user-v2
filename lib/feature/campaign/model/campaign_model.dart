enum CampaignDiscountType {
  mixed('mixed'),
  category('category'),
  service('service');

  final String value;
  const CampaignDiscountType(this.value);

  static CampaignDiscountType fromValue(String? value) => CampaignDiscountType.values.firstWhere(
        (CampaignDiscountType type) => type.value == value,
        orElse: () => CampaignDiscountType.service,
      );
}

class CampaignModel {
  final String? responseCode;
  final String? message;
  final int totalSize;
  final int limit;
  final int offset;
  final List<CampaignData> campaigns;

  const CampaignModel({
    this.responseCode,
    this.message,
    this.totalSize = 0,
    this.limit = 10,
    this.offset = 1,
    this.campaigns = const <CampaignData>[],
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    final dynamic rows = json['data'];

    return CampaignModel(
      responseCode: json['response_code'],
      message: json['message'],
      totalSize: toInt(json['total_size']),
      limit: toInt(json['limit'], fallback: 10),
      offset: toInt(json['offset'], fallback: 1),
      campaigns: rows is List
          ? rows.whereType<Map<String, dynamic>>().map((Map<String, dynamic> row) => CampaignData.fromJson(row)).toList() : const <CampaignData>[],
    );
  }

  static int toInt(dynamic value, {int fallback = 0}) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value') ?? fallback;
  }
}

class CampaignData {
  final String? id;
  final String? name;
  final CampaignDiscountType discountType;
  final int? serviceCount;
  final String? thumbnailFullPath;
  final String? coverImageFullPath;
  final String? minimumPurchaseAmount;

  final String? validTill;

  const CampaignData({
    this.id,
    this.name,
    this.discountType = CampaignDiscountType.service,
    this.serviceCount,
    this.thumbnailFullPath,
    this.coverImageFullPath,
    this.minimumPurchaseAmount,
    this.validTill,
  });

  factory CampaignData.fromJson(Map<String, dynamic> json) => CampaignData(
        id: json['id'],
        name: json['name'],
        discountType: CampaignDiscountType.fromValue(json['discount_type']),
        serviceCount: CampaignModel.toInt(json['service_count']),
        thumbnailFullPath: json['thumbnail_full_path'],
        coverImageFullPath: json['cover_image_full_path'],
        minimumPurchaseAmount: json['minimum_purchase_amount'],
        validTill: json['valid_till'],
      );

  bool get isCategoryAndMixedWise => discountType == CampaignDiscountType.category || discountType == CampaignDiscountType.mixed;

  DateTime? get validTillDate {
    final String? date = validTill;
    if (date == null || date.isEmpty) {
      return null;
    }
    return DateTime.tryParse(date);
  }
}

class CampaignCategory {
  final String? id;
  final String? name;
  final String? slug;
  final String? logo;
  final int totalServices;

  const CampaignCategory({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.totalServices = 0,
  });

  factory CampaignCategory.fromJson(Map<String, dynamic> json) => CampaignCategory(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        logo: json['logo'],
        totalServices: CampaignModel.toInt(json['total_services']),
      );
}

class CampaignCategoryListModel {
  final int totalSize;
  final List<CampaignCategory> categories;

  const CampaignCategoryListModel({
    this.totalSize = 0,
    this.categories = const <CampaignCategory>[],
  });

  factory CampaignCategoryListModel.fromJson(Map<String, dynamic> json) {
    final dynamic rows = json['data'];

    return CampaignCategoryListModel(
      totalSize: CampaignModel.toInt(json['total_size']),
      categories: rows is List
          ? rows.whereType<Map<String, dynamic>>().map((Map<String, dynamic> row) => CampaignCategory.fromJson(row)).toList()
          : const <CampaignCategory>[],
    );
  }
}
