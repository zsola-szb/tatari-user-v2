import 'package:flutter_svg/flutter_svg.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CategoryOfferBadge extends StatelessWidget {
  const CategoryOfferBadge({super.key, required this.category, this.size = _defaultSize});

  final CategoryModel category;
  final double size;

  static const double _defaultSize = 20;
  static const double overlapFromCorner = 6;

  @override
  Widget build(BuildContext context) {
    final String? icon = switch (category.iconToShow) {
      CategoryOfferIcon.offer => Images.offerIcon,
      CategoryOfferIcon.coupon => Images.couponIconSvg,
      null => null,
    };

    if (icon == null) {
      return const SizedBox();
    }

    return SvgPicture.asset(icon, width: size, height: size);
  }
}