import 'package:tatarigigs_user/feature/booking/widget/common/booking_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/rebook_provider_warning_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/rebook_unavailable_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

abstract class BookingRebookFlow {
  static Future<void> start(
    BuildContext context, {
    required String bookingId,
    required String subCategoryId,
    int index = -1,
  }) async {
    final BookingRebookController controller = Get.find<BookingRebookController>();
    controller.setActiveIndex(index);

    if (controller.cartConflictsWith(subCategoryId)) {
      final bool confirmed = await _confirmCartReset(context);
      if (!confirmed) {
        controller.setActiveIndex(-1);
        return;
      }
      await controller.clearCart();
    }

    await controller.checkAvailability(bookingId: bookingId);

    switch (controller.decision) {
      case RebookDecision.proceed:
        await controller.addToCart(bookingId: bookingId);
        break;

      case RebookDecision.providerUnavailable:
        Get.bottomSheet(
          RebookProviderWarningSheet(bookingId: bookingId),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
        break;

      case RebookDecision.servicesChanged:
        Get.bottomSheet(
          RebookUnavailableSheet(bookingId: bookingId),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
        break;

      case RebookDecision.failed:
        controller.setActiveIndex(-1);
        break;
    }
  }

  static Future<bool> _confirmCartReset(BuildContext context) async {
    final bool? confirmed = await showBookingBottomSheet<bool>(
      ConfirmationBottomsheet(
        icon: Images.warning,
        title: 'are_you_sure_to_reset'.tr,
        description: 'you_have_service_from_other_sub_category'.tr,
        onYesPressed: () => Get.back<bool>(result: true),
        onNoPressed: () => Get.back<bool>(result: false),
      ),
    );
    return confirmed ?? false;
  }
}
