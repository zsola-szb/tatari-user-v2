import 'dart:convert';
import 'package:tatarigigs_user/feature/auth/view/update_profile_screen.dart';
import 'package:tatarigigs_user/feature/provider/view/nearby_provider/near_by_provider_screen.dart';
import 'package:tatarigigs_user/feature/subscription/view/my_subscription_details_screen.dart';
import 'package:tatarigigs_user/feature/subscription/view/subscription_screen.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String offers = '/offers';
  static const String signIn = '/sign-in';
  static const String otpLogin = '/otp-login';
  static const String signUp = '/sign-up';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String searchScreen = '/search';
  static const String searchInitScreen = '/search-init';
  static const String serviceDetails = '/service';
  static const String profile = '/profile';
  static const String profileEdit = '/profile-edit';
  static const String notification = '/notification';
  static const String address = '/address';
  static const String checkout = '/checkout';
  static const String bidCheckout = '/bid-checkout';
  static const String offlinePayment = '/offline-payment';
  static const String paymentWebview = '/payment-webview';
  static const String bookingSuccess = '/booking-success';
  static const String digitalPaymentFailed = '/digital-payment-failed';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy-policy';
  static const String cancellationPolicy = '/cancellation-policy';
  static const String refundPolicy = '/refund-policy';
  static const String categories = '/categories';
  static const String categoryProduct = '/category';
  static const String support = '/support';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String allCart = '/all-cart';
  static const String cartAddMoreService = '/cart-add-more-service';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String setLocation = '/set-location';
  static const String locationMapPicker = '/location-map-picker';
  static const String chatScreen = '/chat-screen';
  static const String chatInbox = '/chat-inbox';
  static const String onBoardScreen = '/onBoardScreen';
  static const String settingScreen = '/settingScreen';
  static const String languageScreen = '/language';
  static const String voucherScreen = '/vouchers';
  static const String bookingList = '/booking-list';
  static const String bookingDetails = '/booking-details';
  static const String repeatBookingDetails = '/repeat-booking';
  static const String trackBooking = '/track-booking';
  static const String rateReviewScreen = '/rate-review-screen';
  static const String allServiceScreen = '/services';
  static const String featheredServiceScreen = '/feathered-service-screen';
  static const String subCategoryScreen = '/subcategory-screen';
  static const String notLoggedScreen = '/not-logged-screen';
  static const String suggestService = '/suggest-service';
  static const String suggestServiceList = '/suggest-service-list';
  static const String suggestServiceForm = '/suggest-service-form';
  static const String myWallet = '/my-wallet';
  static const String loyaltyPoint = '/my-point';
  static const String referAndEarn = '/refer-and-earn';
  static const String allProviderList = '/all-provider';
  static const String providerDetailsScreen = '/provider';
  static const String reviewRatingScreen = '/review-rating';
  static const String providerAvailabilityScreen = '/provider-availability-screen';
  static const String createPost = '/create-post';
  static const String createPostSuccessfully = '/create-post-successfully';
  static const String myPost = '/my-post';
  static const String providerOfferList = '/provider-offer-list';
  static const String providerWebView = '/provider-web-view';
  static const String serviceArea = '/service-area';
  static const String serviceAreaMap = '/service-area-map';
  static const String customImageListScreen = '/custom-image-list-screen';
  static const String zoomImage = '/zoom-image';
  static const String favorite = '/favorite';
  static const String nearByProvider = '/nearby-provider';
  static const String maintenance = '/maintenance';
  static const String updateProfile = '/update-profile';
  static const String campaignDetails = '/campaign';
  static const String subscriptionScreen = '/subscriptions';
  static const String mySubscriptionDetails = '/my-subscription-details';

  static String getInitialRoute() => initial;

  static String getSplashRoute(NotificationBody? body, String? route) {
    String data = 'null';
    if (body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data&route=$route';
  }

  static String getOffersRoute() => offers;

  static String getSignInRoute({String? redirectUrl}) {
    final existingRedirect = RedirectRouteValidator._extractRedirectFromCurrentRoute();
    final isIgnoreRedirection = redirectUrl?.contains(RouteHelper.checkout) ?? false;
    final finalRedirect = isIgnoreRedirection ? RouteHelper.home : (existingRedirect ?? redirectUrl);
    return '$signIn?redirect_to=$finalRedirect';
  }

  static String getOtpLoginRoute({String? redirectUrl}) {
    final existingRedirect = RedirectRouteValidator._extractRedirectFromCurrentRoute();
    final isIgnoreRedirection = redirectUrl?.contains(RouteHelper.checkout) ?? false;
    final finalRedirect = isIgnoreRedirection ? RouteHelper.home : (existingRedirect ?? redirectUrl);
    return '$otpLogin?redirect_to=$finalRedirect';
  }

  static String getSignUpRoute({String? redirectUrl}) => '$signUp?redirect_to=$redirectUrl';
  static String getForgotPasswordScreen({String? redirectUrl}) => '$forgotPassword?redirect_to=$redirectUrl';

  static String getVerificationRoute({
    required String identity,
    required String identityType,
    required String fromPage,
    String? firebaseSession,
    String? redirectUrl,
  }) {
    String data = Uri.encodeComponent(jsonEncode(identity));
    String session = base64Url.encode(utf8.encode(firebaseSession ?? ''));
    return '$verification?identity=$data&identity_type=$identityType&redirect_to=$redirectUrl&fromPage=$fromPage&session=$session';
  }

  static String getChangePasswordRoute({ForgetPasswordBody? body, String? redirectUrl}) {
    String data = "";
    if (body != null) {
      List<int> encodedCBody = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encodedCBody);
    }
    return '$changePassword?token=$data&redirect_to=$redirectUrl';
  }

  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';

  static String getPickMapRoute(String page, bool canRoute, String isFromCheckout, ZoneModel? zone, AddressModel? previousAddress) {
    String zoneData = "";
    String addressData = "";
    if (zone != null) {
      List<int> encodedCategory = utf8.encode(jsonEncode(zone.toJson()));
      zoneData = base64Encode(encodedCategory);
    }
    if (previousAddress != null) {
      List<int> encodedAddress = utf8.encode(jsonEncode(previousAddress.toJson()));
      addressData = base64Encode(encodedAddress);
    }
    return '$pickMap?page=$page&route=${canRoute.toString()}&checkout=$isFromCheckout&zone=$zoneData&address=$addressData';
  }

  static String getMainRoute(String page, {AddressModel? previousAddress, String? showServiceNotAvailableDialog}) {
    String data = '';
    if (previousAddress != null) {
      List<int> encoded = utf8.encode(jsonEncode(previousAddress.toJson()));
      data = base64Encode(encoded);
    }
    return '$home?page=$page&address=$data&showDialog=$showServiceNotAvailableDialog';
  }

  static String getSearchInitRoute() => searchInitScreen;

  static String getSearchResultRoute({String? queryText, String? fromPage}) {
    String data = '';
    final String? query = queryText?.trim();
    if (query != null && query != '' && query != 'null') {
      List<int> encoded = utf8.encode(jsonEncode(query));
      data = base64Encode(encoded);
    }
    return '$searchScreen?fromPage=${fromPage ?? ''}&query=$data';
  }

  static String getServiceRoute(String slug, {String fromPage = "others"}) => '$serviceDetails/$slug?fromPage=$fromPage';
  static String getCampaignDetailsRoute(String campaignID) => '$campaignDetails/$campaignID';
  static String getProfileRoute() => profile;
  static String getEditProfileRoute() => profileEdit;
  static String getNotificationRoute() => notification;
  static String getAddressRoute(String fromPage) => '$address?fromProfileScreen=$fromPage';



  static String getCheckoutRoute() => checkout;

  static String getBidCheckoutRoute({
    required String postId,
    required String providerId,
    required String bidId,
    required String amount,
  }) =>
      '$bidCheckout?postId=$postId&providerId=$providerId&bidId=$bidId'
          '&amount=${base64Url.encode(utf8.encode(amount))}';

  static String getOfflinePaymentRoute({
    required String bookingId,
    String? readableId,
    double amount = 0,
    int isPartialPayment = 0,
    bool createdAccount = false,
    SignUpBody? newUserInfo,
  }) {
    final String user = newUserInfo == null ? '' : base64Url.encode(utf8.encode(jsonEncode(newUserInfo.toJson())));
    return '$offlinePayment?id=$bookingId&readable_id=${readableId ?? ''}'
        '&amount=$amount&partial=$isPartialPayment'
        '&created_account=$createdAccount&user=$user';
  }

  static String getPaymentWebviewRoute({
    required String url,
    double amount = 0,
    bool createdAccount = false,
  }) =>
      '$paymentWebview?url=${base64Url.encode(utf8.encode(url))}'
          '&amount=$amount&created_account=$createdAccount';

  static String getBookingSuccessRoute({
    String? readableId,
    String? token,
    bool createdAccount = false,
  }) =>
      '$bookingSuccess?readable_id=${readableId ?? ''}&token=${token ?? ''}'
          '&created_account=$createdAccount';

  static String getDigitalPaymentFailedRoute({double amount = 0}) => '$digitalPaymentFailed?amount=$amount';

  static String getTermsAndConditionsRoute() => termsAndConditions;
  static String getAboutUsRoute() => aboutUs;
  static String getPrivacyPolicyRoute() => privacyPolicy;
  static String getCancellationPolicyRoute() => cancellationPolicy;
  static String getRefundPolicyRoute() => refundPolicy;

  static String getCategoryRoute(String fromPage, String campaignID) => '$categories?fromPage=$fromPage&campaignID=$campaignID';

  static String getCategoryProductRoute(String slug, String name) => '$categoryProduct/$slug?name=$name';
  static String getSupportRoute() => support;
  static String getUpdateRoute(String fromPage) => '$update?update=$fromPage';
  static String getCartRoute({String providerId = ''}) =>
      providerId.isEmpty ? cart : '$cart?provider_id=$providerId';
  static String getAllCartRoute() => allCart;

  /// Where a cart affordance leads. Open market lists the per-provider carts
  /// first; curated goes straight to the single cart.
  static String getCartEntryRoute() => BusinessModelHelper.isOpenMarket ? allCart : cart;

  static String getCartAddMoreServiceRoute() => cartAddMoreService;
  static String getAddAddressRoute(bool fromCheckout) => '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}';

  static String getEditAddressRoute(AddressModel address, bool fromCheckout) {
    String data = base64Url.encode(utf8.encode(jsonEncode(address.toJson())));
    return '$editAddress?data=$data&page=${fromCheckout ? 'checkout' : 'address'}';
  }

  static String getSuggestServiceFormRoute({SuggestedService? editingService}) {
    if (editingService == null) return suggestServiceForm;
    String data = base64Url.encode(utf8.encode(jsonEncode(editingService.toJson())));
    return '$suggestServiceForm?data=$data';
  }

  static String getChatScreenRoute(String channelId, String name, String image, String phone, String userType, {String? fromNotification}) =>
      '$chatScreen?channelID=$channelId&name=$name&image=$image&phone=$phone&userType=$userType&fromNotification=$fromNotification';
  static String getSettingRoute() => settingScreen;
  static String getInboxScreenRoute({String? fromNotification}) => '$chatInbox?fromNotification=$fromNotification';
  static String getVoucherRoute({required String fromPage}) => "$voucherScreen?fromCheckout=$fromPage";

  /// Booking routes (`feature/booking`).
  static String getBookingListRoute({bool isFromMenu = true, String? initialTab}) =>
      '$bookingList?isFromMenu=$isFromMenu${initialTab != null ? '&initialTab=$initialTab' : ''}';

  static String getBookingDetailsRoute({
    String? bookingId,
    String? subBookingId,
    String? phone,
    String? fromPage,
    String? token,
  }) =>
      '$bookingDetails?booking_id=${bookingId ?? ''}&sub_booking_id=${subBookingId ?? ''}'
          '&phone=${Uri.encodeComponent(phone ?? '')}&fromPage=${fromPage ?? ''}&token=${Uri.encodeComponent(token ?? '')}';

  static String getRepeatBookingDetailsRoute({String? bookingId, String? fromPage}) =>
      '$repeatBookingDetails?booking_id=${bookingId ?? ''}&fromPage=${fromPage ?? ''}';

  static String getTrackBookingRoute() => trackBooking;
  static String getRateReviewScreen(String id) => '$rateReviewScreen?id=$id';
  static String allServiceScreenRoute(String categorySlug) => '$allServiceScreen?categorySlug=$categorySlug';
  static String getFeatheredCategoryService(String fromPage, String categorySlug) =>
      '$featheredServiceScreen?fromPage=$fromPage&categorySlug=$categorySlug';
  static String subCategoryScreenRoute(String categoryName, String categorySlug, int subCategoryIndex) =>
      '$subCategoryScreen?categoryName=${Uri.encodeComponent(categoryName)}&categorySlug=$categorySlug&subCategoryIndex=$subCategoryIndex';
  static String getLanguageScreen(String fromPage) => '$languageScreen?fromPage=$fromPage';
  static String getNotLoggedScreen(String redirectUrl, String appbarTitle) => '$notLoggedScreen?redirect_to=$redirectUrl&appbarTitle=$appbarTitle';
  static String getMyWalletScreen({String? flag, String? token, String? fromNotification}) =>
      '$myWallet?flag=$flag&&token=$token&fromNotification=$fromNotification';
  static String getLoyaltyPointScreen({String? fromNotification}) => '$loyaltyPoint?fromNotification=$fromNotification';
  static String getReferAndEarnScreen() => referAndEarn;
  static String getNewSuggestedServiceScreen() => suggestService;
  static String getNewSuggestedServiceList() => suggestServiceList;
  static String getAllProviderRoute() => allProviderList;
  static String getProviderDetails(String providerId) => '$providerDetailsScreen/$providerId';

  /// [id] is a service id for [ReviewSource.service] and a provider id for
  /// [ReviewSource.provider].
  static String getReviewRatingScreen(String id, ReviewSource source) => '$reviewRatingScreen/$id?source=${source.name}';
  static String getProviderAvailabilityScreen(String providerId) => '$providerAvailabilityScreen?provider_id=$providerId';

  static String getCreatePostScreen({PostFullDetails? postData}) {
    if (postData == null) {
      return createPost;
    }
    List<int> encoded = utf8.encode(jsonEncode(postData.toJson()));
    return "$createPost?postData=${base64Encode(encoded)}";
  }

  static String getCreatePostSuccessfullyScreen() => createPostSuccessfully;
  static String getMyPostScreen({String? fromNotification}) => '$myPost?fromNotification=$fromNotification';

  static String getProviderOfferListScreen(String postId, String status) {
    return "$providerOfferList?postId=$postId&status=$status";
  }

  static String getProviderWebView() => providerWebView;
  static String getServiceArea() => serviceArea;
  static String getServiceAreaMap() => serviceAreaMap;
  static String getNearByProviderScreen({int tabIndex = 0}) => "$nearByProvider?tabIndex=$tabIndex";

  static String getCustomImageListScreen({
    required List<String> imageList,
    required String imagePath,
    required int index,
    String? appBarTitle,
    String? createdAt,
  }) {
    String imageListString = base64Encode(utf8.encode(jsonEncode(imageList)));
    return '$customImageListScreen?imageList=$imageListString&imagePath=$imagePath&index=$index&appBarTitle=$appBarTitle&createdAt=$createdAt';
  }

  static String getZoomImageScreen({required String image, required String imagePath, String? createdAt}) =>
      '$zoomImage?image=$image&imagePath=$imagePath&createdAt=$createdAt';
  static String getMyFavoriteScreen() => favorite;
  static String getMaintenanceRoute() => maintenance;

  static String getUpdateProfileRoute({String? phone, String? email, String? tempToken, String? userName, String? redirectUrl}) {
    final String data1 = Uri.encodeComponent(jsonEncode(phone ?? ""));
    final String data2 = Uri.encodeComponent(jsonEncode(email ?? ""));
    final String data3 = Uri.encodeComponent(jsonEncode(tempToken ?? ""));
    final String data4 = Uri.encodeComponent(jsonEncode(userName ?? ""));
    final String decodedRedirectUrl = Uri.encodeComponent(jsonEncode(redirectUrl ?? ""));
    return "$updateProfile?phone=$data1&email=$data2&temp-token=$data3&user-name=$data4&redirect_to=$decodedRedirectUrl";
  }


  static String getSubscriptionRoute() => subscriptionScreen;
  static String getMySubscriptionDetailsRoute() => mySubscriptionDetails;

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => getRoute(const BottomNavScreen(pageIndex: 0, previousAddress: null, showServiceNotAvailableDialog: true)),
    ),
    GetPage(
      name: splash,
      page: () {
        NotificationBody? data;
        if (Get.parameters['data'] != 'null') {
          List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
          data = NotificationBody.fromJson(jsonDecode(utf8.decode(decode)));
        }
        return SplashScreen(body: data, route: Get.parameters['route']);
      },
    ),
    GetPage(name: languageScreen, page: () => LanguageScreen(fromPage: Get.parameters['fromPage'])),
    GetPage(name: offers, page: () => getRoute(const OfferScreen(isFromMenu: true))),
    GetPage(
      name: signIn,
      page: () => SignInScreen(
        exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash,
        redirectRoute: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to']) == null ? null : jsonEncode(Get.parameters),
      ),
      middlewares: [RedirectToHomeMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage(
      name: otpLogin,
      page: () => OtpLoginScreen(
        exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash,
        redirectRoute: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to']) == null ? null : jsonEncode(Get.parameters),
      ),
      middlewares: [RedirectToHomeMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(
        referralCode: Get.parameters['referral_code'],
        redirectRoute: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to']),
      ),
      middlewares: [RedirectToHomeMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage(
      name: accessLocation,
      page: () => AccessLocationScreen(
        fromHome: Get.parameters['page'] == 'home',
        fromSignUp: Get.parameters['page'] == signUp,
        route: null,
      ),
    ),
    GetPage(
      name: pickMap,
      page: () {
        PickMapScreen? pickMapScreen = Get.arguments;
        bool fromAddress = Get.parameters['page'] == 'add-address';
        ZoneModel? zoneData;
        AddressModel? addressData;
        if (Get.parameters['zone'] != "") {
          try {
            List<int> category = base64Decode(Get.parameters['zone'] ?? "");
            zoneData = ZoneModel.fromJson(jsonDecode(utf8.decode(category)));
          } catch (e) {
            if (kDebugMode) print("");
          }
        }
        if (Get.parameters['address'] != "") {
          try {
            List<int> address = base64Decode(Get.parameters['address'] ?? "");
            addressData = AddressModel.fromJson(jsonDecode(utf8.decode(address)));
          } catch (e) {
            if (kDebugMode) print("");
          }
        }
        return (fromAddress && pickMapScreen == null)
            ? const NotFoundScreen()
            : pickMapScreen ??
            PickMapScreen(
              fromSignUp: Get.parameters['page'] == signUp,
              fromAddAddress: fromAddress,
              route: Get.parameters['page'],
              canRoute: Get.parameters['route'] == 'true',
              formCheckout: Get.parameters['checkout'] == 'true',
              zone: zoneData,
              previousAddress: addressData,
            );
      },
    ),
    GetPage(
      name: home,
      page: () {
        AddressModel? addressData;
        if (Get.parameters['address'] != "") {
          try {
            List<int> address = base64Decode(Get.parameters['address']!.replaceAll(" ", "+"));
            addressData = AddressModel.fromJson(jsonDecode(utf8.decode(address)));
          } catch (e) {
            if (kDebugMode) print("Address Model : $addressData");
          }
        }
        return getRoute(BottomNavScreen(
          pageIndex: Get.parameters['page'] == 'home'
              ? 0
              : Get.parameters['page'] == 'booking'
              ? 1
              : Get.parameters['page'] == 'cart'
              ? 2
              : Get.parameters['page'] == 'order'
              ? 3
              : Get.parameters['page'] == 'menu'
              ? 4
              : 0,
          previousAddress: addressData,
          showServiceNotAvailableDialog: Get.parameters['showDialog'] == 'false' ? false : true,
        ));
      },
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgetPassScreen(redirectUrl: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to'] ?? '')),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: verification,
      page: () {
        String data = Uri.decodeComponent(jsonDecode(Get.parameters['identity']!));
        return VerificationScreen(
          identity: data,
          identityType: Get.parameters['identity_type']!,
          fromPage: Get.parameters['fromPage']!,
          firebaseSession: Get.parameters['session'] == 'null' ? null : utf8.decode(base64Url.decode(Get.parameters['session'] ?? '')),
          redirectRoute: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to']),
        );
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: changePassword,
      page: () {
        List<int> decode = base64Decode(Get.parameters['token']!);
        ForgetPasswordBody? forgetPasswordBody = ForgetPasswordBody.fromJson(jsonDecode(utf8.decode(decode)));
        return NewPassScreen(
          forgetPasswordBody: forgetPasswordBody,
          redirectUrl: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to']),
        );
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: allServiceScreen,
      page: () => AllServiceView(categorySlug: Get.parameters['categorySlug']),
    ),
    GetPage(
      name: featheredServiceScreen,
      page: () => AllFeatheredCategoryServiceView(
        fromPage: Get.parameters['fromPage'],
        categorySlug: Get.parameters['categorySlug'],
      ),
    ),
    GetPage(name: searchInitScreen, page: () => getRoute(const SearchInitScreen())),
    GetPage(
      name: searchScreen,
      page: () {
        List<int> decode = [];
        String queryText = '';
        try {
          if (Get.parameters['query'] != '' && Get.parameters['query'] != "null") {
            decode = base64Decode(Get.parameters['query']!.replaceAll(' ', '+'));
            queryText = jsonDecode(utf8.decode(decode));
          }
        } catch (e) {
          if (kDebugMode) print("Error : $e");
        }
        return getRoute(SearchResultScreen(queryText: queryText, fromPage: Get.parameters['fromPage']));
      },
    ),
    GetPage(
      name: '$serviceDetails/:slug',
      binding: ServiceDetailsBinding(),
      page: () => getRoute(
        Get.arguments ?? ServiceDetailsScreen(serviceID: Get.parameters['slug'], fromPage: Get.parameters['fromPage']),
        isIgnoreRouteExistCheck: true,
      ),
    ),
    GetPage(
      name: '$campaignDetails/:campaignID',
      page: () => getRoute(CampaignDetailsScreen(campaign: Get.arguments is CampaignData ? Get.arguments as CampaignData : null)),
    ),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: profileEdit, page: () => getRoute(const EditProfileScreen())),
    GetPage(name: notification, page: () => getRoute(const NotificationScreen())),
    GetPage(
      name: checkout,
      page: () => getRoute(const CheckoutScreen()),
      middlewares: <GetMiddleware>[AuthMiddleware(pageTitle: 'checkout', canGuestCheckout: true)],
    ),
    GetPage(
      name: bidCheckout,
      page: () {
        double amount = 0;
        try {
          amount = double.tryParse(utf8.decode(base64Url.decode(Get.parameters['amount'] ?? ''))) ?? 0;
        } catch (e) {
          printLog('bid checkout: could not decode amount -> $e');
        }
        return getRoute(BidCheckoutScreen(
          postId: Get.parameters['postId'] ?? '',
          providerId: Get.parameters['providerId'] ?? '',
          bidId: Get.parameters['bidId'] ?? '',
          amount: amount,
        ));
      },
    ),
    GetPage(
      name: offlinePayment,
      page: () {
        SignUpBody? newUserInfo;
        final String encodedUser = Get.parameters['user'] ?? '';
        if (encodedUser.isNotEmpty) {
          try {
            newUserInfo = SignUpBody.fromJson(jsonDecode(utf8.decode(base64Url.decode(encodedUser))));
          } catch (e) {
            printLog('offline payment: could not decode user -> $e');
          }
        }
        return OfflinePaymentScreen(
          bookingId: Get.parameters['id'] ?? '',
          readableId: Get.parameters['readable_id'] ?? '',
          amount: double.tryParse(Get.parameters['amount'] ?? '0') ?? 0,
          isPartialPayment: int.tryParse(Get.parameters['partial'] ?? '0') ?? 0,
          createdAccount: Get.parameters['created_account'] == 'true',
          newUserInfo: newUserInfo,
        );
      },
    ),
    GetPage(
      name: paymentWebview,
      page: () {
        String url = '';
        try {
          url = utf8.decode(base64Url.decode(Get.parameters['url'] ?? ''));
        } catch (e) {
          printLog('payment webview: could not decode url -> $e');
        }
        return PaymentWebviewScreen(
          url: url,
          amount: double.tryParse(Get.parameters['amount'] ?? '0') ?? 0,
          createdAccount: Get.parameters['created_account'] == 'true',
        );
      },
    ),
    GetPage(
      name: bookingSuccess,
      page: () => BookingSuccessScreen(
        readableId: Get.parameters['readable_id'] ?? '',
        token: Get.parameters['token'],
        createdAccount: Get.parameters['created_account'] == 'true',
      ),
    ),
    GetPage(
      name: digitalPaymentFailed,
      page: () => DigitalPaymentFailedScreen(amount: double.tryParse(Get.parameters['amount'] ?? '0') ?? 0),
    ),
    GetPage(name: termsAndConditions, page: () => const HtmlViewerScreen(type: HtmlType.termsAndCondition)),
    GetPage(name: aboutUs, page: () => const HtmlViewerScreen(type: HtmlType.aboutUs)),
    GetPage(name: privacyPolicy, page: () => const HtmlViewerScreen(type: HtmlType.privacyPolicy)),
    GetPage(name: cancellationPolicy, page: () => const HtmlViewerScreen(type: HtmlType.cancellationPolicy)),
    GetPage(name: refundPolicy, page: () => const HtmlViewerScreen(type: HtmlType.refundPolicy)),
    GetPage(
      name: '$categoryProduct/:slug',
      page: () => getRoute(
        CategorySubCategoryScreen(categorySlug: Get.parameters['slug'] ?? '', categoryName: Get.parameters['name'] ?? ''),
        isIgnoreRouteExistCheck: true,
      ),
    ),
    GetPage(name: support, page: () => SupportScreen()),
    GetPage(name: update, page: () => UpdateScreen(fromPage: Get.parameters['update'])),
    GetPage(
      name: cart,
      page: () => getRoute(CartScreen(fromNav: false, providerId: Get.parameters['provider_id'] ?? '')),
    ),
    GetPage(name: allCart, page: () => getRoute(const AllCartScreen())),
    GetPage(name: cartAddMoreService, page: () => getRoute(const CartAddMoreServiceScreen())),
    GetPage(name: addAddress, page: () => AddAddressScreen(fromCheckout: Get.parameters['page'] == 'checkout')),
    GetPage(
      name: editAddress,
      page: () {
        AddressModel? address;
        try {
          address = AddressModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['data']!.replaceAll(' ', '+')))));
        } catch (e) {
          if (kDebugMode) print(e);
        }
        return getRoute(AddAddressScreen(fromCheckout: Get.parameters['page'] == 'checkout', address: address));
      },
    ),
    GetPage(name: setLocation, page: () => const SetLocationScreen()),
    GetPage(name: locationMapPicker, page: () => const LocationMapScreen()),
    GetPage(
      name: chatScreen,
      transition: Transition.topLevel,
      page: () => ConversationDetailsScreen(
        channelID: Get.parameters['channelID'],
        name: Get.parameters['name'],
        phone: Get.parameters['phone'],
        image: Get.parameters['image'],
        userType: Get.parameters['userType'] ?? "",
        formNotification: Get.parameters['fromNotification'] ?? "",
      ),
    ),
    GetPage(
      name: chatInbox,
      binding: ConversationBinding(),
      page: () => ConversationListScreen(fromNotification: Get.parameters['fromNotification']),
      middlewares: [AuthMiddleware(pageTitle: 'inbox')],
    ),
    GetPage(
      name: address,
      page: () => AddressScreen(fromPage: Get.parameters['fromProfileScreen']),
      middlewares: [AuthMiddleware(pageTitle: 'my_address')],
    ),
    GetPage(binding: OnBoardBinding(), name: onBoardScreen, page: () => const OnBoardingScreen()),
    GetPage(name: settingScreen, page: () => const SettingScreen()),
    GetPage(name: voucherScreen, page: () => getRoute(CouponScreen(fromCheckout: Get.parameters['fromCheckout'] == "checkout"))),
    /// Booking screens — registered without a binding; their controllers live
    /// in `get_di.dart`, as with `checkout`/`cart`.
    GetPage(
      name: bookingList,
      page: () => BookingListScreen(
        isFromMenu: Get.parameters['isFromMenu'] == 'true',
        initialTab: Get.parameters['initialTab'],
      ),
      middlewares: <GetMiddleware>[AuthMiddleware(pageTitle: 'my_bookings')],
    ),
    GetPage(
      name: bookingDetails,
      page: () => BookingDetailsScreen(
        bookingId: Get.parameters['booking_id'],
        subBookingId: Get.parameters['sub_booking_id'],
        phone: Get.parameters['phone'],
        fromPage: Get.parameters['fromPage'],
        token: Get.parameters['token'],
      ),
    ),
    GetPage(
      name: repeatBookingDetails,
      page: () => RepeatBookingDetailsScreen(
        bookingId: Get.parameters['booking_id'] ?? '',
        fromPage: Get.parameters['fromPage'],
      ),
    ),
    GetPage(name: trackBooking, page: () => const BookingTrackScreen()),
    GetPage(
      binding: ServiceBinding(),
      name: subCategoryScreen,
      page: () => SubCategoryScreen(
        categoryTitle: Get.parameters['categoryName'],
        categorySlug: Get.parameters['categorySlug'],
        subCategoryIndex: int.tryParse(Get.parameters['subCategoryIndex'] ?? ""),
      ),
    ),
    GetPage(name: rateReviewScreen, page: () => RateReviewScreen(id: Get.parameters['id'])),
    GetPage(
      name: notLoggedScreen,
      page: () => NotLoggedInScreen(
        redirectUrl: RedirectRouteValidator.getValidRoute(Get.parameters['redirect_to'] ?? '') ?? '',
        appbarTitle: Get.parameters['appbarTitle'] ?? '',
      ),
    ),
    GetPage(binding: SuggestServiceBinding(), name: suggestService, page: () => getRoute(const SuggestServiceScreen())),
    GetPage(
      binding: SuggestServiceBinding(),
      name: suggestServiceList,
      page: () => getRoute(const SuggestServiceScreen()),
    ),
    GetPage(
      binding: SuggestServiceBinding(),
      name: suggestServiceForm,
      page: () {
        SuggestedService? editingService;
        final String? encodedData = Get.parameters['data'];
        if (encodedData != null && encodedData.isNotEmpty) {
          try {
            editingService = SuggestedService.fromJson(jsonDecode(utf8.decode(base64Url.decode(encodedData.replaceAll(' ', '+')))));
          } catch (e) {
            if (kDebugMode) print(e);
          }
        }
        return getRoute(CreateSuggestServiceScreen(editingService: editingService));
      },
    ),
    GetPage(
      binding: WalletBinding(),
      name: myWallet,
      page: () => WalletScreen(
        status: Get.parameters['flag'],
        token: Get.parameters['token'],
        fromNotification: Get.parameters['fromNotification'],
      ),
    ),
    GetPage(
      binding: LoyaltyPointBinding(),
      name: loyaltyPoint,
      page: () => LoyaltyPointScreen(fromNotification: Get.parameters['fromNotification']),
    ),
    GetPage(
      name: referAndEarn,
      page: () => const ReferAndEarnScreen(),
      middlewares: [AuthMiddleware(pageTitle: 'refer_and_earn')],
    ),
    GetPage(name: allProviderList, page: () => getRoute(const AllProviderView())),
    GetPage(
      name: '$providerDetailsScreen/:id',
      page: () => getRoute(ProviderDetailsScreen(providerId: Get.parameters['id']!), isIgnoreRouteExistCheck: true),
    ),
    GetPage(
      name: '$reviewRatingScreen/:id',
      page: () => getRoute(ReviewRatingScreen(
        id: Get.parameters['id'] ?? '',
        source: Get.parameters['source'] == ReviewSource.provider.name ? ReviewSource.provider : ReviewSource.service,
      )),
    ),
    GetPage(
      name: providerAvailabilityScreen,
      page: () => getRoute(ProviderAvailabilityWidget(providerId: Get.parameters['provider_id']!)),
    ),
    GetPage(
      name: createPost,
      page: () {
        PostFullDetails? post;
        String? encodedPost = Get.parameters['postData'];
        if (encodedPost != null) {
          try {
            List<int> decode = base64Decode(encodedPost.replaceAll(' ', '+'));
            post = PostFullDetails.fromJson(jsonDecode(utf8.decode(decode)));
          } catch (e) {
            if (kDebugMode) print(e);
          }
        }
        return CreatePostScreen(postData: post);
      },
      middlewares: [AuthMiddleware(pageTitle: 'create_post')],
    ),
    GetPage(name: createPostSuccessfully, page: () => getRoute(const PostCreateSuccessfullyScreen())),
    GetPage(
      name: myPost,
      page: () => AllPostScreen(fromNotification: Get.parameters["fromNotification"]),
      middlewares: [AuthMiddleware(pageTitle: 'my_posts')],
    ),
    GetPage(
      name: providerOfferList,
      page: () => ProviderOfferListScreen(postId: Get.parameters['postId'], status: Get.parameters['status']),
    ),
    GetPage(name: providerWebView, page: () => const ProviderWebView()),
    GetPage(name: serviceArea, page: () => const ServiceAreaScreen()),
    GetPage(name: serviceAreaMap, page: () => const ServiceAreaMapScreen()),
    GetPage(
      name: nearByProvider,
      page: () => NearByProviderScreen(tabIndex: int.tryParse(Get.parameters['tabIndex'] ?? "0") ?? 0),
    ),
    GetPage(
      name: customImageListScreen,
      page: () {
        List<int> decode = base64Decode(Get.parameters['imageList']!.replaceAll(' ', '+'));
        var value = jsonDecode(utf8.decode(decode));
        List<String> imageList = (value as List).map((item) => item.toString()).toList();
        return ImageDetailScreen(
          imageList: imageList,
          index: int.parse(Get.parameters['index']!),
          appbarTitle: Get.parameters['appBarTitle'],
          createdAt: Get.parameters['createdAt'],
        );
      },
    ),
    GetPage(
      name: zoomImage,
      page: () => ZoomImage(
        image: Get.parameters['image']!,
        imagePath: Get.parameters['imagePath']!,
        createdAt: Get.parameters['createdAt'],
      ),
    ),
    GetPage(
      name: favorite,
      middlewares: [AuthMiddleware(pageTitle: 'my_favorite')],
      page: () => const MyFavoriteScreen(),
    ),
    GetPage(name: maintenance, page: () => const MaintenanceScreen()),
    GetPage(
      name: updateProfile,
      page: () {
        String phone = Uri.decodeComponent(jsonDecode(Get.parameters['phone'] ?? ""));
        String email = Uri.decodeComponent(jsonDecode(Get.parameters['email'] ?? ""));
        String tempToken = Uri.decodeComponent(jsonDecode(Get.parameters['temp-token'] ?? ""));
        String userName = Uri.decodeComponent(jsonDecode(Get.parameters['user-name'] ?? ""));
        String redirectTo = Uri.decodeComponent(jsonDecode(Get.parameters['redirect_to'] ?? ""));
        return UpdateProfileScreen(
          phone: phone,
          email: email,
          tempToken: tempToken,
          userName: userName,
          redirectUrl: RedirectRouteValidator.getValidRoute(redirectTo),
        );
      },
    ),
    GetPage(
      name: subscriptionScreen,
      middlewares: [AuthMiddleware(pageTitle: 'subscription_plan')],
      page: () {
        if (Get.find<SplashController>().configModel.content?.isProFeatureActive == 1) {
          return const SubscriptionScreen();
        } else {
          return BottomNavScreen(pageIndex: 0, previousAddress: null, showServiceNotAvailableDialog: false);
        }
      },
    ),
    GetPage(
      name: mySubscriptionDetails,
      middlewares: [AuthMiddleware(pageTitle: 'subscription_plan')],
      page: () => const MySubscriptionDetailsScreen(),
    ),
  ];

  static Widget getRoute(Widget navigateTo, {bool isIgnoreRouteExistCheck = false}) {
    return Get.find<LocationController>().getUserAddress() != null
        ? navigateTo
        : AccessLocationScreen(fromSignUp: false, route: Get.currentRoute);
  }

  static ({String path, Map<String, String>? parameters}) parseRedirectRouteToNavigate(String redirectRoute) {
    try {
      final decodedParams = jsonDecode(redirectRoute) as Map<String, dynamic>;
      final redirectPath = decodedParams['redirect_to'] ?? RouteHelper.initial;
      final uri = Uri.parse(redirectPath);
      final mergedParameters = _mergeRouteParameters(uri, decodedParams);
      final cleanPath = uri.path.isNotEmpty ? uri.path : RouteHelper.initial;
      return (path: cleanPath, parameters: mergedParameters);
    } catch (e) {
      if (kDebugMode) print('Error parsing redirect route: $e');
      return _defaultRouteData();
    }
  }

  /// Merges query parameters from URI and decoded JSON, excluding 'redirect_to'
  static Map<String, String>? _mergeRouteParameters(Uri uri, Map<String, dynamic> decodedParams) {
    final parameters = <String, String>{...uri.queryParameters};
    decodedParams.forEach((key, value) {
      if (key != 'redirect_to' && value != null) {
        parameters[key] = value.toString();
      }
    });
    if (parameters.isEmpty) return null;
    return parameters;
  }

  /// Returns default route data for error cases
  static ({String path, Map<String, String> parameters}) _defaultRouteData() {
    return (path: RouteHelper.initial, parameters: <String, String>{});
  }
}

class RedirectToHomeMiddleware extends GetMiddleware {
  final AuthController authController = Get.find<AuthController>();

  @override
  int? get priority => 0; // High priority to check before others

  @override
  RouteSettings? redirect(String? route) {
    if (!authController.isLoggedIn()) return null;
    return RouteSettings(name: RouteHelper.home);
  }
}

class AuthMiddleware extends GetMiddleware {
  final String? pageTitle;
  final bool canGuestCheckout;
  // ⚠️ Ensure your AuthService is initialized, e.g., in GetMaterialApp bindings or main()
  final AuthController authController = Get.find<AuthController>();

  AuthMiddleware({required this.pageTitle, this.canGuestCheckout = false});

  @override
  int? get priority => 1; // High priority to check before others

  @override
  RouteSettings? redirect(String? route) {
    final bool isAbleToCheckout = (canGuestCheckout && Get.find<SplashController>().configModel.content?.guestCheckout == 1);
    if (isAbleToCheckout) return null;

    if (!authController.isLoggedIn()) {
      // 1. URL-encode the *full* current route (e.g., /booking-details?id=123)
      final String encodedIntendedRoute = Uri.encodeComponent(route ?? RouteHelper.initial);

      // 2. Redirect to the login screen, adding the intended route as a query parameter
      // The resulting URL will look like: /sign-in?redirect_to=%2Fbooking-details%3Fid%3D123
      return RouteSettings(name: RouteHelper.getNotLoggedScreen(encodedIntendedRoute, pageTitle ?? ''));
    }

    // User is logged in, proceed to the intended route
    return null;
  }
}

class RedirectRouteValidator {
  // Private constructor to prevent instantiation
  RedirectRouteValidator._();

  /// Routes that should never be used as redirect targets.
  /// These are authentication flow routes that would create redirect loops.
  static const Set<String> _authenticationRoutes = {
    RouteHelper.signIn,
    RouteHelper.otpLogin,
    RouteHelper.signUp,
    RouteHelper.forgotPassword,
    RouteHelper.verification,
    RouteHelper.changePassword, // Consider adding this too
  };

  static String? getValidRoute(String? route) {
    // Early return for null/empty/invalid values - O(1)
    if (route == null || route.isEmpty || route == 'null') {
      return null;
    }

    // Check if route contains any authentication pattern - O(n*m)
    // Short-circuits on first match for better average performance
    final isAuthRoute = _authenticationRoutes.any(route.contains);

    return isAuthRoute ? null : route;
  }

  static String? _extractRedirectFromCurrentRoute() {
    try {
      final uri = Uri.parse(Get.currentRoute);
      final redirect = uri.queryParameters['redirect_to'];
      // Return null if empty or 'null' string
      return (redirect?.isNotEmpty ?? false) ? redirect : null;
    } catch (e) {
      if (kDebugMode) print('Error parsing current route: $e');
      return null;
    }
  }
}