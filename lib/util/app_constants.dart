import 'package:tatarigigs_user/util/core_export.dart';

class AppConstants {


  static const String appName = 'Tatarigigs';
  static const String appVersion = '4.0'; /// Flutter SDK : 3.47.5
  static const String baseUrl = 'YOUR_BASE_URL_HERE';
  static const String websiteUrl = 'YOUR_WEBSITE_URL_HERE';
  static const String googleServerClientId = '889759666168-ruq4mnv8fonls4gfvn01t2jap0f0662u.apps.googleusercontent.com'; /// find that in android/app/google-services.json || use client_type 3
  static const bool avoidMaintenanceMode = false;
  static const String fontFamily = 'DMSans';
  static const LocalCachesTypeEnum cachesType = LocalCachesTypeEnum.all;
  static const String categoryUrl = '/api/v2/customer/categories';
  static const String webLandingContents = '/api/v1/customer/landing/contents';
  static const String bannerUri = '/api/v2/customer/banner?limit=10&offset=1';
  static const String bonusUri = '/api/v1/customer/bonus-list?limit=100&offset=1';
  static const String allServiceUri = '/api/v2/customer/service';
  static const String categoryWiseServiceUri = '/api/v2/customer/categories/service/';
  static const String popularServiceUri = '/api/v2/customer/service/popular';
  static const String trendingServiceUri = '/api/v2/customer/service/trending';
  static const String recentlyViewedServiceUri = '/api/v2/customer/service/recently-viewed';
  static const String recommendedServiceUri = '/api/v2/customer/service/recommended';
  static const String recommendedSearchUri = '/api/v2/customer/service/search/recommended';
  static const String offerListUri = '/api/v2/customer/service/offers';
  static const String serviceBasedOnSubcategory = '/api/v2/customer/service/sub-category/';
  static const String serviceDetailsUri = '/api/v2/customer/service/detail';
  static const String serviceReviewListUri = '/api/v2/customer/service/review';
  static const String subcategoryUri = '/api/v2/customer/categories/children?limit=20&offset=1&slug=';
  static const String categoryServiceUri = '/api/v1/categories/service/';
  static const String configUri = '/api/v1/customer/config';
  static const String customerRemove = '/api/v1/customer/remove-account';
  static const String registerUri = '/api/v1/customer/auth/registration';
  static const String loginUri = '/api/v1/customer/auth/login';
  static const String loginOut = '/api/v1/customer/auth/logout';
  static const String addToCart = '/api/v2/customer/cart/add';
  static const String getCartList = '/api/v2/customer/cart/list';
  static const String removeCartItem = '/api/v2/customer/cart/remove/';
  static const String removeAllCartItem = '/api/v2/customer/cart/empty';
  static const String updateCartQuantity = '/api/v2/customer/cart/update-quantity/';
  static const String updateCartProvider = '/api/v2/customer/cart/update/provider';
  static const String customersAlsoTake = '/api/v2/customer/cart/customers-also-take';
  static const String getCartProviders = '/api/v2/customer/cart/providers';
  static const String tokenUri = '/api/v1/customer/update/fcm-token';
  static const String bookingList = '/api/v2/customer/booking';
  static const String bookingDetails = '/api/v1/customer/booking';
  static const String subBookingDetails = '/api/v1/customer/booking/single';
  static const String repeatBookingDetails = '/api/v1/customer/booking/repeat';
  static const String trackBooking = '/api/v2/customer/booking/track';
  static const String bookingCancel = '/api/v1/customer/booking/status-update';
  static const String subBookingCancel = '/api/v1/customer/booking/single-repeat-cancel';
  static const String serviceReview = '/api/v1/customer/review/submit';
  static const String bookingReviewList = '/api/v1/customer/review';
  static const String otherInfo = '/api/v1/customer/cart/other-info';
  static const String placeRequest = '/api/v2/customer/booking/place';
  static const String addressUri = '/api/v2/customer/address';
  static const String zoneUri = '/api/v1/customer/config/get-zone-id';
  static const String customerInfoUri = '/api/v1/customer/info';
  static const String couponUri = '/api/v2/customer/coupon?limit=100&offset=1';
  static const String applicableCouponUri = '/api/v2/customer/coupon/applicable';
  static const String applyCoupon = '/api/v2/customer/coupon/apply';
  static const String removeCoupon = '/api/v2/customer/coupon/remove';
  static const String orderCancelUri = '/api/v1/customer/order/cancel';
  static const String codSwitchUri = '/api/v1/customer/order/payment-method';
  static const String orderDetailsUri = '/api/v1/customer/order/details?order_id=';
  static const String notificationUri = '/api/v2/customer/notifications';
  static const String updateProfileUri = '/api/v1/customer/update/profile';
  static const String searchUri = '/api/v2/customer/service/search';
  static const String searchServicesUri = '/api/v2/customer/service/search/services';
  static const String searchProvidersUri = '/api/v2/customer/service/search/providers';
  static const String searchSuggestion = '/api/v2/customer/service/search-suggestion';
  static const String suggestedSearchUri = '/api/v1/customer/recently-searched-keywords';
  static const String removeSuggestedServiceUri = '/api/v1/customer/remove-searched-keywords';
  static const String campaignUri = '/api/v2/customer/campaign?limit=10&offset=1';
  static const String campaignSelectedServicesUri = '/api/v2/customer/campaign/selected-services';
  static const String campaignCategoriesUri = '/api/v2/customer/campaign/categories';
  static const String campaignCategoryServicesUri = '/api/v2/customer/campaign/category-services';
  static const String searchLocationUri = '/api/v1/customer/config/place-api-autocomplete';
  static const String placeDetailsUri = '/api/v1/customer/config/place-api-details';
  static const String geocodeUri = '/api/v1/customer/config/geocode-api';
  static const String socialLoginUri = '/api/v1/customer/auth/social-login';
  static const String updateZoneUri = '/api/v1/customer/update-zone';
  static const String createChannel = '/api/v1/customer/chat/create-channel';
  static const String getChannelListUrl = '/api/v1/customer/chat/channel-list';
  static const String searchChannelListUrl = '/api/v1/customer/chat/channel-list-search';
  static const String getConversation = '/api/v1/customer/chat/conversation';
  static const String sendMessage = '/api/v1/customer/chat/send-message';
  static const String pagesDetailsApi = '/api/v1/customer/config/page-details';
  static const String submitNewServiceRequest = '/api/v2/customer/service/suggestion/make';
  static const String getSuggestedServiceList = '/api/v2/customer/service/suggestion/list';
  static const String updateServiceRequest = '/api/v2/customer/service/suggestion/update';
  static const String deleteServiceRequest = '/api/v2/customer/service/suggestion/delete';
  static const String convertLoyaltyPointUri = '/api/v1/customer/loyalty-point/wallet-transfer';
  static const String loyaltyPointTransactionData = '/api/v1/customer/loyalty-point-transaction';
  static const String walletTransactionData = '/api/v1/customer/wallet-transaction';
  static const String getProviderList = '/api/v2/customer/providers';
  static const String getProviderDetails = '/api/v2/customer/providers';
  static const String getProviderBasedOnSubcategory = '/api/v1/customer/provider/list-by-sub-category';
  static const String getFeaturedCategoryService = '/api/v2/customer/categories/featured?limit=100&offset=1';

