import 'package:get/get.dart';

enum BnbItem {homePage, offers, bookings, profile}
class BottomNavController extends GetxController implements GetxService{
  static BottomNavController get to => Get.find();

  var currentPage = BnbItem.homePage;
  void changePage(BnbItem bnbItem, {bool shouldUpdate = true}) {
    currentPage = bnbItem;

    if(shouldUpdate){
      update();
    }
  }
}
