import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingIgnoredSheet extends StatelessWidget {
  final String bookingId;

  const BookingIgnoredSheet({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<BookingDetailsController>(
        builder: (BookingDetailsController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(Images.providerUnavailable, width: 60),
                const SizedBox(height: Dimensions.padding16),
                Text(
                  'booking_ignored_title'.tr,
                  style: context.heading.extraLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding10),
                Text(
                  'booking_ignored_description'.tr,
                  style: context.body.small,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding24),
                CustomButton(
                  buttonText: "${'let'.tr} ${AppConstants.appName} ${'choose'.tr}",
                  radius: Dimensions.radius8,
                  onPressed: () {
                    Get.back<void>();
                    customSnackBar(
                      "${'thanks_for_choosing'.tr} ${AppConstants.appName}",
                      type: ToasterMessageType.success,
                    );
                  },
                ),
                const SizedBox(height: Dimensions.padding10),
                TextButton(
                  onPressed: controller.isCancelling ? null : () => _cancel(controller),
                  child: Text('cancel_booking'.tr, style: context.body.defaultSize),
                ),
                const SizedBox(height: Dimensions.padding8),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _cancel(BookingDetailsController controller) async {
    Get.back<void>();
    await controller.cancelBookingById(bookingId: bookingId);
  }
}