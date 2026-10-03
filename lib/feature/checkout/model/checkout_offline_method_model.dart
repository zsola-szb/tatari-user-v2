class CheckoutOfflineMethodModel {
  String? id;
  String? methodName;
  List<CheckoutOfflinePaymentInformation>? paymentInformation;
  List<CheckoutOfflineCustomerInformation>? customerInformation;

  CheckoutOfflineMethodModel({
    this.id,
    this.methodName,
    this.paymentInformation,
    this.customerInformation,
  });

  CheckoutOfflineMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    methodName = json['method_name'];

    final dynamic paymentInfo = json['payment_information'];
    if (paymentInfo is List) {
      paymentInformation = paymentInfo.whereType<Map<String, dynamic>>().map(CheckoutOfflinePaymentInformation.fromJson).toList();
    }

    final dynamic customerInfo = json['customer_information'];
    if (customerInfo is List) {
      customerInformation = customerInfo.whereType<Map<String, dynamic>>().map(CheckoutOfflineCustomerInformation.fromJson).toList();
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'method_name': methodName,
        'payment_information': paymentInformation?.map((CheckoutOfflinePaymentInformation e) => e.toJson()).toList(),
        'customer_information': customerInformation?.map((CheckoutOfflineCustomerInformation e) => e.toJson()).toList(),
      };
}


class CheckoutOfflinePaymentInformation {
  String? title;
  String? data;

  CheckoutOfflinePaymentInformation({this.title, this.data});

  CheckoutOfflinePaymentInformation.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'title': title, 'data': data};
}

class CheckoutOfflineCustomerInformation {
  String? paymentNote;
  String? fieldName;
  String? placeholder;
  int? isRequired;

  CheckoutOfflineCustomerInformation({
    this.paymentNote,
    this.fieldName,
    this.placeholder,
    this.isRequired,
  });

  CheckoutOfflineCustomerInformation.fromJson(Map<String, dynamic> json) {
    paymentNote = json['payment_note'];
    fieldName = json['field_name'];
    placeholder = json['placeholder'];
    isRequired = int.tryParse(json['is_required'].toString());
  }

  bool get required => isRequired == 1;

  String get label => (fieldName ?? '').replaceAll('_', ' ').capitalizeFirstLetter();

  String get hint => (placeholder ?? '').replaceAll('_', ' ').capitalizeFirstLetter();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'payment_note': paymentNote,
        'field_name': fieldName,
        'placeholder': placeholder,
        'is_required': isRequired,
      };
}

extension _Capitalize on String {
  String capitalizeFirstLetter() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
