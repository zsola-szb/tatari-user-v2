import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationTypePill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const LocationTypePill({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Widget pill = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding10,
        vertical: Dimensions.padding6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label,
            style: context.subHeading.small.medium.copyWith(color: Colors.white),
          ),
          if (onTap != null) ...<Widget>[
            const SizedBox(width: Dimensions.padding4),
            SvgPicture.asset(Images.chevronDownArrowIcon,
              width: 14, height: 14,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return pill;
    }
    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: pill,
    );
  }
}
