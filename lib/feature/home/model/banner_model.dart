class BannerContentModel {

  List<BannerModel>? _data;

  BannerContentModel( {List<BannerModel>? data}) {
    if (data != null) {
      _data = data;
    }
  }

  List<BannerModel>? get data => _data;

  BannerContentModel.fromJson(Map<String, dynamic> json) {

    if (json['data'] != null) {
      _data = <BannerModel>[];
      json['data'].forEach((v) {
        _data!.add(BannerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  String? _id;
  String? _title;
  String? _resourceType;
  String? _resourceId;
  String? _resourceApiUrl;
  String? _redirectLink;
  String? _bannerImageFullPath;
  String? categoryName;

  BannerModel(
      {String? id,
        String? title,
        String? resourceType,
        String? resourceId,
        String? resourceApiUrl,
        String? redirectLink,
        String? bannerImageFullPath,
        this.categoryName
      }) {
    _id = id;
    _title = title;
    _resourceType = resourceType;
    _resourceId = resourceId;
    _resourceApiUrl = resourceApiUrl;
    _redirectLink = redirectLink;
    _bannerImageFullPath = bannerImageFullPath;
  }

  String? get id => _id;
  String? get title => _title;
  String? get resourceType => _resourceType;
  String? get resourceId => _resourceId;

  String? get resourceApiUrl => _resourceApiUrl;

  String? get redirectLink => _redirectLink;
  String? get bannerImageFullPath => _bannerImageFullPath;

  String? get slug {
    final Uri? resourceApiUri = Uri.tryParse(_resourceApiUrl ?? '');
    final List<String> pathSegments = resourceApiUri?.pathSegments
        .where((String segment) => segment.isNotEmpty).toList() ?? <String>[];

    return pathSegments.isEmpty ? null : pathSegments.last;
  }


  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _resourceType = json['resource_type'];
    _resourceId = json['resource_id'];
    _resourceApiUrl = json['resource_api_url'];
    _redirectLink = json['redirect_link'];
    _bannerImageFullPath = json['banner_image_full_path'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['resource_type'] = _resourceType;
    data['resource_id'] = _resourceId;
    data['resource_api_url'] = _resourceApiUrl;
    data['redirect_link'] = _redirectLink;
    data['banner_image_full_path'] = _bannerImageFullPath;
    data['category_name'] = categoryName;
    return data;
  }
}
