class CheckoutPaymentResponseModel {
  String? responseCode;
  String? message;
  CheckoutPaymentResponseContent? content;

  CheckoutPaymentResponseModel({this.responseCode, this.message, this.content});

  CheckoutPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    final dynamic body = json['content'];
    if (body is Map<String, dynamic>) {
      content = CheckoutPaymentResponseContent.fromJson(body);
    }
  }
}

class CheckoutPaymentResponseContent {
  String? bookingId;
  String? bookingRepeatId;
  String? newUserPhone;
  String? loginToken;

  CheckoutPaymentResponseContent({
    this.bookingId,
    this.bookingRepeatId,
    this.newUserPhone,
    this.loginToken,
  });

  CheckoutPaymentResponseContent.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id']?.toString();
    bookingRepeatId = json['booking_repeat_id']?.toString();
    newUserPhone = json['new_user_phone'];
    loginToken = json['login_token'];
  }
}
