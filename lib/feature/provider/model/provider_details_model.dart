import 'package:tatarigigs_user/feature/provider/model/provider_model.dart';
import 'package:tatarigigs_user/feature/service/model/service_review_model.dart';

class ProviderDetails {
  ProviderDetailsContent? content;

  ProviderDetails({this.content});

  ProviderDetails.fromJson(Map<String, dynamic> json) {
    content = json['data'] is Map<String, dynamic>
        ? ProviderDetailsContent.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
}

class ProviderDetailsContent {
  ProviderData? provider;
  List<ProviderServiceCategory> categories;
  ProviderCampaignOffer? campaign;
  ProviderProMemberOffer? proMemberPlan;

  ProviderDetailsContent({
    this.provider,
    this.categories = const <ProviderServiceCategory>[],
    this.campaign,
    this.proMemberPlan,
  });

  ProviderDetailsContent.fromJson(Map<String, dynamic> json)
      : categories = json['categories'] is List
            ? (json['categories'] as List)
                .whereType<Map<String, dynamic>>()
                .map((Map<String, dynamic> category) => ProviderServiceCategory.fromJson(category))
                .toList()
            : <ProviderServiceCategory>[] {
    provider = ProviderData.fromJson(json);
    campaign = json['campaign'] is Map<String, dynamic>
        ? ProviderCampaignOffer.fromJson(json['campaign'] as Map<String, dynamic>) : null;
    proMemberPlan = json['pro_member_plan'] is Map<String, dynamic>
        ? ProviderProMemberOffer.fromJson(json['pro_member_plan'] as Map<String, dynamic>) : null;
  }
}

class ProviderServiceCategory {
  final String id;
  final String name;

  const ProviderServiceCategory({required this.id, required this.name});

  factory ProviderServiceCategory.fromJson(Map<String, dynamic> json) => ProviderServiceCategory(
    id: '${json['id'] ?? ''}',
    name: '${json['name'] ?? ''}',
  );
}

class ProviderCampaignOffer {
  final String name;
  final double? discount;
  final String? discountRange;
  final double? minPurchase;
  final String? startDate;
  final String? endDate;

  const ProviderCampaignOffer({
    required this.name,
    this.discount,
    this.discountRange,
    this.minPurchase,
    this.startDate,
    this.endDate,
  });

  factory ProviderCampaignOffer.fromJson(Map<String, dynamic> json) => ProviderCampaignOffer(
    name: '${json['name'] ?? ''}',
    discount: double.tryParse('${json['discount']}'),
    discountRange: json['discount_range'] == null ? null : '${json['discount_range']}',
    minPurchase: double.tryParse('${json['min_purchase']}'),
    startDate: json['start_date'] == null ? null : '${json['start_date']}',
    endDate: json['end_date'] == null ? null : '${json['end_date']}',
  );
}

class ProviderProMemberOffer {
  final String id;
  final String planId;
  final String planName;
  final String planType;
  final double? price;
  final double? discount;
  final int? durationDays;
  final String? startDate;
  final String? expireDate;

  const ProviderProMemberOffer({
    required this.id,
    required this.planId,
    required this.planName,
    required this.planType,
    this.price,
    this.discount,
    this.durationDays,
    this.startDate,
    this.expireDate,
  });

  factory ProviderProMemberOffer.fromJson(Map<String, dynamic> json) => ProviderProMemberOffer(
    id: '${json['id'] ?? ''}',
    planId: '${json['plan_id'] ?? ''}',
    planName: '${json['plan_name'] ?? ''}',
    planType: '${json['plan_type'] ?? ''}',
    price: double.tryParse('${json['price']}'),
    discount: double.tryParse('${json['discount_percentage']}'),
    durationDays: int.tryParse('${json['duration_days']}'),
    startDate: json['start_date'] == null ? null : '${json['start_date']}',
    expireDate: json['expire_date'] == null ? null : '${json['expire_date']}',
  );
}

class TimeSchedule {
  String? startTime;
  String? endTime;

  TimeSchedule({this.startTime, this.endTime});

  TimeSchedule.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

class ProviderReview {
  List<Review>? reviewList;
  int? lastPage;
  int? currentPage;
  int? total;

  ProviderReview({this.reviewList, this.lastPage, this.total, this.currentPage});

  ProviderReview.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      reviewList = <Review>[];
      json['data'].forEach((v) {
        reviewList!.add(Review.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    total = json['total'];
  }
}
