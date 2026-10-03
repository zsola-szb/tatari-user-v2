import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/common/widgets/address_selection_bottom_sheet.dart';
import 'package:tatarigigs_user/common/widgets/home_search_field.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? backButton;

  final ScrollController? scrollController;

  const HomeAppBar({super.key, this.backButton = true, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = context.customThemeColors.backGroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
          ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CollapseOnScroll(
                  scrollController: scrollController,
                  child: const HomeAppBarGreetingRow(),
                ),
                const HomeSearchField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 154 : 140);
}

class HomeAppBarGreetingRow extends StatelessWidget {
  const HomeAppBarGreetingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                useRootNavigator: true,
                routeSettings: const RouteSettings(name: '/'),
                builder: (context) => const AddressSelectionBottomSheet(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('hi_there'.tr, style: context.heading.large),
                    const SizedBox(width: Dimensions.padding6),
                    SvgPicture.asset(Images.welcomeWavingHand, width: 20, height: 20),
                  ]),
                  const SizedBox(height: Dimensions.padding2),
                  GetBuilder<LocationController>(builder: (locationController) {
                    final String address = locationController.getUserAddress()?.address ?? '';
                    final String shortAddress = address.length > 35 ? '${address.substring(0, 35)}...' : address;
                    return Row(children: [
                      SvgPicture.asset(
                        Images.locationMarkerOutlined, width: 14, height: 14,
                        colorFilter: ColorFilter.mode(context.customThemeColors.secondaryTextColor, BlendMode.srcIn),
                      ),
                      const SizedBox(width: Dimensions.padding4),
                      Flexible(
                        child: Text(
                          shortAddress,
                          style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding4),
                      SvgPicture.asset(
                        Images.chevronDownArrowIcon, width: 14, height: 14,
                        colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
                      ),
                    ]);
                  }),
                ],
              ),
            ),
          ),
          AppBarIconButton(asset: Images.notificationIcon, onTap: () => Get.toNamed(RouteHelper.getNotificationRoute())),
          const SizedBox(width: Dimensions.padding8),
          AppBarIconButton(
            asset: Images.serviceCart,
            onTap: () => Get.toNamed(RouteHelper.getCartEntryRoute()),
            badge: const AppBarCartBadge(),
          ),
        ],
      ),
    );
  }
}