  static const String createCustomizedPost = '/api/v2/customer/post';
  static const String deletePost = '/api/v2/customer/post/delete';
  static const String getMyPostList = '/api/v2/customer/post';
  static const String getInterestedProviderList = '/api/v2/customer/post/bid';
  static const String updatePostStatus = '/api/v2/customer/post/bid/update-status';
  static const String checkoutPostDetails = '/api/v2/customer/post/details';
  static const String getPostDetails = '/api/v2/customer/post/details';
  static const String updatePostInfo = '/api/v2/customer/post/update';
  static const String getProviderBidDetails = '/api/v1/customer/post/bid/details';

  static const String sendOtpForVerification = '/api/v1/user/verification/send-otp';
  static const String sendOtpForForgetPassword = '/api/v1/user/forget-password/send-otp';
  static const String verifyOtpForForgetPasswordScreen = '/api/v1/user/forget-password/verify-otp';
  static const String verifyOtpForVerificationScreen = '/api/v1/user/verification/verify-otp';
  static const String phoneOtpVerification= '/api/v1/user/verification/login-otp-verify';
  static const String firebaseOtpVerify = '/api/v1/user/verification/firebase-auth-verify';
  static const String registerWithOtp = '/api/v1/user/verification/registration-with-otp';
  static const String resetPasswordUri = '/api/v1/user/forget-password/reset';

  static const String offlinePaymentUri = '/api/v1/customer/offline-payment/methods?limit=100&offset=1';
  static const String getZoneListApi = '/api/v1/customer/service/area-availability?offset=1&limit=200';
  static const String rebookApi = '/api/v2/customer/rebook/cart-add';
  static const String rebookAvailabilityApi = '/api/v2/customer/booking/rebooking';
  static const String changeLanguage = '/api/v1/customer/change-language';

  static const String getFavoriteServiceList = '/api/v2/customer/favorite/service-list';
  static const String removeFavoriteService = "/api/v1/customer/favorite/service-delete";
  static const String updateFavoriteServiceStatus = "/api/v1/customer/favorite/service";
  static const String getFavoriteProviderList = '/api/v1/customer/favorite/provider-list';
  static const String removeFavoriteProvider = "/api/v1/customer/favorite/provider-destroy";
  static const String updateFavoriteProviderStatus = "/api/v1/customer/favorite/provider";

