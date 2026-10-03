import 'dart:convert';
import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/common/repo/data_sync_repo.dart';
import 'package:tatarigigs_user/feature/auth/controller/facebook_login_controller.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/repository/subscription_repo.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

final database = AppDatabase();

Future<Map<String, Map<String, String>>> init() async {

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  /// Repository
  Get.lazyPut(() => DataSyncRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AdvertisementRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ServiceRepo(apiClient:Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignDetailsRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProviderBookingRepo(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut(() => ReviewRatingRepo(apiClient: Get.find(), sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut(() => SplashRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthRepo(sharedPreferences:Get.find(),apiClient: Get.find()));
  Get.lazyPut(() => DataSyncRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => CreatePostRepo(apiClient: Get.find()));
  Get.lazyPut(() => ScheduleRepo(apiClient: Get.find()));
  Get.lazyPut(() => CheckoutRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CartRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ConversationRepo(apiClient: Get.find()));
  Get.lazyPut(() => HtmlRepository(apiClient: Get.find()));
  Get.lazyPut(() => MyFavoriteRepo(apiClient: Get.find()));
  Get.lazyPut(() => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient:Get.find() , sharedPreferences: Get.find()));
  Get.lazyPut(() => BookingRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => SubscriptionRepo(apiClient: Get.find(), sharedPreferences: Get.find()));




  /// Controller
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => AdvertisementController(advertisementRepo: Get.find()));
  Get.lazyPut(() => ServiceController(serviceRepo: Get.find()));
  Get.lazyPut(() => ExploreServicesController(serviceRepo: Get.find()));
  Get.lazyPut(() => CampaignController( campaignRepo: Get.find()));
  Get.lazyPut(() => CampaignDetailsController(campaignDetailsRepo: Get.find()));
  Get.lazyPut(() => NearbyProviderController(providerBookingRepo: Get.find()), fenix: true);
  Get.lazyPut(() => ProviderBookingController(providerBookingRepo: Get.find()), fenix: true);
  Get.lazyPut(() => ReviewRatingController(submitReviewRepo: Get.find()), fenix: true,);
  Get.lazyPut(() => ProviderServiceSearchController(providerBookingRepo: Get.find()), fenix: true);
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BottomNavController());
  Get.lazyPut(() => LanguageController());
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => CreatePostController(createPostRepo: Get.find()));
  Get.lazyPut(() => CheckoutScheduleController(checkoutRepo: Get.find()));
  Get.lazyPut(() => CheckoutController(checkoutRepo: Get.find()));
  Get.lazyPut(() => ConversationController(conversationRepo: Get.find()));
  Get.lazyPut(() => HtmlViewController(htmlRepository: Get.find()));
  Get.lazyPut(() => MyFavoriteController(myFavoriteRepo: Get.find()));
  Get.lazyPut(() => AllSearchController(searchRepo: Get.find()));
  Get.lazyPut(() => OffersRepo(apiClient: Get.find()));
  Get.lazyPut(() => OffersController(offersRepo: Get.find()));
  Get.lazyPut(() => NotificationController( notificationRepo: Get.find()));
  Get.lazyPut(() => BookingListController(bookingRepo: Get.find()));
  Get.lazyPut(() => BookingDetailsController(bookingRepo: Get.find()));
  Get.lazyPut(() => BookingRebookController(bookingRepo: Get.find()));
  Get.lazyPut(() => FacebookLoginController());
  Get.lazyPut( ()=> SubscriptionController(subscriptionRepo: Get.find()));


  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));






  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => AllCartController(cartRepo: Get.find()));
  Get.lazyPut(() => CartAddMoreServiceController(searchRepo: Get.find()));




  Get.lazyPut(() => ScheduleController(scheduleRepo: Get.find()));
  Get.lazyPut(() => ServiceAreaController(serviceAreaRepo: ServiceAreaRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
  Get.lazyPut(() => ServiceDetailsController(serviceDetailsRepo: ServiceDetailsRepo(apiClient: Get.find())));


  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonValue = {};
    mappedJson.forEach((key, value) {
      jsonValue[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonValue;
  }
  return languages;
}