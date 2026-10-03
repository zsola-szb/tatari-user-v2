import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BottomNavItem extends StatelessWidget {
  final String? icon;
  final IconData? iconData;
  final BnbItem bnbItem;
  final GestureTapCallback onTap;
  const BottomNavItem({super.key, this.icon, this.iconData, required this.bnbItem, required this.onTap}) : assert(icon != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(builder: (bottomNavController) {
      bool isSelected = bottomNavController.currentPage == bnbItem;
      Color activeColor = Theme.of(context).colorScheme.primary;
      Color inactiveColor = Theme.of(context).disabledColor;

      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3, width: isSelected ? Get.width * 0.15 : 0,
              margin: const EdgeInsets.only(bottom: Dimensions.padding12),
              decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(Dimensions.radius4)),
            ),

            bnbItem == BnbItem.profile && Get.find<AuthController>().isLoggedIn()
                ? GetBuilder<UserController>(builder: (userController) {
                    return Container(
                      width: 20, height: 20,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: CustomImage(image: userController.userInfoModel?.imageFullPath),
                      ),
                    );
                  })
                : iconData != null
                    ? Icon(iconData, size: 18, color: isSelected ? activeColor : inactiveColor)
                    : Image.asset(icon!, width: 18, height: 18,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
            const SizedBox(height: Dimensions.padding6),

            Text(bnbItem.name.tr,
              style: context.subHeading.small.overrideWith(
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: Dimensions.padding6),

          ]),
        ),
      );
    });
  }
}
