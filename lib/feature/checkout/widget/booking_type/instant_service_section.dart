import 'package:tatarigigs_user/feature/checkout/widget/booking_type/checkout_schedule_picker_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/schedule_conflict_banner.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_header.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class InstantServiceSection extends StatelessWidget {
  const InstantServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return GetBuilder<CheckoutScheduleController>(
          builder: (CheckoutScheduleController schedule) {
            final bool instantAllowed = controller.isInstantBookingAllowed;
            final bool scheduleAllowed = controller.isScheduleBookingAllowed;
            final DateTime? scheduledAt = schedule.singleScheduleAt;
            final bool isScheduled = scheduledAt != null;
            final String? conflict = controller.scheduleAvailabilityError;

            return CheckoutSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CheckoutSectionHeader(
                    isLargeTitle: true,
                    title: _title(
                      isScheduled: isScheduled,
                      instantAllowed: instantAllowed,
                      scheduleAllowed: scheduleAllowed,
                    ),
                    subtitle: _hint(
                      isScheduled: isScheduled,
                      instantAllowed: instantAllowed,
                      scheduleAllowed: scheduleAllowed,
                    ),
                    trailing: scheduleAllowed
                        ? CheckoutEditIconButton(
                            onTap: () => _openPicker(
                              context: context,
                              controller: controller,
                              schedule: schedule,
                              instantAllowed: instantAllowed,
                            ),
                          )
                        : null,
                  ),
                  if (isScheduled) ...<Widget>[
                    const SizedBox(height: Dimensions.padding16),
                    Text(
                      DateConverter.dateMonthYearTime(scheduledAt),
                      style: context.heading.large,
                    ),
                  ],
                  if (conflict != null) ...<Widget>[
                    const SizedBox(height: Dimensions.padding10),
                    ScheduleConflictBanner(message: conflict),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  static String _title({
    required bool isScheduled,
    required bool instantAllowed,
    required bool scheduleAllowed,
  }) {
    final bool scheduleRequired = !instantAllowed && scheduleAllowed;
    return (isScheduled || scheduleRequired) ? 'schedule_service'.tr : 'instant_service'.tr;
  }

  static String _hint({
    required bool isScheduled,
    required bool instantAllowed,
    required bool scheduleAllowed,
  }) {
    if (!instantAllowed && !scheduleAllowed) {
      return 'booking_currently_unavailable'.tr;
    }
    if (isScheduled) {
      return 'schedule_service_hint'.tr;
    }
    if (!instantAllowed) {
      return 'please_select_schedule_time'.tr;
    }
    return 'instant_service_hint'.tr;
  }

  void _openPicker({
    required BuildContext context,
    required CheckoutController controller,
    required CheckoutScheduleController schedule,
    required bool instantAllowed,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => CheckoutSchedulePickerSheet(
        mode: CheckoutSchedulePickerMode.single,
        initialDateTime: schedule.singleScheduleAt,
        onInstantBooking: instantAllowed
            ? () {schedule.setSingleSchedule(null);controller.recalculateTotals();} : null,
        onSingleSaved: (DateTime picked) {
          schedule.setSingleSchedule(picked);
          final String? restriction = schedule.checkLeadTimeRestriction(
            Get.find<SplashController>().configModel.content?.advanceBooking,
          );
          if (Get.find<SplashController>().configModel.content?.scheduleBookingTimeRestriction ==
                  1 && restriction != null) {customSnackBar(restriction, type: ToasterMessageType.info);}
          controller.recalculateTotals();
        },
      ),
    );
  }
}
