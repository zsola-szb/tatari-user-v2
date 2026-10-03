import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CartWidget extends GetView<CartController> {
  final Color color;
  final double size;
  final bool fromRestaurant;
  const CartWidget({super.key, required this.color, required this.size, this.fromRestaurant = false});

  static const double _tapTargetSize = 36;

  @override
  Widget build(BuildContext context) {
    final double inset = (_tapTargetSize - size) / 2;

    return Stack(clipBehavior: Clip.none, children: [
      SvgPicture.asset(Images.serviceCart, width: size, height: size, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
      Positioned(top: -inset, right: -inset, child: const AppBarCartBadge()),
    ]);
  }
}
