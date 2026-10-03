import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingRepeatBadge extends StatelessWidget {
  final double size;

  const BookingRepeatBadge({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Images.repeatBookingIcon,
      height: size,
      width: size,
    );
  }
}
