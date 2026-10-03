import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutEditIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final bool showBackground;

  const CheckoutEditIconButton({
    super.key,
    this.onTap,
    this.size = 36,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.55;

    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: showBackground
            ? BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(Dimensions.radius8)) : null,
        child: SvgPicture.asset(
          Images.editIcon,
          height: iconSize,
          width: iconSize,
        ),
      ),
    );
  }
}
