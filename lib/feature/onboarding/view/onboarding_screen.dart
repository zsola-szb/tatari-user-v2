import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/onboarding/controller/on_board_pager_controller.dart';


class OnBoardingScreen extends GetView<OnBoardController> {
  const OnBoardingScreen({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        body: SafeArea(
          child: GetBuilder<OnBoardController>(builder: (onBoardingController) {
            final int lastIndex = onBoardingController.onBoardPagerData.length - 1;
            final bool isLast = onBoardingController.pageIndex == lastIndex;

            return Column(
              children: [
                const SizedBox(height: Dimensions.padding20),

                Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding10, Dimensions.padding16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isLast ? const SizedBox(height: 40) : InkWell(
                        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                        onTap: () => checkPermissionAndNavigateFromOnBoarding(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius8),
                            color: Theme.of(context).cardColor
                          ),
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6, horizontal: Dimensions.padding12),
                          child: Text(
                            "skip".tr,
                            style: context.subHeading.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: Stack(
                  children: [
                      Positioned(
                        top: Get.height * 0.2,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20),
                              topRight: Radius.circular(Dimensions.radius20),
                            ),
                          ),
                        ),
                      ),

                      PageView.builder(
                        controller: onBoardingController.pageController,
                        onPageChanged: (value) => onBoardingController.onPageChanged(value),
                        itemCount: onBoardingController.onBoardPagerData.length,
                        itemBuilder: (context, index) {
                          final data = onBoardingController.onBoardPagerData[index];

                          return Column(
                            children: [
                              SizedBox(
                                height: Get.height * 0.2,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding32, Dimensions.padding16, 0),
                                  child: Column(
                                    children: [
                                      Text(data["text"]!,
                                        textAlign: TextAlign.center,
                                        style: context.heading.extraOverLarge,
                                      ),

                                      const SizedBox(height: Dimensions.padding10),

                                      Text(data["subTitle"]!,
                                        textAlign: TextAlign.center,
                                        style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.padding20),

                              SizedBox(
                                height: Get.height * 0.42,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                                  child: Image.asset(data["image"]!, fit: BoxFit.contain),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      Positioned(
                        bottom: Get.height * 0.24,
                        left: 0,
                        right: 0,
                        child: isLast ? const SizedBox() : SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(lastIndex + 1, (i) => PagerDot(index: i, currentIndex: onBoardingController.pageIndex, dotSize: 6,)),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: Get.height * 0.1,
                        left: Dimensions.padding16,
                        right: Dimensions.padding16,
                        child: _buildActionRow(context, onBoardingController, isLast, lastIndex),
                      ),
                    ],
                )),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, OnBoardController onBoardingController, bool isLast, int lastIndex) {
    if(isLast) {
      return Center(
        child: CustomButton(
          buttonText: "get_started".tr,
          width: Get.width * 0.5,
          onPressed: () => checkPermissionAndNavigateFromOnBoarding(),
        ),
      );
    }

    final forwardButton = _NavCircleButton(
      icon: Icons.arrow_forward_ios_sharp,
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconColor: Colors.white,
      onTap: () => onBoardingController.pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
    );

    if(onBoardingController.pageIndex == 0) {
      return Center(child: forwardButton);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          backgroundColor: const Color(0xfff2f5f9),
          iconColor: Theme.of(context).colorScheme.primary,
          onTap: () => onBoardingController.pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
        ),
        const SizedBox(width: Dimensions.padding20),
        forwardButton,
      ],
    );
  }
}

class _NavCircleButton extends StatelessWidget {
  const _NavCircleButton({required this.icon, required this.backgroundColor, required this.iconColor, required this.onTap});
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        padding: const EdgeInsets.all(Dimensions.padding10 + 3),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

void checkPermissionAndNavigateFromOnBoarding() async {

  Get.find<SplashController>().disableShowOnboardingScreen();

  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied ) {
    permission = await Geolocator.requestPermission();
  }
  if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    Get.offAllNamed(RouteHelper.getPickMapRoute("",false,"",null,null));
  }else {
    Get.dialog(const CustomLoader(), barrierDismissible: false);
    AddressModel address = await Get.find<LocationController>().getCurrentLocation(true);
    ZoneResponseModel response = await Get.find<LocationController>().getZone(address.latitude!, address.longitude!, false);

    if(response.isSuccess) {
      Get.find<LocationController>().saveAddressAndNavigate(address, false, '', false, true);
    }else {
      Get.back();
      Get.offAllNamed(RouteHelper.getPickMapRoute("",false,"",null,null));
    }
  }
}
