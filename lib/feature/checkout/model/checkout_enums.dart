
enum CheckoutFlow { cart, bid }


enum CheckoutPaymentMethod {
  none,
  cashAfterService,
  wallet,
  digital,
  offline;

  String get apiKey {
    switch (this) {
      case CheckoutPaymentMethod.cashAfterService:
        return 'cash_after_service';
      case CheckoutPaymentMethod.wallet:
        return 'wallet_payment';
      case CheckoutPaymentMethod.digital:
        return 'digital_payment';
      case CheckoutPaymentMethod.offline:
        return 'offline_payment';
      case CheckoutPaymentMethod.none:
        return '';
    }
  }
}

enum BillingRowSign {
  none,
  plus,
  minus;

  String get prefix {
    switch (this) {
      case BillingRowSign.plus:
        return '(+) ';
      case BillingRowSign.minus:
        return '(-) ';
      case BillingRowSign.none:
        return '';
    }
  }
}

enum ExistingUserStatus { available, taken, unknown }
