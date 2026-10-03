class SuggestedServiceModel {
  int? totalSize;
  int? currentPage;
  int? hasSuggestion;
  List<SuggestedService>? suggestedServiceList;

  SuggestedServiceModel({this.totalSize, this.currentPage, this.suggestedServiceList, this.hasSuggestion});

  SuggestedServiceModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    currentPage = int.tryParse(json['offset'].toString());
    hasSuggestion = int.tryParse(json['has_suggestion'].toString());
    if (json['data'] != null) {
      suggestedServiceList = <SuggestedService>[];
      json['data'].forEach((v) {
        suggestedServiceList!.add(SuggestedService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['offset'] = currentPage;
    if (suggestedServiceList != null) {
      data['data'] = suggestedServiceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestedService {
  String? id;
  String? serviceName;
  String? serviceDescription;
  String? status;
  String? adminFeedback;
  SuggestionCategory? category;
  SuggestionSubCategory? subCategory;
  String? createdAt;

  SuggestedService({
    this.id,
    this.serviceName,
    this.serviceDescription,
    this.status,
    this.adminFeedback,
    this.category,
    this.subCategory,
    this.createdAt,
  });

  SuggestedService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    status = json['status'];
    adminFeedback = json['admin_feedback'];
    category = json['category'] != null ? SuggestionCategory.fromJson(json['category']) : null;
    subCategory = json['sub_category'] != null ? SuggestionSubCategory.fromJson(json['sub_category']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_name'] = serviceName;
    data['service_description'] = serviceDescription;
    data['status'] = status;
    data['admin_feedback'] = adminFeedback;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class SuggestionCategory {
  String? id;
  String? name;
  String? slug;
  String? logo;
  int? totalServices;

  SuggestionCategory({this.id, this.name, this.slug, this.logo, this.totalServices});

  SuggestionCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    totalServices = json['total_services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['total_services'] = totalServices;
    return data;
  }
}

class SuggestionSubCategory {
  String? id;
  String? name;

  SuggestionSubCategory({this.id, this.name});

  SuggestionSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
