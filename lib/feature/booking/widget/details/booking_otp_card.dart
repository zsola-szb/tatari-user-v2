import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingOtpCard extends StatelessWidget {
  final String otp;

  const BookingOtpCard({super.key, required this.otp});

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      child: Column(
        children: <Widget>[
          Text('otp_verification_code'.tr, style: context.heading.defaultSize),
          const SizedBox(height: Dimensions.padding8),
          Text.rich(
            TextSpan(
              text: '${'your_otp_is'.tr} : ',
              style: context.body.small,
              children: <InlineSpan>[
                TextSpan(
                  text: otp.replaceAll('null', '').trim(),
                  style: context.heading.large,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
