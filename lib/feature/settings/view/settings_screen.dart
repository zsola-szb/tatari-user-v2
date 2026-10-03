import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          isBackButtonExist: true,
          bgColor: Theme.of(context).cardColor,
          title: 'settings'.tr,
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.padding16).copyWith(bottom: 0),
            margin: const EdgeInsets.all(Dimensions.padding16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius16)
            ),
            child: Column(children: [

              GetBuilder<ThemeController>(builder: (themeController) {
                return SettingsListItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'choose_mode'.tr,
                  onTap: themeController.toggleTheme,
                  trailing: FlutterSwitch(
                    value: themeController.darkTheme,
                    onToggle: (value){
                      themeController.toggleTheme();
                    },
                    width: 60, height: 30,
                    activeIcon: Image.asset(Images.darkThemeIcon, color: Theme.of(context).primaryColor),
                    activeToggleColor: Theme.of(context).cardColor,
                    inactiveToggleColor: Theme.of(context).cardColor,
                    inactiveIcon: Image.asset(Images.lightThemeIcon, color: Theme.of(context).primaryColor, height: 60, width: 60, scale: 0.5),
                    inactiveColor: Colors.grey.withValues(alpha:0.25),
                    activeColor: Theme.of(context).primaryColor.withValues(alpha:0.25),
                  ),
                );
              }),
              Divider(height: 1, indent: Dimensions.padding16, endIndent: Dimensions.padding16, color: Theme.of(context).hintColor.withValues(alpha: .3)),

              GetBuilder<LocalizationController>(builder: (localizationController) {
                final currentLanguage = localizationController.languages.isNotEmpty
                    ? localizationController.languages[localizationController.selectedIndex]
                    : null;

                return SettingsListItem(
                  icon: Icons.language_outlined,
                  title: 'choose_language'.tr,
                  onTap: () => Get.bottomSheet(const ChooseLanguageBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true),
                  trailing: currentLanguage?.imageUrl != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius4),
                    child: Image.asset(currentLanguage!.imageUrl!, width: 24, height: 16, fit: BoxFit.cover),
                  ) : Icon(Icons.arrow_forward_ios_rounded, size: Dimensions.fontSizeSmall),
                );
              }),
              Divider(height: 1, indent: Dimensions.padding16, endIndent: Dimensions.padding16, color: Theme.of(context).hintColor.withValues(alpha: .3)),

              // GetBuilder<AuthController>(builder: (authController) {
              //   return SettingsListItem(
              //     icon: Icons.notifications_outlined,
              //     title: 'notification'.tr,
              //     onTap: authController.toggleNotificationSound,
              //     trailing: CupertinoSwitch(
              //       activeTrackColor: Theme.of(context).colorScheme.primary,
              //       value: authController.isNotificationActive(),
              //       onChanged: (value) => authController.toggleNotificationSound(),
              //     ),
              //   );
              // }),
              // Divider(height: 1, indent: Dimensions.padding16, endIndent: Dimensions.padding16, color: Theme.of(context).hintColor.withValues(alpha: .3)),

              if(isLoggedIn)
                GetBuilder<UserController>(builder: (userController) {
                  return SettingsListItem(
                    icon: Icons.person_remove_outlined,
                    title: 'delete_account'.tr,
                    onTap: () => Get.bottomSheet(
                      ConfirmationBottomsheet(
                        icon: Images.deleteProfile,
                        title: 'are_you_sure_to_delete_your_account'.tr,
                        description: 'it_will_remove_your_all_information'.tr,
                        yesButtonText: 'yes-delete',
                        noButtonText: 'no',
                        onYesPressed: () => userController.removeUser(),
                      ),
                      backgroundColor: Colors.transparent, isScrollControlled: true,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(Dimensions.padding8),
                      decoration: BoxDecoration(
                        color: context.customThemeColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radius8),
                      ),
                      child: Icon(Icons.delete_outline_outlined, size: Dimensions.fontSizeLarge, color: context.customThemeColors.error),
                    ),
                  );
                }),

            ]),
          ),
        ),
      ),
    );
  }
}
