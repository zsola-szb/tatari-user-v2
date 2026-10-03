import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key}) ;

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<UserController>().getUserInfo(reload: false);
  }

  String _referralLink() => '${AppConstants.websiteUrl}${RouteHelper.signUp}?referral_code=${Get.find<UserController>().userInfoModel?.referCode ??""}';

  String _referralMessage() {
    final String referCode = Get.find<UserController>().userInfoModel?.referCode ??"";
    final String? appUrlAndroid = Get.find<SplashController>().configModel.content?.appUrlAndroid;
    return appUrlAndroid != null
        ? '${AppConstants.appName} ${'referral_code'.tr}: $referCode \n${'download_app_from_this_link'.tr}: $appUrlAndroid'
        : '${AppConstants.appName} ${'referral_code'.tr}: $referCode';
  }

  @override
  Widget build(BuildContext context) {
    final List<String> hintList = ['invite_your_friends'.tr, '${'they_register'.tr} ${AppConstants.appName} ${'with_special_offer'.tr}', 'you_made_your_earning'.tr];

    return CustomPopWidget(
      child: GetBuilder<SplashController>(
        builder: (splashController) {
          if(splashController.currentDataSource == DataSourceEnum.client && splashController.configModel.content?.referEarnStatus == 0){
            Future.delayed(const Duration(microseconds: 100)).then((value) {
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            });
          }
          return Scaffold(
            backgroundColor: context.customThemeColors.backGroundColor,
            appBar: CustomAppBar(title: 'refer_and_earn'.tr),
            body: GetBuilder<UserController>(builder: (userController){
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Column(children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
                      child: Image.asset(Images.referAndEarn, height: Get.height * 0.18),
                    ),

                    Text('invite_friend_and_businesses'.tr, textAlign: TextAlign.center, style: context.heading.extraOverLarge),
                    const SizedBox(height: Dimensions.padding6),

                    Text('copy_your_code'.tr, textAlign: TextAlign.center, style: context.body.defaultSize),
                    const SizedBox(height: Dimensions.padding20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.padding16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Column(children: [

                        Text('your_personal_code'.tr, style: context.heading.large),
                        const SizedBox(height: Dimensions.padding16),

                        DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: const [5, 5],
                            strokeWidth: 1,
                            color: Colors.grey.withValues(alpha: 0.3),
                            radius: const Radius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.padding4),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding8),
                                child: Text(userController.userInfoModel?.referCode ?? "", style: context.heading.large),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: userController.userInfoModel?.referCode ?? ""));
                                  customSnackBar('referral_code_copied'.tr, type : ToasterMessageType.success);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding8),
                                  decoration: BoxDecoration(
                                    color:Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Icon(Icons.copy_rounded, color: Theme.of(context).cardColor, size: 16),
                                    const SizedBox(width: Dimensions.padding6),

                                    Text('copy'.tr, style: context.body.small.overrideWith(color: Theme.of(context).cardColor)),
                                  ]),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: Dimensions.padding24),

                        Text('or_share'.tr, style: context.body.small),
                        const SizedBox(height: Dimensions.padding24),

                        Row(mainAxisAlignment: MainAxisAlignment.center, spacing: Dimensions.padding16, children: [
                          ReferShareIcon(
                            assetIcon: Images.messengerIcon,
                            onTap: () => SocialShareHelper.openAppOrStore(SocialShareApp(
                              scheme: 'fb-messenger://share?link=${Uri.encodeComponent(_referralLink())}',
                              androidPackage: 'com.facebook.orca',
                              iosAppId: '454638411',
                            )),
                          ),

                          ReferShareIcon(
                            assetIcon: Images.whatsappIcon,
                            onTap: () => SocialShareHelper.openAppOrStore(SocialShareApp(
                              scheme: 'whatsapp://send?text=${Uri.encodeComponent('${_referralMessage()}\n${_referralLink()}')}',
                              androidPackage: 'com.whatsapp',
                              iosAppId: '310633997',
                            )),
                          ),

                          ReferShareIcon(
                            assetIcon: Images.emailIcon,
                            height: 35, weight: 35,
                            onTap: () => SocialShareHelper.openAppOrStore(SocialShareApp(
                              scheme: 'googlegmail://co?subject=${Uri.encodeComponent('${AppConstants.appName} ${'referral_code'.tr}')}'
                                  '&body=${Uri.encodeComponent('${_referralMessage()}\n${_referralLink()}')}',
                              androidPackage: 'com.google.android.gm',
                              iosAppId: '422689480',
                            )),
                          ),

                          ReferShareIcon(
                            assetIcon: Images.viverIcon,
                            onTap: () => SocialShareHelper.openAppOrStore(SocialShareApp(
                              scheme: 'viber://forward?text=${Uri.encodeComponent('${_referralMessage()}\n${_referralLink()}')}',
                              androidPackage: 'com.viber.voip',
                              iosAppId: '382617920',
                            )),
                          ),

                          ReferShareIcon(
                            assetIcon: Images.share,
                            onTap: () => SharePlus.instance.share(ShareParams(
                              uri: Uri.tryParse(_referralLink()),
                              subject: _referralMessage(),
                            )),
                          ),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.padding32),

                    Align(alignment: Alignment.centerLeft, child: Text('how_you_it_works'.tr, style: context.heading.large)),
                    const SizedBox(height: Dimensions.padding12),

                    ReferHintView(hintList: hintList),
                  ]),
                ),
              );
            }),
          );
        }
      ),
    );
  }
}
