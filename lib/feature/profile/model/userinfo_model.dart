import 'package:tatarigigs_user/feature/booking/model/booking_list_item_model.dart';
import 'package:tatarigigs_user/feature/profile/model/profile_additional_data.dart';

class UserInfoModel {
  String? id;
  String? fName;
  String? lName;
  String? email;
  String? image;
  String? imageFullPath;
  String? phone;
  String? password;
  String? confirmPassword;
  String? createdAt;
  int? bookingsCount;
  String? referCode;
  String? referredBy;
  int? isEmailVerified;
  int? isPhoneVerified;
  double? walletBalance;
  SubscribedPlan? subscribedPlan;
  BookingListItemModel? lastIncompleteOfflineBooking;
  List<ProfileAdditionalData>? additionalData;
  double? currentPlanTotalSaved;
  int? currentPlanTotalOrder;
  int? currentPlanRemainingDays;
  double? totalBookingAmount;



  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.imageFullPath,
        this.phone,
        this.password,
        this.confirmPassword,
        this.createdAt,
        this.bookingsCount,
        this.referCode,
        this.referredBy,
        this.isEmailVerified,
        this.isPhoneVerified,
        this.walletBalance,
        this.lastIncompleteOfflineBooking,
        this.subscribedPlan,
        this.additionalData,
        this.currentPlanRemainingDays,
        this.currentPlanTotalOrder,
        this.currentPlanTotalSaved,
        this.totalBookingAmount
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['first_name'];
    lName = json['last_name'];
    email = json['email'];
    image = json['profile_image'];
    imageFullPath = json['profile_image_full_path'];
    phone = json['phone'];
    createdAt = json['created_at'];
    referCode = json['ref_code'];
    referredBy = json['referred_by'];
    bookingsCount =  int.tryParse(json['bookings_count'].toString());
    isEmailVerified =  int.tryParse(json['is_email_verified'].toString());
    isPhoneVerified =  int.tryParse(json['is_phone_verified'].toString());
    walletBalance =  double.tryParse(json['wallet_balance'].toString());
    lastIncompleteOfflineBooking = json['last_incomplete_offline_booking'] is Map<String, dynamic>
        ? BookingListItemModel.fromJson(json['last_incomplete_offline_booking'])
        : null;
    if (json['additional_data'] != null) {
      additionalData = <ProfileAdditionalData>[];
      json['additional_data'].forEach((v) {
        additionalData!.add(ProfileAdditionalData.fromJson(v));
      });
    }
    subscribedPlan = json['subscribed_plan'] != null
        ? SubscribedPlan.fromJson(json['subscribed_plan'])
        : null;
    currentPlanTotalSaved = double.tryParse('${json['current_plan_total_saved']}');
    totalBookingAmount = double.tryParse('${json['total_booking_amount']}');
    currentPlanTotalOrder = int.tryParse('${json['current_plan_total_orders']}');
    currentPlanRemainingDays = int.tryParse('${json['current_plan_remaining_days']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = fName;
    data['last_name'] = lName;
    data['email'] = email;
    data['profile_image'] = image;
    data['profile_image_full_path'] = imageFullPath;
    data['phone'] = phone;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['ref_code'] = referCode;
    data['referred_by'] = referredBy;
    return data;
  }
}

class SubscribedPlan {
  String? id;
  String? customerUserId;
  String? subscriptionPlanId;
  String? planName;
  String? planType;
  int? price;
  int? durationDays;
  String? startDate;
  String? expireDate;
  String? status;
  String? transactionId;
  String? paidBy;
  int? isCurrent;
  int? expireReminderSent;
  String? createdAt;
  String? updatedAt;

  SubscribedPlan(
      {this.id,
        this.customerUserId,
        this.subscriptionPlanId,
        this.planName,
        this.planType,
        this.price,
        this.durationDays,
        this.startDate,
        this.expireDate,
        this.status,
        this.transactionId,
        this.paidBy,
        this.isCurrent,
        this.expireReminderSent,
        this.createdAt,
        this.updatedAt});

  SubscribedPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerUserId = json['customer_user_id'];
    subscriptionPlanId = json['subscription_plan_id'];
    planName = json['plan_name'];
    planType = json['plan_type'];
    price = json['price'];
    durationDays = json['duration_days'];
    startDate = json['start_date'];
    expireDate = json['expire_date'];
    status = json['status'];
    transactionId = json['transaction_id'];
    paidBy = json['paid_by'];
    isCurrent = json['is_current'];
    expireReminderSent = json['expire_reminder_sent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['customer_user_id'] = customerUserId;
    data['subscription_plan_id'] = subscriptionPlanId;
    data['plan_name'] = planName;
    data['plan_type'] = planType;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['start_date'] = startDate;
    data['expire_date'] = expireDate;
    data['status'] = status;
    data['transaction_id'] = transactionId;
    data['paid_by'] = paidBy;
    data['is_current'] = isCurrent;
    data['expire_reminder_sent'] = expireReminderSent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
