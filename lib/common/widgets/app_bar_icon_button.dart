import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBarIconButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;
  final Widget badge;

  const AppBarIconButton({super.key, required this.asset, required this.onTap, this.badge = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36, height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius8),
            ),
            child: SvgPicture.asset(
              asset, width: 20, height: 20,
              colorFilter: ColorFilter.mode(context.customThemeColors.textColor, BlendMode.srcIn),
            ),
          ),

          Positioned(top: 0, right: 0, child: badge),
        ],
      ),
    );
  }
}

class AppBarCartBadge extends StatelessWidget {
  const AppBarCartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      final int count = cartController.items.length;

      if(count == 0){
        return const SizedBox.shrink();
      }

      return Container(
        height: 16,
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 16),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          style: context.body.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.strong),
        ),
      );
    });
  }
}
