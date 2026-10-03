import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ChooseLanguageBottomSheet extends StatelessWidget {
  const ChooseLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        initState: (_) {
          Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
        },
        builder: (localizationController){
          return Container(
            width: Dimensions.webMaxWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
              color: Get.isDarkMode?Theme.of(context).cardColor:Theme.of(context).colorScheme.surface,
            ),
            child: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Positioned(
                    right: 10, top: 10,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.padding6),
                        decoration: BoxDecoration(color: context.customThemeColors.secondaryBackGroundColor, shape: BoxShape.circle),
                        child: Icon(Icons.close, size: Dimensions.fontSizeDefault, color: context.customThemeColors.textColor),
                      ),
                    ),
                  ),

                  Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(height: Dimensions.padding32),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding32),
                        child: Column(children: [
                          Text('select_language'.tr, textAlign: TextAlign.center, style: context.heading.large),
                          const SizedBox(height: Dimensions.padding6),
                          Text('choose_your_preferred_language_to_use_the_app'.tr, textAlign: TextAlign.center, style: context.body.small),
                        ]),
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: Get.height * 0.5,
                          minHeight: Get.height * 0.1,
                        ),
                        child: ListView.builder(
                            itemCount: localizationController.languages.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) => LanguageRadioTile(
                              languageModel: localizationController.languages[index],
                              isSelected: localizationController.selectedIndex == index,
                              onTap: () => localizationController.setSelectIndex(index),
                            ),
                        ),
                      ),
                    ),

                    CustomButton(
                      buttonText: 'select'.tr,
                      margin: const EdgeInsets.all(Dimensions.padding16),
                      onPressed: () {
                        Get.find<SplashController>().disableShowInitialLanguageScreen();
                        if(localizationController.languages.isNotEmpty && localizationController.selectedIndex != -1) {
                          localizationController.setLanguage(
                              Locale(
                                localizationController.languages[localizationController.selectedIndex].languageCode!,
                                localizationController.languages[localizationController.selectedIndex].countryCode,
                          ));
                          Get.back();
                          Get.find<SplashController>().getConfigData();

                          HomeScreen.loadData(true);
                          Get.offAllNamed(RouteHelper.getMainRoute('home'));
                        }else {
                          customSnackBar('select_a_language'.tr, type: ToasterMessageType.info);
                        }
                      },
                    ),

                    SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.padding10 : 0),
                  ]),
                ],
              ),
            ),
          );
        },
    );
  }
}
