import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class LanguageScreen extends StatefulWidget {
  final String? fromPage;

  const LanguageScreen({super.key, this.fromPage}) ;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false, isChooseLanguage: true, fromPage: widget.fromPage);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      isExit: true,
      child: Scaffold(
        drawer: null,

        endDrawer: null,
        appBar:widget.fromPage != "fromOthers" ? CustomAppBar(title: "language".tr) : null,
        body: GetBuilder<LocalizationController>(
          builder: (localizationController){
            return FooterBaseView(
              isScrollView: (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context)) ? false: true,
              isCenter: true,
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Stack(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(
                          top: Dimensions.padding16,
                          right: Dimensions.padding16,
                          left: Dimensions.padding16,
                          bottom:(ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context)) ?Dimensions.padding16: 80.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(widget.fromPage != "fromSettingsPage")
                            Image.asset(
                              Images.logo,
                              width: 180,
                            ),
                          const SizedBox(height: 40),
                          Align(
                            alignment:Get.find<LocalizationController>().isLtr ?  Alignment.centerLeft : Alignment.centerRight,
                            child: Text('select_language'.tr,style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium))),
                          const SizedBox(height: Dimensions.padding16),

                          GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ResponsiveHelper.isTab(context) ? 4 : 2,
                              childAspectRatio: (1/1),
                            ),
                            itemCount: localizationController.languages.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => LanguageWidget(
                              languageModel: localizationController.languages[index],
                              localizationController: localizationController, index: index,
                            ),
                          ),
                          const SizedBox(height: Dimensions.padding10),
                          Align(
                              alignment:Get.find<LocalizationController>().isLtr ?  Alignment.centerLeft : Alignment.centerRight,
                              child: Text('you_can_change_language'.tr,style: context.body.defaultSize,)),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: Dimensions.padding16,
                      left: Dimensions.padding16,
                      right: Dimensions.padding16,
                      child: SafeArea(
                        child: CustomButton(
                          onPressed: (){
                            Get.find<SplashController>().disableShowInitialLanguageScreen();
                            localizationController.setLanguage(Locale(
                              localizationController.languages[localizationController.selectedIndex].languageCode!,
                              localizationController.languages[localizationController.selectedIndex].countryCode,),
                              isInitial: true,
                            );
                            if(Get.find<SplashController>().isShowOnboardingScreen()){
                              Get.offNamed(RouteHelper.onBoardScreen);
                            }else{
                              Get.find<SplashController>().getConfigData();

                              HomeScreen.loadData(true);
                              Get.offAllNamed(RouteHelper.getMainRoute("home"));
                            }
                          },
                          buttonText: 'save'.tr,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}