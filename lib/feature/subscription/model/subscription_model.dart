
class SubscriptionModel {
  String? responseCode;
  String? message;
  Content? content;
  List<String>? errors;

  SubscriptionModel(
      {this.responseCode, this.message, this.content, this.errors});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
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
  List<Plans>? plans;
  Benefits? benefits;
  List<Faqs>? faqs;

  Content({this.plans, this.benefits, this.faqs});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(Plans.fromJson(v));
      });
    }
    benefits = json['benefits'] != null
        ? Benefits.fromJson(json['benefits'])
        : null;
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (plans != null) {
      data['plans'] = plans!.map((v) => v.toJson()).toList();
    }
    if (benefits != null) {
      data['benefits'] = benefits!.toJson();
    }
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  String? id;
  String? planName;
  String? type;
  int? durationDays;
  double? price;
  bool? isActive;

  Plans({this.id, this.planName, this.type, this.durationDays, this.price, this.isActive});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    type = json['type'];
    durationDays = json['duration_days'];
    price = double.tryParse('${json['price']}');
    isActive = json['is_active'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    data['type'] = type;
    data['duration_days'] = durationDays;
    data['price'] = price;
    data['is_active'] = isActive;
    return data;
  }
}

class Benefits {
  Discount? discount;
  Coupon? coupon;
  ServiceFee? serviceFee;

  Benefits({this.discount, this.coupon, this.serviceFee});

  Benefits.fromJson(Map<String, dynamic> json) {
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
    coupon =
    json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null;
    serviceFee = json['service_fee'] != null
        ? ServiceFee.fromJson(json['service_fee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    if (serviceFee != null) {
      data['service_fee'] = serviceFee!.toJson();
    }
    return data;
  }
}

class Discount {
  int? status;
  int? discount;
  int? upToAmount;
  int? minOrderStatus;
  int? minOrderAmount;

  Discount(
      {this.status,
        this.discount,
        this.upToAmount,
        this.minOrderStatus,
        this.minOrderAmount});

  Discount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    discount = json['discount'];
    upToAmount = json['up_to_amount'];
    minOrderStatus = json['min_order_status'];
    minOrderAmount = json['min_order_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['discount'] = discount;
    data['up_to_amount'] = upToAmount;
    data['min_order_status'] = minOrderStatus;
    data['min_order_amount'] = minOrderAmount;
    return data;
  }
}

class Coupon {
  int? status;

  Coupon({this.status});

  Coupon.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}

class ServiceFee {
  int? status;
  String? type;
  int? discountPercent;
  int? minBookingStatus;
  int? minBookingAmount;
  String? label;

  ServiceFee(
      {this.status,
        this.type,
        this.discountPercent,
        this.minBookingStatus,
        this.minBookingAmount,
        this.label});

  ServiceFee.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    discountPercent = json['discount_percent'];
    minBookingStatus = json['min_booking_status'];
    minBookingAmount = json['min_booking_amount'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['type'] = type;
    data['discount_percent'] = discountPercent;
    data['min_booking_status'] = minBookingStatus;
    data['min_booking_amount'] = minBookingAmount;
    data['label'] = label;
    return data;
  }
}

class Faqs {
  String? id;
  String? question;
  String? answer;
  int? priority;

  Faqs({this.id, this.question, this.answer, this.priority});

  Faqs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    data['priority'] = priority;
    return data;
  }
}
