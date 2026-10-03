import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatefulWidget {
  final AddressModel ? previousAddress;
  final bool showServiceNotAvailableDialog;
  final int pageIndex;
  const  BottomNavScreen({super.key, required this.pageIndex, this.previousAddress, required this.showServiceNotAvailableDialog});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _pageIndex = 0;
  bool _canExit = false;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;

    switch (_pageIndex) {
      case 1:
        Get.find<BottomNavController>().changePage(BnbItem.bookings, shouldUpdate: false);
        break;
      case 2:
        Get.find<BottomNavController>().changePage(BnbItem.homePage, shouldUpdate: false);
        WidgetsBinding.instance.addPostFrameCallback((_) => Get.toNamed(RouteHelper.getCartEntryRoute()));
        break;
      case 3:
        Get.find<BottomNavController>().changePage(BnbItem.offers, shouldUpdate: false);
        break;
      case 4:
        Get.find<BottomNavController>().changePage(BnbItem.profile, shouldUpdate: false);
        break;
      default:
        Get.find<BottomNavController>().changePage(BnbItem.homePage, shouldUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isUserLoggedIn = Get.find<AuthController>().isLoggedIn();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) {
        if (Get.find<BottomNavController>().currentPage != BnbItem.homePage) {
          Get.find<BottomNavController>().changePage(BnbItem.homePage);
        } else {
          if (_canExit) {
            SystemNavigator.pop();
          } else {
            customSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        }
      },

      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: .6),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.padding6),
              child: Row(children: [

                BottomNavItem(
                  icon: Images.home, bnbItem: BnbItem.homePage,
                  onTap: () => Get.find<BottomNavController>().changePage(BnbItem.homePage),
                ),

                BottomNavItem(
                  icon: Images.offerMenu, bnbItem: BnbItem.offers,
                  onTap: () => Get.find<BottomNavController>().changePage(BnbItem.offers),
                ),

                BottomNavItem(
                  icon: Images.bookings, bnbItem: BnbItem.bookings,
                  onTap: () {
                    // if (!isUserLoggedIn && Get.find<SplashController>().configModel.content?.guestCheckout == 1) {
                    //   Get.toNamed(RouteHelper.getTrackBookingRoute());
                    // } else  if(!isUserLoggedIn){
                    //
                    //   Get.toNamed(RouteHelper.getBookingListRoute());
                    // } else {
                      Get.find<BottomNavController>().changePage(BnbItem.bookings);
                  //  }
                  },
                ),

                BottomNavItem(
                  iconData: Icons.person_rounded, bnbItem: BnbItem.profile,
                  onTap: () => Get.find<BottomNavController>().changePage(BnbItem.profile),
                ),
              ]),
            ),
          ),
        ),

        body: GetBuilder<BottomNavController>(builder: (navController){
          return _bottomNavigationView(widget.previousAddress, widget.showServiceNotAvailableDialog);
        }),

      ),
    );
  }

  dynamic _bottomNavigationView(AddressModel? previousAddress, bool showServiceNotAvailableDialog) {
    PriceConverter.getCurrency();
    switch (Get.find<BottomNavController>().currentPage) {
      case BnbItem.homePage:
        return HomeScreen(addressModel: previousAddress, showServiceNotAvailableDialog: showServiceNotAvailableDialog,);
      case BnbItem.bookings:
        if (!Get.find<AuthController>().isLoggedIn()) {
          return const BookingTrackScreen();
        } else {
          return const BookingListScreen();
        }
      case BnbItem.offers:
        return const OfferScreen(isFromMenu: false);
      case BnbItem.profile:
        return const ProfileScreen();
    }
  }
}

