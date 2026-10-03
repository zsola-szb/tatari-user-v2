enum SocialLoginType { google, facebook, apple}

enum LoginMedium { manual, otp, social}

enum DiscountType {general, coupon, campaign, refer}

enum SendOtpType {forgetPassword, firebase, verification}

enum EditProfileTabControllerState {generalInfo,accountIno}
enum ToasterMessageType {success, error, info}
enum RepeatBookingType {daily, weekly, custom}

enum ServiceType { all ,regular, repeat}
enum ServiceLocationType { customer, provider}




enum DataSourceEnum {client, local}
enum LocalCachesTypeEnum{all, app, none}
enum ApiMethodType {get, post}


enum BusinessModel {
  curated,
  openMarket;

  static BusinessModel fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'open_market':
      case 'open-market':
        return BusinessModel.openMarket;
      default:
        return BusinessModel.curated;
    }
  }
}

enum HtmlType {
  termsAndCondition('terms-and-conditions'),
  aboutUs('about-us'),
  privacyPolicy('privacy-policy'),
  cancellationPolicy('cancellation-policy'),
  refundPolicy('refund-policy'),
  others('');

  final String value;
  const HtmlType(this.value);

  /// Convert string to enum
  static HtmlType? fromValue(String value) {
    return HtmlType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => others,
    );
  }
}

enum ReviewSource { service, provider }
