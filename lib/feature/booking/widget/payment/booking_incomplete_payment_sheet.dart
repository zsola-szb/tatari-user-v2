import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingIncompletePaymentPrompt {
  const BookingIncompletePaymentPrompt._();

  static Future<void> showIfNeeded() async {
    if (!Get.find<AuthController>().isLoggedIn()) {
      return;
    }
    if (Get.isDialogOpen ?? false) {
      return;
    }

    final BookingListItemModel? booking = Get.find<UserController>().userInfoModel?.lastIncompleteOfflineBooking;
    final String bookingId = booking?.id ?? '';
    if (bookingId.isEmpty) {
      return;
    }

    final BookingDetailsController controller = Get.find<BookingDetailsController>();
    if (controller.dismissedIncompleteBookingId == bookingId) {
      return;
    }

    await Get.bottomSheet<void>(
      BookingIncompletePaymentSheet(
        bookingId: bookingId,
        readableId: booking?.readableId ?? '',
        amount: booking?.totalAmount ?? 0,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );

    await controller.markIncompleteBookingDismissed(bookingId);
  }
}

class BookingIncompletePaymentSheet extends StatelessWidget {
  final String bookingId;
  final String readableId;
  final double amount;

  const BookingIncompletePaymentSheet({
    super.key,
    required this.bookingId,
    required this.readableId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(Images.warning, height: 52, width: 52),
            const SizedBox(height: Dimensions.padding16),
            Text(
              'your_payment_was_incomplete'.tr,
              style: context.heading.extraLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.padding8),
            Text(
              '${'booking_id'.tr} # $readableId',
              style: context.body.small,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.padding6),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                PriceConverter.convertPrice(amount, isShowLongPrice: true),
                style: context.heading.overLarge,
              ),
            ),
            const SizedBox(height: Dimensions.padding24),
            CustomButton(
              buttonText: 'complete_payment'.tr,
              radius: Dimensions.radius8,
              onPressed: () {
                Get.back<void>();
                Get.toNamed<void>(RouteHelper.getBookingDetailsRoute(bookingId: bookingId));
              },
            ),
            const SizedBox(height: Dimensions.padding10),
            TextButton(
              onPressed: () => Get.back<void>(),
              child: Text('not_now'.tr, style: context.body.defaultSize),
            ),
            const SizedBox(height: Dimensions.padding8),
          ],
        ),
      ),
    );
  }
}
