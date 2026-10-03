import 'dart:convert';
import 'dart:math';
import 'package:tatarigigs_user/common/widgets/demo_reset_dialog_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_ignored_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/provider_withdraw_bid_dialog.dart';
import 'package:tatarigigs_user/feature/subscription/widget/subscription_expire_reminder_widget.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tatarigigs_user/util/core_export.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(settings: initializationsSettings, onDidReceiveNotificationResponse: (payload) async {
      if (kDebugMode) {
        print("Payload: $payload");
      }

      try{
        if(payload.payload!=null && payload.payload!=''){
          NotificationBody notificationBody = NotificationBody.fromJson(jsonDecode(payload.payload!));
          if (kDebugMode) {
            print("Type: ${notificationBody.notificationType}");
          }
          if(notificationBody.notificationType == "new_message"){

            if(Get.currentRoute.contains(RouteHelper.chatScreen)){
              Get.back();
              Get.back();
            } else if(Get.currentRoute.contains(RouteHelper.chatInbox)){
              Get.back();
            }
            Get.toNamed(RouteHelper.getChatScreenRoute(
                notificationBody.channelId??"",
                notificationBody.userType == 'super-admin' ? "admin" : notificationBody.userName??"",
                notificationBody.userProfileImage??"",
                notificationBody.userPhone??"",
                notificationBody.userType??"",
                fromNotification: "fromNotification"
            ));
          }
          else if(notificationBody.notificationType == 'custom_request_posted' || notificationBody.notificationType == 'new_offer_received' || notificationBody.notificationType == 'offer_withdrawn'){
            Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
          }

          else if(notificationBody.notificationType == 'account_deactivated'){
            Get.find<AuthController>().clearSharedData();
            Get.offNamed(RouteHelper.getSignInRoute());
          }
          else if(notificationBody.notificationType == 'wallet_bonus_received' || notificationBody.notificationType == 'wallet_topped_up'){
            if(!Get.currentRoute.contains(RouteHelper.myWallet)){
              Get.toNamed(RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
            }else{
              Get.find<WalletController>().getWalletTransactionData(1, reload: true);
            }
          }
          else if(notificationBody.notificationType == 'loyalty_points_earned'){
            if(!Get.currentRoute.contains(RouteHelper.loyaltyPoint)){
              Get.toNamed(RouteHelper.getLoyaltyPointScreen(fromNotification: "fromNotification"));
            }
          }
          else if( _isBooking(notificationBody.notificationType ?? '') && notificationBody.bookingId !=null && notificationBody.bookingId!=''){
            if(notificationBody.bookingType == "repeat" && notificationBody.repeatBookingType == "single"){
              Get.toNamed(RouteHelper.getBookingDetailsRoute(subBookingId: notificationBody.bookingId!, fromPage: 'fromNotification'));
            }else if(notificationBody.bookingType == "repeat" && notificationBody.repeatBookingType != "single"){
              Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId: notificationBody.bookingId, fromPage: 'fromNotification'));
            }else{
              Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId: notificationBody.bookingId!, fromPage: 'fromNotification'));
            }
          } else if(notificationBody.notificationType=='privacy_policy' && notificationBody.title!=null && notificationBody.title!=''){
            Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
          }else if(notificationBody.notificationType=='terms_and_conditions' && notificationBody.title!=null && notificationBody.title!=''){
              Get.toNamed(RouteHelper.getTermsAndConditionsRoute());
          }else if(notificationBody.notificationType == 'subscription_expiring_soon' || notificationBody.notificationType == 'subscription_expired'){
              Get.toNamed(RouteHelper.getSubscriptionRoute());
          }else if(notificationBody.notificationType == 'subscription_activated'){
            Get.toNamed(RouteHelper.getMySubscriptionDetailsRoute());
          }else{
              Get.toNamed(RouteHelper.getNotificationRoute());
          }
        }
      }catch (e) {
        if (kDebugMode) {
          print("");
        }
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: Notification Type => ${message.data["type"]}/ Title => ${message.data['title']} ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
        print("onMessage: Notification Body => ${message.data.toString()}");
      }
      {
        if(message.data['type']=='new_offer_received' || message.data['type']=='custom_request_posted'){

          if((message.data['post_id']!="" && message.data['post_id']!=null) && (message.data['provider_id']!="" && message.data['provider_id']!=null)){
            Get.find<CreatePostController>().providerBidDetailsForNotification(message.data['post_id'],message.data['provider_id']);
          }else{
            NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
          }

          if(Get.currentRoute==RouteHelper.myPost){
            Get.find<CreatePostController>().getMyPostList(1);
          }
        }

        else if(message.data['type']=='offer_withdrawn'){
          if(Get.currentRoute.contains(RouteHelper.bidCheckout)){
            Future.delayed(const Duration(microseconds: 300), () {
              Get.dialog(
                const ProviderWithdrawBidDialog(),
                barrierDismissible: false,
              );
            });

          }else{
            NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
          }
        }

        else if(message.data['type'] == 'new_message'){
          if((message.data['channel_id']!="" && message.data['channel_id']!=null)){

            if(Get.currentRoute.contains(RouteHelper.chatScreen) && message.data['channel_id'] == Get.find<ConversationController>().channelId){
              Get.find<ConversationController>().cleanOldData();
              Get.find<ConversationController>().setChannelId(message.data['channel_id']);
              Get.find<ConversationController>().getConversation(message.data['channel_id'], 1,isInitial:true);
            }else if(Get.currentRoute.contains(RouteHelper.chatInbox) || Get.currentRoute.contains(RouteHelper.chatScreen)){
              if (kDebugMode) {
                print("${message.data['user_type']}");
              }
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
              if(message.data['user_type'] == 'provider-admin'){
                Get.find<ConversationController>().getChannelList(1);
              }else{
                Get.find<ConversationController>().getChannelList(1, type: "serviceman");
              }
            }else{
              NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
            }

          } else{
            NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
          }
        }
        else if(message.data['type'] == 'account_deactivated'){
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin,false);

          Get.find<AuthController>().logOut();
          Get.find<AuthController>().clearSharedData();
          Get.find<AuthController>().googleLogout();
          Get.find<AuthController>().signOutWithFacebook();
          Get.find<LocationController>().updateSelectedAddress(null);
          Get.offNamed(RouteHelper.getSignInRoute());
          customSnackBar(message.data['title'], duration: 4);
        }
        else if(message.data['type'] == 'maintenance'){
          Get.find<SplashController>().getConfigData();
        }
        else if(message.data['type'] == 'demo_reset') {
          if(Get.find<SplashController>().configModel.content?.appEnvironment == "demo"){
            Get.dialog(const DemoResetDialogWidget(), barrierDismissible: false);
          }
        }
        else if(message.data['type'] == 'provider_unavailable') {
          showModalBottomSheet(
            isDismissible: false,
            backgroundColor: Colors.transparent,
            context: Get.context!,
              builder: (context) =>  BookingIgnoredSheet(bookingId: message.data['booking_id'] ?? ''),
          );
        }
        else if(message.data['type'] == 'subscription_expiring_soon') {
          showModalBottomSheet(
            isDismissible: true,
            backgroundColor: Colors.transparent,
            context: Get.context!,
            builder: (context) => const SubscriptionExpireReminderWidget(),
          );

        }
        else{
          NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      printLog("onMessageOpenApp: ${message?.notification!.title}/${message?.notification!.body}/${message?.notification!.titleLocKey} || ${message?.data}");

     try{
       if(message !=null && message.data.isNotEmpty) {
         NotificationBody notificationBody = convertNotification(message.data);
         if(notificationBody.notificationType == "new_message"){

           if(Get.currentRoute.contains(RouteHelper.chatScreen)){
             Get.back();
             Get.back();
           } else if(Get.currentRoute.contains(RouteHelper.chatInbox)){
             Get.back();
           }
           Get.toNamed(RouteHelper.getChatScreenRoute(
               notificationBody.channelId??"",
               notificationBody.userType == 'super-admin' ? "admin" : notificationBody.userName??"",
               notificationBody.userProfileImage??"",
               notificationBody.userPhone??"",
               notificationBody.userType??"",
               fromNotification: "fromNotification"
           ));
         }
         else if(notificationBody.notificationType == 'custom_request_posted' || notificationBody.notificationType == 'new_offer_received' || notificationBody.notificationType == 'offer_withdrawn'){
          if(!Get.currentRoute.contains(RouteHelper.myWallet)){
            Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
          }
         }
         else if( _isBooking(notificationBody.notificationType ?? '') && notificationBody.bookingId != null && notificationBody.bookingId !=''){
           if(notificationBody.bookingType == "repeat" && notificationBody.repeatBookingType == "single"){
             Get.toNamed(RouteHelper.getBookingDetailsRoute(subBookingId: notificationBody.bookingId!, fromPage: 'fromNotification'));
           }else if(notificationBody.bookingType == "repeat" && notificationBody.repeatBookingType != "single"){
             Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId: notificationBody.bookingId, fromPage: 'fromNotification'));
           }else{
             Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId: notificationBody.bookingId!, fromPage: 'fromNotification'));
           }
         }
         else if(notificationBody.notificationType == 'privacy_policy' && notificationBody.title != null && notificationBody.title !=''){
           Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
         }
         else if(notificationBody.notificationType == 'terms_and_conditions' && notificationBody.title != null && notificationBody.title !=''){
           Get.toNamed(RouteHelper.getTermsAndConditionsRoute());
         }
         else if(notificationBody.notificationType == "wallet"){
          Get.toNamed(RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
         }
         else if(notificationBody.notificationType == 'loyalty_points_earned'){
           if(!Get.currentRoute.contains(RouteHelper.loyaltyPoint)){
             Get.toNamed(RouteHelper.getLoyaltyPointScreen(fromNotification: "fromNotification"));
           }
         }
         else if(notificationBody.notificationType == 'account_deactivated'){
           Get.find<AuthController>().clearSharedData();
           Get.offNamed(RouteHelper.getSignInRoute());
         }
         else if(notificationBody.notificationType == 'subscription_expiring_soon'){
           Get.toNamed(RouteHelper.getSubscriptionRoute());
         }
         else{
           Get.toNamed(RouteHelper.getNotificationRoute());
         }
       }
     }catch (e) {
       if (kDebugMode) {
         print("");
       }
     }
    });
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    if(!GetPlatform.isIOS) {
      String? title;
      String body;
      String? orderID;
      String? image;
      String playLoad = jsonEncode(message.data);

      title = message.data['title'];
      body = message.data['body'] ?? "";
      orderID = message.data['booking_id'].toString();
      image = (message.data['image'] != null && message.data['image'].isNotEmpty)
          ? message.data['image'].startsWith('http') ? message.data['image']
          : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

      if(image != null && image.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(title!, body, playLoad, image, fln);
        }catch(e) {
          await showBigTextNotification(title!, '',playLoad, orderID,fln);
        }

      }else {
        await showBigTextNotification(title!, body, playLoad, orderID, fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String? body, String orderID, FlutterLocalNotificationsPlugin fln) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'tatarigigs', 'tatarigigs', playSound: true,
      importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
    );
    int randomNumber = Random().nextInt(100);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(id: randomNumber, title: title, body: body, notificationDetails: platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String? body, String payload, String image, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body ?? "", htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    if(!Get.find<AuthController>().isNotificationActive()){
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "tatarigigs_silent","tatarigigs without sound", channelDescription:"description",
        playSound: false,
        importance: Importance.max,
        styleInformation: bigTextStyleInformation, priority: Priority.max,

      );

      int randomNumber = Random().nextInt(100);

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(id: randomNumber, title: title, body: body, notificationDetails: platformChannelSpecifics, payload: payload);
    }
    else {
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "tatarigigs", 'tatarigigs with sound', channelDescription:"description",
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        styleInformation: bigTextStyleInformation, priority: Priority.max,
      );
      int randomNumber = Random().nextInt(100);
      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(id: randomNumber, title: title, body: body, notificationDetails: platformChannelSpecifics, payload: payload);
    }
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String payload, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    if(!Get.find<AuthController>().isNotificationActive()){
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "tatarigigs_silent","tatarigigs without sound", channelDescription:"description",
        playSound: false,
        largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max,
        styleInformation: bigPictureStyleInformation, importance: Importance.max,
      );
      int randomNumber = Random().nextInt(100);
      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(id: randomNumber, title: title, body: body, notificationDetails: platformChannelSpecifics, payload: payload);

    }else{
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "tatarigigs", 'tatarigigs with sound', channelDescription:"description",
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
        largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max,
        styleInformation: bigPictureStyleInformation, importance: Importance.max,
      );
      int randomNumber = Random().nextInt(100);
      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await fln.show(id: randomNumber, title: title, body: body, notificationDetails: platformChannelSpecifics, payload: payload);
    }
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data){
   return NotificationBody.fromJson(data);
  }
}

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
  }
}

bool _isBooking(String notificationType){
  return notificationType == 'refund_issued' || notificationType == 'service_location_updated' ||
      notificationType == 'offline_payment_approved' || notificationType == 'booking_verification_code' ||
      notificationType == 'service_quantity_decreased' || notificationType == 'service_quantity_increased' ||
      notificationType == 'service_removed' || notificationType == 'service_added' ||
      notificationType == 'serviceman_assigned' || notificationType == 'schedule_changed' ||
      notificationType == 'booking_cancelled' || notificationType == 'booking_completed' ||
      notificationType == 'booking_ongoing' ||
      notificationType == 'booking_accepted' || notificationType == 'booking_placed';
}