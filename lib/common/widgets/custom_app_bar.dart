import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final bool? isBackButtonExist;
  final Function()? onBackPressed;
  final bool? showCart;
  final bool? centerTitle;
  final Color? bgColor;
  final Widget? actionWidget;
  final GlobalKey<CustomShakingWidgetState>?  shakeKey;
  final bool isBackgroundTransparent;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.showCart = false,
    this.centerTitle = false,
    this.bgColor,
    this.actionWidget,
    this.subTitle,
    this.shakeKey,
    this.isBackgroundTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isBackgroundTransparent ? Colors.transparent : bgColor ?? Theme.of(context).cardColor,
      centerTitle: centerTitle,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: isBackButtonExist! ? 0 : 16,
      leadingWidth: isBackButtonExist! ? 65 : null,
      leading: isBackButtonExist! ? Center(
        child: _AppBarBackButton(
          onTap: () => onBackPressed != null ? onBackPressed!() : Navigator.of(context).canPop() ? Navigator.pop(context) : Get.offAllNamed(RouteHelper.getInitialRoute()),
        ),
      ) : null,

      title: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title!, style: context.heading.large, maxLines: 1, overflow: TextOverflow.ellipsis),
          if(subTitle!=null) Text(subTitle!, style: context.body.small),
        ],
      ),

      actions: showCart! ? [
        Padding(
          padding: const EdgeInsets.only(right: Dimensions.padding16),
          child: Center(
            child: AppBarIconButton(
              asset: Images.serviceCart,
              onTap: () => Get.toNamed(RouteHelper.getCartEntryRoute()),
              badge: const AppBarCartBadge(),
            ),
          ),
        )] : actionWidget != null ? [actionWidget!] : null,
    );
  }
  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, Dimensions.preferredSize );
}

class _AppBarBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AppBarBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.customThemeColors.secondaryBackGroundColor,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Icon(Icons.arrow_back, size: 20, color: context.customThemeColors.textColor),
      ),
    );
  }
}