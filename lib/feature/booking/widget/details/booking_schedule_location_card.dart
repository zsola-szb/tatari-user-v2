import 'package:tatarigigs_user/feature/booking/widget/common/booking_detail_row.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_info_box.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/repeat/repeat_overview_sheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingScheduleLocationCard extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;
  final Widget? providerTile;
  final Widget? servicemanTile;

  const BookingScheduleLocationCard({
    super.key,
    required this.booking,
    required this.controller,
    this.providerTile,
    this.servicemanTile,
  });

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(Dimensions.radius16),
        topRight: Radius.circular(Dimensions.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (servicemanTile != null) ...<Widget>[
            servicemanTile!,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
              child: Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
            ),
          ],
          _scheduleRow(context),
          const SizedBox(height: Dimensions.padding16),
          BookingDetailRow(
            icon: Icons.location_on_outlined,
            title: 'service_location'.tr,
            value: controller.isProviderLocationPending ? null : _locationValue(),
            onTap: controller.canOpenDirections ? () => _openDirections(context) : null,
          ),
          if (providerTile != null) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            providerTile!,
          ],
          if (controller.isProviderLocationPending) ...<Widget>[
            const SizedBox(height: Dimensions.padding12),
            BookingInfoBox(
              child: Text(
                'provider_location_available_after_accept'.tr,
                style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
              ),
            ),
          ],
          if (controller.isAtProviderLocation) ...<Widget>[
            const SizedBox(height: Dimensions.padding10),
            BookingInfoBox(
              tone: BookingInfoTone.warning,
              child: Text(
                'you_need_to_visit_provider_location'.tr,
                style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _scheduleRow(BuildContext context) {
    if (booking.kind.isRepeatParent) {
      return BookingDetailRow(
        icon: Icons.event_repeat_outlined,
        title: 'repeat_booking'.tr,
        value: 'you_will_receive_service_times'.trParams(<String, String>{
          'count': '${booking.repeat.totalCount}',
        }),
        onTap: () => Get.bottomSheet(
          RepeatOverviewSheet(booking: booking),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        ),
      );
    }

    final DateTime? scheduledAt = booking.scheduledAt;
    return BookingDetailRow(
      icon: Icons.calendar_today_outlined,
      title: controller.scheduleKind.labelKey.tr,
      value: scheduledAt == null ? '-' : DateConverter.dateMonthYearTime(scheduledAt),
    );
  }

  String _locationValue() => controller.serviceLocationAddress ?? 'address_not_found'.tr;

  Future<void> _openDirections(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
      return;
    }

    Get.dialog(const CustomLoader(), barrierDismissible: false);
    try {
      final Position position = await Geolocator.getCurrentPosition();
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
        '&origin=${position.latitude},${position.longitude}'
        '&destination=${booking.provider?.latitude},${booking.provider?.longitude}&mode=d',
      );
      Get.back<void>();
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        customSnackBar('something_went_wrong'.tr);
      }
    } catch (_) {
      Get.back<void>();
      customSnackBar('something_went_wrong'.tr);
    }
  }
}
