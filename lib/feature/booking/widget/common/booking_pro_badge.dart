import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const Color _proBadgeColor = Color(0xFF3979E0);

class BookingProBadge extends StatelessWidget {
  const BookingProBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6, vertical: 2),
      decoration: BoxDecoration(
        color: _proBadgeColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(Images.premiumIcon, color: Colors.white, height: 10, width: 10),
          const SizedBox(width: Dimensions.padding4),
          Text('pro'.tr, style: context.subHeading.small.medium.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
