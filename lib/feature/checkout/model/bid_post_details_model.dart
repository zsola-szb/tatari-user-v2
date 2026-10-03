import 'package:tatarigigs_user/util/core_export.dart';

class BidPostDetailsContent {
  String? serviceId;
  String? serviceName;
  String? categoryName;
  String? serviceDescription;
  List<AdditionInstructions>? additionInstructions;
  String? bookingSchedule;
  String? serviceAddress;
  double? bidAmount;
  double? referralAmount;
  double? taxAmount;
  String? contactPersonName;
  String? contactPersonNumber;

  BidPostDetailsContent({
    this.serviceId,
    this.serviceName,
    this.categoryName,
    this.serviceDescription,
    this.additionInstructions,
    this.bookingSchedule,
    this.serviceAddress,
    this.bidAmount,
    this.referralAmount,
    this.taxAmount,
    this.contactPersonName,
    this.contactPersonNumber,
  });

  BidPostDetailsContent.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id']?.toString();
    serviceName = json['service_name'];
    categoryName = json['category_name'];
    serviceDescription = json['service_description'];
    bookingSchedule = json['booking_schedule'];
    serviceAddress = json['service_address']?.toString();
    bidAmount = double.tryParse(json['bid_amount'].toString());
    referralAmount = double.tryParse(json['referral_amount'].toString());
    taxAmount = double.tryParse(json['tax_amount'].toString());
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];

    final dynamic instructions = json['addition_instructions'];
    if (instructions is List) {
      additionInstructions = instructions.whereType<Map<String, dynamic>>().map(AdditionInstructions.fromJson).toList();
    }
  }

  bool get hasAdditionalInstruction =>
      additionInstructions != null && additionInstructions!.isNotEmpty;
}
