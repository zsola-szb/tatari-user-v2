class CouponModel {
  String? id;
  String? couponType;
  String? couponCode;
  String? discountId;
  int? isActive;
  int? isUsed;
  int? usedCount;
  int? remainingUses;
  String? createdAt;
  String? updatedAt;
  Discount? discount;

  CouponModel(
      {this.id,
        this.couponType,
        this.couponCode,
        this.discountId,
        this.isActive,
        this.isUsed,
        this.usedCount,
        this.remainingUses,
        this.createdAt,
        this.updatedAt,
        this.discount});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    discountId = json['discount_id'];
    isActive = int.tryParse(json['is_active'].toString());
    isUsed = int.tryParse(json['is_used'].toString());
    usedCount = int.tryParse(json['used_count'].toString());
    remainingUses = int.tryParse(json['remaining_uses'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    /// v1 nested the promotion under `discount`; v2 hoists those fields onto the
    /// coupon itself and renames `discount_title` to `title`.
    discount = json['discount'] is Map<String, dynamic>
        ? Discount.fromJson(json['discount'])
        : Discount.fromFlatCoupon(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['coupon_type'] = couponType;
    data['coupon_code'] = couponCode;
    data['discount_id'] = discountId;
    data['is_active'] = isActive;
    data['is_used'] = isUsed;
    data['used_count'] = usedCount;
    data['remaining_uses'] = remainingUses;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    return data;
  }
}

class Discount {
  String? id;
  String? discountTitle;
  String? discountType;
  double? discountAmount;
  String? discountAmountType;
  double? minPurchase;
  num? maxDiscountAmount;
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
        this.minPurchase,
        this.maxDiscountAmount,
        this.limitPerUser,
        this.promotionType,
        this.isActive,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt});

  /// Builds the promotion from a flat `/api/v2` coupon row, which carries the
  /// same values on the coupon itself instead of in a nested `discount` object.
  Discount.fromFlatCoupon(Map<String, dynamic> json) {
    id = json['discount_id'];
    discountTitle = json['title'];
    discountType = json['discount_type'];
    discountAmount = double.tryParse(json['discount_amount'].toString());
    discountAmountType = json['discount_amount_type'];
    minPurchase = double.tryParse(json['min_purchase'].toString());
    maxDiscountAmount = json['max_discount_amount'];
    limitPerUser = int.tryParse(json['limit_per_user'].toString());
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discountTitle = json['discount_title'];
    discountType = json['discount_type'];
    discountAmount = double.tryParse(json['discount_amount'].toString());
    discountAmountType = json['discount_amount_type'];
    minPurchase = double.tryParse(json['min_purchase'].toString());
    maxDiscountAmount = json['max_discount_amount'];
    limitPerUser = json['limit_per_user'];
    promotionType = json['promotion_type'];
    isActive = json['is_active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['discount_title'] = discountTitle;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['discount_amount_type'] = discountAmountType;
    data['min_purchase'] = minPurchase;
    data['max_discount_amount'] = maxDiscountAmount;
    data['limit_per_user'] = limitPerUser;
    data['promotion_type'] = promotionType;
    data['is_active'] = isActive;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
