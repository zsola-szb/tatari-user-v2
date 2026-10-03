import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/feature/profile/model/profile_cart_item_model.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key}) ;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    if(Get.find<AuthController>().isLoggedIn()){
      Get.find<UserController>().getUserInfo(reload: false);
    }
  }
  @override
  Widget build(BuildContext context) {

    bool pickedAddress = Get.find<LocationController>().getUserAddress() != null;
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    ConfigModel configModel = Get.find<SplashController>().configModel;

    final generalItems = [
      if(isLoggedIn)
        ProfileCardItemModel('edit_profile'.tr, Icons.account_circle_outlined, RouteHelper.getEditProfileRoute()),

      ProfileCardItemModel( 'my_address'.tr, Icons.location_on_outlined,RouteHelper.getAddressRoute('fromProfileScreen'),
      ),
      ProfileCardItemModel(
        'notifications'.tr, Icons.notifications_outlined,
        pickedAddress  ? RouteHelper.getNotificationRoute() : RouteHelper.getPickMapRoute( RouteHelper.notification , true, 'false', null, null),
      ),

      ProfileCardItemModel(
        configModel.content?.guestCheckout == 0 || isLoggedIn ? 'my_booking'.tr : "track_booking".tr, Icons.bookmarks_outlined,
        !isLoggedIn && configModel.content?.guestCheckout == 1
            ? RouteHelper.getTrackBookingRoute()
            : RouteHelper.getBookingListRoute(),
      ),

      ProfileCardItemModel('my_favorite'.tr, Icons.favorite_border_rounded, RouteHelper.getMyFavoriteScreen()),

      if(isLoggedIn )
        ProfileCardItemModel(
          'suggest_new_service'.tr, Icons.handyman_outlined,
          pickedAddress  ?  RouteHelper.getNewSuggestedServiceScreen() :  RouteHelper.getPickMapRoute( RouteHelper.suggestService , true, 'false', null, null) ,
        ),

      if(configModel.content?.biddingStatus == 1)
        ProfileCardItemModel('service_request'.tr, Icons.build_outlined, RouteHelper.getMyPostScreen()),

      ProfileCardItemModel('settings'.tr, Icons.settings_outlined, RouteHelper.getSettingRoute()),
    ];

    final promotionalItems = [
      if((configModel.content!.isProFeatureActive != 0 || Get.find<UserController>().userInfoModel?.subscribedPlan != null))
        ProfileCardItemModel(
          'subscription_plan'.tr, Icons.workspace_premium_outlined,
          Get.find<UserController>().userInfoModel?.subscribedPlan != null ?
          RouteHelper.getMySubscriptionDetailsRoute() :
          RouteHelper.getSubscriptionRoute(),
        ),

      ProfileCardItemModel('vouchers'.tr, Icons.confirmation_number_outlined, RouteHelper.getVoucherRoute(fromPage: 'menu')),

      if(configModel.content!.loyaltyPointStatus != 0 && isLoggedIn)
        ProfileCardItemModel('loyalty_point'.tr, Icons.loyalty_outlined, RouteHelper.getLoyaltyPointScreen()),

      if(configModel.content!.walletStatus != 0 && isLoggedIn)
        ProfileCardItemModel('my_wallet'.tr, Icons.account_balance_wallet_outlined, RouteHelper.getMyWalletScreen()),
    ];

    final helpItems = [
      ProfileCardItemModel('inbox'.tr, Icons.bookmarks_outlined, RouteHelper.getInboxScreenRoute()),

      if(configModel.content?.referEarnStatus == 1)
        ProfileCardItemModel('refer_and_earn'.tr, Icons.share, RouteHelper.getReferAndEarnScreen()),

      ProfileCardItemModel('service_area'.tr, Icons.add_location_alt_outlined, RouteHelper.getServiceArea()),

      ProfileCardItemModel('help_&_support'.tr, Icons.help_outline_rounded, RouteHelper.getSupportRoute()),

      ...(configModel.content!.businessPages ?? []).map((page) => ProfileCardItemModel(
        _businessPageTitle(page),
        page.pageKey == HtmlType.aboutUs.value
            ? Icons.info_outline_rounded
            : page.pageKey == HtmlType.termsAndCondition.value
            ? Icons.description_outlined : page.pageKey == HtmlType.privacyPolicy.value
            ? Icons.privacy_tip_outlined : page.pageKey == HtmlType.cancellationPolicy.value
            ? Icons.cancel_outlined : page.pageKey == HtmlType.refundPolicy.value ? Icons.currency_exchange_outlined : Icons.article_outlined,
        _businessPageRoute(page),
      )),

      if(configModel.content?.providerSelfRegistration == 1)
        ProfileCardItemModel('become_a_provider'.tr, Icons.storefront_outlined, RouteHelper.getProviderWebView()),
    ];

    final dangerItems = [
      if(isLoggedIn )
        ProfileCardItemModel(
        'logout'.tr, Icons.logout_rounded, 'sign_out',
      ),
    ];

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'profile'.tr,
          centerTitle: false,
          bgColor: Theme.of(context).cardColor,
          isBackButtonExist: true,
          onBackPressed: (){
            if(Navigator.canPop(context)){
              Get.back();
            }else{
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            }
          },
        ),

        body: GetBuilder<UserController>(
          builder: (userController) {
            return userController.userInfoModel == null  && Get.find<AuthController>().isLoggedIn() ?
            const Center(child: CircularProgressIndicator()) :
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Dimensions.padding2),

                  ProfileHeader(userInfoModel: userController.userInfoModel,),
                  const SizedBox(height: Dimensions.padding16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                    child: Column(children: [

                      ProfileSectionCard(
                        title: 'general'.tr,
                        children: generalItems.map((item) => ProfileCardItem(
                          title: item.title, leadingIcon: item.loadingIcon,
                          onTap: () => _onItemTap(item.routeName),
                        )).toList(),
                      ),

                      ProfileSectionCard(
                        title: 'promotional_activity'.tr,
                        children: promotionalItems.map((item) => ProfileCardItem(
                          title: item.title, leadingIcon: item.loadingIcon,
                          onTap: () => _onItemTap(item.routeName),
                        )).toList(),
                      ),

                      ProfileSectionCard(
                        title: 'help_&_support'.tr,
                        children: helpItems.map((item) => ProfileCardItem(
                          title: item.title, leadingIcon: item.loadingIcon,
                          onTap: () => _onItemTap(item.routeName),
                        )).toList(),
                      ),

                      for(final item in dangerItems)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Dimensions.padding16),
                          child: InkWell(
                            onTap: () => _onItemTap(item.routeName),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.login_outlined, size: Dimensions.fontSizeLarge, color: context.customThemeColors.error),
                                const SizedBox(width: Dimensions.padding8),
                                Text(item.title, style: context.subHeading.defaultSize),
                              ]),
                            ),
                          ),
                        ),
                      const SizedBox(height: Dimensions.padding16)

                    ]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onItemTap(String route) async {
     if(route == 'sign_out'){
      if(
      Get.find<AuthController>().isLoggedIn()) {
        Get.bottomSheet(
          GetBuilder<AuthController>(
            builder: (authController) => ConfirmationBottomsheet(
              icon: Images.logoutIcon,
              title: 'are_you_sure_to_logout'.tr,
              description: "if_you_logged_out_your_cart_will_be_removed".tr,
              yesButtonColor: Theme.of(Get.context!).colorScheme.primary,
              isLoading: authController.isLoggingOut,
              onYesPressed: () async {
                await authController.logoutUser();
                Get.find<LocationController>().updateSelectedAddress(null);
                Get.offAllNamed(RouteHelper.getInitialRoute());
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      }else {
        Get.toNamed(RouteHelper.getSignInRoute());
      }
    }else if(route.startsWith('http')){
      if(await canLaunchUrlString(route)){
        launchUrlString(route, mode: LaunchMode.externalApplication);
      }
    }
    else{
      Get.toNamed(route);
    }
  }

  String _businessPageTitle(BusinessPage page) {
    return page.pageKey == HtmlType.aboutUs.value
        ? 'about_us'.tr
        : page.pageKey == HtmlType.termsAndCondition.value
        ? 'terms_and_conditions'.tr : page.pageKey == HtmlType.privacyPolicy.value
        ? 'privacy_policy'.tr : page.pageKey == HtmlType.cancellationPolicy.value
        ? 'cancellation_policy'.tr : page.pageKey == HtmlType.refundPolicy.value ? 'refund_policy'.tr : page.title ?? '';
  }

  String _businessPageRoute(BusinessPage page) {
    return page.pageKey == HtmlType.aboutUs.value
        ? RouteHelper.getAboutUsRoute()
        : page.pageKey == HtmlType.termsAndCondition.value
        ? RouteHelper.getTermsAndConditionsRoute()
        : page.pageKey == HtmlType.privacyPolicy.value
        ? RouteHelper.getPrivacyPolicyRoute()
        : page.pageKey == HtmlType.cancellationPolicy.value
        ? RouteHelper.getCancellationPolicyRoute()
        : page.pageKey == HtmlType.refundPolicy.value
        ? RouteHelper.getRefundPolicyRoute()
        : '';
  }
}

