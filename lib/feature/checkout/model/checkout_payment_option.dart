import 'package:tatarigigs_user/feature/checkout/model/checkout_enums.dart';

class CheckoutPaymentOption {
  final String titleKey;
  final String assetName;
  final CheckoutPaymentMethod method;

  const CheckoutPaymentOption({
    required this.titleKey,
    required this.assetName,
    required this.method,
  });
}
