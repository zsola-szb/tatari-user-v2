import 'package:get/get.dart';
import 'helper/analytics/analytics_helper.dart';
import 'util/core_export.dart';
import 'helper/get_di.dart' as di;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();

  AnalyticsHelper.init();

  try{
     if(Platform.isAndroid) {
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBYMyaGbvQhVf6YIfH1TEVT56Zs83QASxg", ///current_key here
            appId: "1:889759666168:android:64e5375b02e6121d84d00d", ///mobilesdk_app_id here
            messagingSenderId: "889759666168", ///project_number here
            projectId: "demancms", ///project_id her
          ),
        );
      }catch (e) {
        await Firebase.initializeApp();

      }
    } else {
      await Firebase.initializeApp();
    }
  }catch(e) {
    if (kDebugMode) {
      print('Error initializing Flutter bindings: ${e.toString()}');
    }
  }

  if(defaultTargetPlatform == TargetPlatform.android) {
    await FirebaseMessaging.instance.requestPermission();
  }


  Map<String, Map<String, String>> languages = await di.init();
  NotificationBody? body;
  String? path;
  try {
    path = await initDynamicLinks();

    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }catch(e) {
    if (kDebugMode) {
      print("");
    }
  }
  runApp(MyApp(languages: languages, body: body, route: path,));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  final String? route;
  const MyApp({super.key, required this.languages, required this.body, this.route});


  @override
  State<MyApp> createState() => _MyAppState();

}



Future<String?> initDynamicLinks() async {
  final appLinks = AppLinks();
  final uri = await appLinks.getInitialLink();
  String? path;
  if (uri != null) {
    path = uri.path;
  }else{
    path = null;
  }
  return path;

}

class _MyAppState extends State<MyApp> {
  void _route() async {

    Get.find<SplashController>().getConfigData().then((success) async {

      if(Get.find<LocationController>().getUserAddress() != null){
        AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(addressModel.latitude.toString(), addressModel.longitude.toString(), false);
        addressModel.availableServiceCountInZone = responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }
      Get.find<AuthController>().updateToken();

    });

  }
  @override
  void initState() {
    super.initState();

    if(widget.route != null) {
      Get.find<SplashController>().initSharedData();
      Get.find<SplashController>().getCookiesData();
      Get.find<CartController>().refreshCart();

      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<UserController>().getUserInfo();
      }

      if( Get.find<SplashController>().getGuestId().isEmpty){
        var uuid = const Uuid().v1();
        Get.find<SplashController>().setGuestId(uuid);
      }
      _route();
    }
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
           if((!Get.currentRoute.contains('/splash') &&  Get.currentRoute.isNotEmpty) && splashController.configModel.content == null) {
            return Material(
              child: SplashLogoWidget(),
            );

          } else {
             return GetMaterialApp(
               title: AppConstants.appName,
               debugShowCheckedModeBanner: false,
               navigatorKey: Get.key,
               scrollBehavior: const MaterialScrollBehavior().copyWith(
                 dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
               ),
               theme: themeController.darkTheme ? dark : light,
               locale: localizeController.locale,
               translations: Messages(languages: widget.languages),
               fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
               initialRoute: RouteHelper.getSplashRoute(widget.body, widget.route),
               getPages: RouteHelper.routes,
               defaultTransition: Transition.fadeIn,
               transitionDuration: const Duration(milliseconds: 500),
               builder: (context, widget) => MediaQuery(
                 data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                 child: Material(
                   child: SafeArea(
                     top: false,
                     bottom: GetPlatform.isAndroid,
                     child: Stack(children: [
                       widget!,
                     ]),
                   ),
                 ),
               ),
             );
          }
        });
      });
    });
  }
}