import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SeeAllCircularButton extends StatelessWidget {
  final Function()? onTap;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  const SeeAllCircularButton({super.key, this.onTap, this.size = 40, this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).cardColor,
        boxShadow: Get.isDarkMode ? null : cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(width: size, height: size,
            child: Center(
              child: SvgPicture.asset(Images.chevronArrowIcon,
                width: size * .35, height: size * .35,
                matchTextDirection: true,
                colorFilter: ColorFilter.mode(iconColor ?? Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SeeAllCircularListItem extends StatelessWidget {
  final Function()? onTap;
  final double size;
  final EdgeInsetsGeometry padding;
  const SeeAllCircularListItem({
    super.key,
    this.onTap,
    this.size = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: Dimensions.padding12),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: SeeAllCircularButton(onTap: onTap, size: size),
      ),
    );
  }
}
