import 'package:tatarigigs_user/feature/booking/model/booking_enums.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_parse_utils.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_payment_state.dart';
import 'package:tatarigigs_user/feature/booking/model/booking_service_item_model.dart';

double _servicesSubTotal(List<BookingServiceItemModel> services) {
  double total = 0;
  for (final BookingServiceItemModel service in services) {
    for (final BookingServiceVariation variation in service.variations) {
      total += variation.lineTotal;
    }
  }
  return total;
}

class BookingBillingTotals {
  final double subTotal;
  final double serviceDiscount;
  final double couponDiscount;
  final double campaignDiscount;
  final double referralDiscount;
  final double proDiscount;
  final String? proBenefitType;
  final double vat;
  final double extraFee;
  final double grandTotal;
  final double paidAmount;
  final double dueAmount;
  final double additionalCharge;
  final BookingPaymentMethod method;
  final List<BookingPartialPayment> partialPayments;
  final bool isBeforeSettlement;

  const BookingBillingTotals({
    this.subTotal = 0,
    this.serviceDiscount = 0,
    this.couponDiscount = 0,
    this.campaignDiscount = 0,
    this.referralDiscount = 0,
    this.proDiscount = 0,
    this.proBenefitType,
    this.vat = 0,
    this.extraFee = 0,
    this.grandTotal = 0,
    this.paidAmount = 0,
    this.dueAmount = 0,
    this.additionalCharge = 0,
    this.method = BookingPaymentMethod.unknown,
    this.partialPayments = const <BookingPartialPayment>[],
    this.isBeforeSettlement = false,
  });

  const BookingBillingTotals.empty() : this();

  factory BookingBillingTotals.fromJson(
    Map<String, dynamic> json, {
    required List<BookingServiceItemModel> services,
  }) {
    final double total = BookingParse.toDouble(json['total_booking_amount']);
    final double rawAdditionalCharge = BookingParse.toDouble(json['additional_charge']);

    final List<BookingPartialPayment> partials = BookingParse.objectList<BookingPartialPayment>(
      json['booking_partial_payments'],
      BookingPartialPayment.fromJson,
    );
    final bool isPartial = partials.isNotEmpty;

    final double paid = isPartial
        ? partials.fold(0, (double sum, BookingPartialPayment p) => sum + p.paidAmount) : total - rawAdditionalCharge;

    final double additionalCharge = isPartial ? total - paid : rawAdditionalCharge;

    return BookingBillingTotals(
      subTotal: _servicesSubTotal(services),
      serviceDiscount: BookingParse.toDouble(json['total_discount_amount']),
      couponDiscount: BookingParse.toDouble(json['total_coupon_discount_amount']),
      campaignDiscount: BookingParse.toDouble(json['total_campaign_discount_amount']),
      referralDiscount: BookingParse.toDouble(json['total_referral_discount_amount']),
      proDiscount: BookingParse.toDouble(json['pro_discount_amount']),
      proBenefitType: BookingParse.string(json['pro_benefit_type']),
      vat: BookingParse.toDouble(json['total_tax_amount']),
      extraFee: BookingParse.toDouble(json['extra_fee']),
      grandTotal: total,
      paidAmount: paid,
      dueAmount: total - paid,
      additionalCharge: additionalCharge,
      method: BookingPaymentMethod.fromApi(BookingParse.string(json['payment_method'])),
      partialPayments: partials,
      isBeforeSettlement: BookingStatus.fromApi(BookingParse.string(json['booking_status'])).isBeforeSettlement,
    );
  }
}

class RepeatBookingBillingTotals {
  final double initialSubTotal;
  final double updatedSubTotal;
  final double serviceDiscount;
  final double couponDiscount;
  final double referralDiscount;
  final double vat;
  final double extraFee;
  final double grandTotal;
  final double paidAmount;
  final double canceledAmount;
  final int occurrenceCount;
  final int paidBookingCount;
  final int canceledBookingCount;
  final bool isEdited;

  const RepeatBookingBillingTotals({
    this.initialSubTotal = 0,
    this.updatedSubTotal = 0,
    this.serviceDiscount = 0,
    this.couponDiscount = 0,
    this.referralDiscount = 0,
    this.vat = 0,
    this.extraFee = 0,
    this.grandTotal = 0,
    this.paidAmount = 0,
    this.canceledAmount = 0,
    this.occurrenceCount = 0,
    this.paidBookingCount = 0,
    this.canceledBookingCount = 0,
    this.isEdited = false,
  });

  const RepeatBookingBillingTotals.empty() : this();

  factory RepeatBookingBillingTotals.fromJson(
    Map<String, dynamic> json, {
    required List<BookingServiceItemModel> services,
    required List<Map<String, dynamic>> children,
    required bool isEdited,
  }) {
    final double total = BookingParse.toDouble(json['total_booking_amount']);
    final double serviceDiscount = BookingParse.toDouble(json['total_discount_amount']) +
        BookingParse.toDouble(json['total_campaign_discount_amount']);
    final double couponDiscount = BookingParse.toDouble(json['total_coupon_discount_amount']);
    final double referralDiscount = BookingParse.toDouble(json['total_referral_discount_amount']);
    final double vat = BookingParse.toDouble(json['total_tax_amount']);
    final double extraFee = BookingParse.toDouble(json['extra_fee']);
    final int occurrenceCount = BookingParse.toInt(json['totalCount'], fallback: 1);

    final double perOccurrenceSubTotal = _servicesSubTotal(services);

    double paid = 0;
    double canceled = 0;
    int paidCount = 0;
    int canceledCount = 0;
    for (final Map<String, dynamic> child in children) {
      final double amount = BookingParse.toDouble(child['total_booking_amount']);
      if (BookingParse.toBool(child['is_paid'])) {
        paid += amount;
        paidCount++;
      }
      if (BookingStatus.fromApi(BookingParse.string(child['booking_status'])).isCanceled) {
        canceled += amount;
        canceledCount++;
      }
    }

    return RepeatBookingBillingTotals(
      initialSubTotal: perOccurrenceSubTotal * (occurrenceCount <= 0 ? 1 : occurrenceCount),
      updatedSubTotal: (total + serviceDiscount + couponDiscount + referralDiscount) - (extraFee + vat),
      serviceDiscount: serviceDiscount,
      couponDiscount: couponDiscount,
      referralDiscount: referralDiscount,
      vat: vat,
      extraFee: extraFee,
      grandTotal: total,
      paidAmount: paid,
      canceledAmount: canceled,
      occurrenceCount: occurrenceCount,
      paidBookingCount: paidCount,
      canceledBookingCount: canceledCount,
      isEdited: isEdited,
    );
  }
}
