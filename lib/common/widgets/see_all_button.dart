import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SeeAllButton extends StatelessWidget {
  final Function()? onTap;
  const SeeAllButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = Get.isDarkMode
        ? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .8) : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding4),
        child: Row(mainAxisSize: MainAxisSize.min, children: [

          Text('see_all'.tr, style: context.heading.large.overrideWith(color: color)),
          const SizedBox(width: Dimensions.padding6),

          SvgPicture.asset(Images.chevronArrowIcon,
            width: 12, height: 12,
            matchTextDirection: true,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ]),
      ),
    );
  }
}