  static const String advertisementList = '/api/v2/customer/advertisements/ads-list?limit=50&offset=1';
  static const String registerWithSocialMedia = '/api/v1/customer/auth/registration-with-social-media';
  static const String existingAccountCheck = '/api/v1/customer/auth/existing-account-check';
  static const String regularBookingInvoiceUrl = '/admin/booking/customer-invoice/';
  static const String repeatBookingInvoiceUrl = '/admin/booking/customer-fullbooking-invoice/';
  static const String singleRepeatBookingInvoiceUrl = '/admin/booking/customer-fullbooking-single-invoice/';
  static const String addError404Url = '/api/v1/customer/error-link';
  static const String checkExistingUser = '/api/v1/user/check-existing-customer';
  static const String offlinePaymentDataStore = '/api/v1/customer/booking/store-offline-payment-data';
  static const String switchPaymentMethod = '/api/v1/customer/booking/switch-payment-method';
  static const String digitalPaymentResponse = '/api/v1/digital-payment-booking-response';
  static const String newsLetterSubscription = '/api/v1/customer/subscribe-newsletter';
  static const String subscribeToTopic = '/api/v1/customer/fcm-subscribe-to-topic';
  static const String easyRebookingList = '/api/v2/customer/booking/rebooking/list';
  static const String getSubscriptionPlanList = '/api/v1/customer/subscription/details';
  static const String getSubscriptionTermsAndCondition = '/api/v1/customer/subscription/terms-and-conditions';
  static const String subscribePlan = '/api/v1/customer/subscription/subscribe';
  static const String subscriptionCancel = '/api/v1/customer/subscription/cancel';
  static const String checkServicePriceUpdated = '/api/v2/customer/booking/cart-check';



  /// Shared Key
  static const String theme = 'demand_theme';
  static const String token = 'demand_token';
  static const String guestId = 'guest_id';
  static const String countryCode = 'demand_country_code';
  static const String languageCode = 'demand_language_code';
  static const String acceptCookies = 'demand_accept_cookies';
  static const String userPassword = 'demand_user_password';
  static const String userAddress = 'demand_user_address';
  static const String userNumber = 'demand_user_number';
  static const String userCountryCode = 'demand_user_country_code';
  static const String notification = 'demand_notification';
  static const String searchHistory = 'demand_search_history';
  static const String recentPickedLocation = 'demand_recent_picked_location';
  static const String notificationCount = 'demand_notification_count';
  static const String initialLanguage = 'initial-language';
  static const String onboardingScreen = 'onboarding_screen';
  static const String cookiesManagement = 'cookies_management';
  static const String topic = 'customer';
  static const String zoneId = 'zoneId';
  static const String localizationKey = 'X-localization';
  static const String walletAccessToken = 'wallet_access_token';
  static const String isContinueZone = 'isContinue';
  static const String referredBottomSheet = 'referred_bottom_sheet';
  static const String lastIncompleteOfflineBookingId = 'last_incomplete_offline_booking_id';
  static const String proDiscountAmount = 'pro_discount_amount';
  static const String previousRoute = 'set_previous_route';
  static const String tabIndex = 'tab_index';


  static Map<String, String> configHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
    AppConstants.zoneId : 'configuration',
  };

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.us, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.ar, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.bn, languageName: 'বাংলা', countryCode: 'BD', languageCode: 'bn'),
    LanguageModel(imageUrl: Images.india, languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
  ];


  static const int limitOfPickedIdentityImageNumber = 2;
  static const double balanceInputLength = 10;

  static const double maxLimitOfTotalFileSent = 5;

  static final List<Map<String, String>> walletTransactionSortingList = [
    {
      'title' : 'all_transactions',
      'value' : ''
    },
    {
      'title' : 'booking_transaction',
      'value' : 'wallet_payment'
    },
    {
      'title' : 'converted_from_loyalty_point',
      'value' : 'loyalty_point_earning'
    },
    {
      'title' : 'added_via_payment_method',
      'value' : 'add_fund'
    },
    {
      'title' : 'earned_by_bonus',
      'value' : 'add_fund_bonus'
    },
    {
      'title' : 'earned_by_referral',
      'value' : 'referral_earning'
    },
    {
      'title' : 'admin_fund',
      'value' : 'fund_by_admin'
    },
    {
      'title' : 'refund',
      'value' : 'booking_refund'
    },
  ];

  /// Allowed image file extensions for upload
  static const List<String> allowedImageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
  ];

  /// Allowed document file extensions for upload
  static const List<String> _allowedDocumentExtensions = [
    'pdf',
    'csv',
    'txt',
    'xls',
    'xlsx',
    'doc',
    'docx',
  ];

  static const List<String> allowPdfFormat = [
    'pdf'
  ];

  static const List<String> allowDocFormat = [
    'doc', 'docx'
  ];

  /// All allowed file extensions (images + documents)
  static const List<String> allowedFileExtensions = [
    ...allowedImageExtensions,
    ..._allowedDocumentExtensions,
  ];

  /// Default image quality for image picker (0-100)
  static const int defaultImageQuality = 80;




}
