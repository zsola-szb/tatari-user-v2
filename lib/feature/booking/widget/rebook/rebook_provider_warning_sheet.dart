import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/rebook_unavailable_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RebookProviderWarningSheet extends StatelessWidget {
  final String bookingId;

  const RebookProviderWarningSheet({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<BookingRebookController>(
        builder: (BookingRebookController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: Dimensions.padding10),
                Image.asset(Images.providerNotAvailable, width: 56, height: 56),
                const SizedBox(height: Dimensions.padding20),
                Text(
                  'provider_not_available'.tr,
                  style: context.heading.extraLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding12),
                Text(
                  'the_provider_who_previously'.tr,
                  style: context.body.defaultSize,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.padding24),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        buttonText: 'cancel'.tr,
                        backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.65),
                        radius: Dimensions.radius8,
                        onPressed: () {
                          controller.setActiveIndex(-1);
                          Get.back<void>();
                        },
                      ),
                    ),
                    const SizedBox(width: Dimensions.padding12),
                    Expanded(
                      child: CustomButton(
                        buttonText: 'yes_continue'.tr,
                        radius: Dimensions.radius8,
                        isLoading: controller.isLoading,
                        onPressed: () => _continue(controller),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.padding20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _continue(BookingRebookController controller) async {
    Get.back<void>();

    if (controller.hasUnavailableService || controller.hasPriceChange) {
      Get.bottomSheet(
        RebookUnavailableSheet(bookingId: bookingId),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
      return;
    }
    await controller.addToCart(bookingId: bookingId);
  }
}
