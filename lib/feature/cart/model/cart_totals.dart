class CartTotals {
  final double subTotal;
  final double discount;
  final double vat;
  final double additionalCharge;

  final double proDiscount;
  final String? proBenefitType;
  final double grandTotal;

  const CartTotals({
    this.subTotal = 0,
    this.discount = 0,
    this.vat = 0,
    this.additionalCharge = 0,
    this.proDiscount = 0,
    this.proBenefitType,
    this.grandTotal = 0,
  });

  const CartTotals.empty() : this();

  double get originalTotal => subTotal + vat + additionalCharge;

  bool get hasDiscount => originalTotal > grandTotal;

  bool get showProDiscountRow => proBenefitType == 'discount' && proDiscount > 0;

  bool get isProCouponBenefit => proBenefitType == 'coupon' && proDiscount > 0;

  bool get isProServiceFeeBenefit => proBenefitType == 'service_fee' && proDiscount > 0;

  double get additionalChargeAfterProDiscount => additionalCharge - proDiscount;
}
