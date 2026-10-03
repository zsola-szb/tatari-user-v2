class CheckoutTotals {
  final double subTotal;
  final double discount;
  final double campaignDiscount;
  final double couponDiscount;
  final double referralDiscount;
  final double proDiscount;
  final String? proBenefitType;
  final double vat;
  final double additionalCharge;
  final double grandTotal;
  final double walletPaid;

  final int occurrenceCount;

  const CheckoutTotals({
    this.subTotal = 0,
    this.discount = 0,
    this.campaignDiscount = 0,
    this.couponDiscount = 0,
    this.referralDiscount = 0,
    this.proDiscount = 0,
    this.proBenefitType,
    this.vat = 0,
    this.additionalCharge = 0,
    this.grandTotal = 0,
    this.walletPaid = 0,
    this.occurrenceCount = 1,
  });

  const CheckoutTotals.empty() : this();

  double get originalTotal => subTotal + vat + additionalCharge;

  double get totalDiscount => discount + campaignDiscount + couponDiscount + referralDiscount + proDiscount;

  double get dueAmount {
    final double due = grandTotal - walletPaid;
    return due < 0 ? 0 : due;
  }

  bool get hasDiscount => originalTotal > grandTotal;

  bool get showProDiscountRow => proBenefitType == 'discount' && proDiscount > 0;

  bool get isProCouponBenefit => proBenefitType == 'coupon' && proDiscount > 0;

  bool get isProServiceFeeBenefit => proBenefitType == 'service_fee' && proDiscount > 0;

  double get additionalChargeAfterProDiscount => additionalCharge - proDiscount;

  CheckoutTotals dividedBy(int count) {
    if (count <= 1) {
      return this;
    }
    return CheckoutTotals(
      subTotal: subTotal / count,
      discount: discount / count,
      campaignDiscount: campaignDiscount / count,
      couponDiscount: couponDiscount / count,
      referralDiscount: referralDiscount / count,
      proDiscount: proDiscount / count,
      proBenefitType: proBenefitType,
      vat: vat / count,
      additionalCharge: additionalCharge / count,
      grandTotal: grandTotal / count,
      walletPaid: walletPaid / count,
      occurrenceCount: occurrenceCount,
    );
  }
}
