import 'package:tatarigigs_user/util/core_export.dart';

class CartVariationSelection {
  final String serviceId;
  final String categoryId;
  final String subCategoryId;
  final String variantKey;
  final double price;
  final double taxAmount;
  final Service service;
  final String? cartId;
  final double? discountedPrice;
  int quantity;
  final String? variantName;

  CartVariationSelection({
    required this.serviceId,
    required this.categoryId,
    required this.subCategoryId,
    required this.variantKey,
    required this.price,
    required this.service,
    this.taxAmount = 0,
    this.cartId,
    this.quantity = 0,
    this.discountedPrice,
    required this.variantName
  });

  CartVariationSelection copyWith({String? cartId, int? quantity}) => CartVariationSelection(
        serviceId: serviceId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        variantKey: variantKey,
        price: price,
        taxAmount: taxAmount,
        service: service,
        cartId: cartId ?? this.cartId,
        quantity: quantity ?? this.quantity,
        variantName: variantName
      );

//  String get variantLabel => variantKey.replaceAll('-', ' ');

  double get subTotal {
    if(price > (discountedPrice ?? 0)){
      return (discountedPrice ?? 0) * quantity;
    }else{
      return price * quantity;
    }
  }
}
