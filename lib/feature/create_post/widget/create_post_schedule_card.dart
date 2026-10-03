import 'package:tatarigigs_user/feature/checkout/widget/booking_type/checkout_schedule_picker_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_edit_icon_button.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CreatePostScheduleCard extends StatelessWidget {
  const CreatePostScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (ScheduleController scheduleController){
      final bool instantAllowed = Get.find<SplashController>().configModel.content?.instantBooking == 1;
      final bool scheduleAllowed = Get.find<CartController>().checkScheduleBookingAvailability() == null;
      final DateTime? scheduledAt = scheduleController.getSelectedDateTime();
      final bool isScheduled = scheduledAt != null;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  _title(isScheduled: isScheduled, instantAllowed: instantAllowed, scheduleAllowed: scheduleAllowed),
                  style: context.heading.defaultSize,
                ),
                const SizedBox(height: Dimensions.padding4),
                Text(
                  _hint(isScheduled: isScheduled, instantAllowed: instantAllowed, scheduleAllowed: scheduleAllowed),
                  style: context.body.small,
                ),
              ]),
            ),
            if(scheduleAllowed) ...[
              const SizedBox(width: Dimensions.padding10),
              CheckoutEditIconButton(
                size: 28,
                onTap: () => _openPicker(
                  context: context,
                  scheduleController: scheduleController,
                  scheduledAt: scheduledAt,
                  instantAllowed: instantAllowed,
                ),
              ),
            ],
          ]),

          if(isScheduled) ...[
            const SizedBox(height: Dimensions.padding16),
            Text(DateConverter.dateMonthYearTime(scheduledAt), style: context.heading.large),
          ],
        ]),
      );
    });
  }

  static String _title({required bool isScheduled, required bool instantAllowed, required bool scheduleAllowed}) {
    final bool scheduleRequired = !instantAllowed && scheduleAllowed;
    return (isScheduled || scheduleRequired) ? 'schedule_service'.tr : 'instant_service'.tr;
  }

  static String _hint({required bool isScheduled, required bool instantAllowed, required bool scheduleAllowed}) {
    if(!instantAllowed && !scheduleAllowed){
      return 'booking_currently_unavailable'.tr;
    }
    if(isScheduled){
      return 'schedule_service_hint'.tr;
    }
    if(!instantAllowed){
      return 'please_select_schedule_time'.tr;
    }
    return 'instant_service_hint'.tr;
  }

  void _openPicker({
    required BuildContext context,
    required ScheduleController scheduleController,
    required DateTime? scheduledAt,
    required bool instantAllowed,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => CheckoutSchedulePickerSheet(
        mode: CheckoutSchedulePickerMode.single,
        initialDateTime: scheduledAt,
        onInstantBooking: instantAllowed ? () => scheduleController.applySingleSchedule(null) : null,
        onSingleSaved: (DateTime picked) {
          scheduleController.applySingleSchedule(picked);

          final ConfigContent? config = Get.find<SplashController>().configModel.content;
          final AdvanceBooking? advanceBooking = config?.advanceBooking;
          if(config?.scheduleBookingTimeRestriction == 1 && advanceBooking?.advancedBookingRestrictionValue != null){
            final String? restriction = scheduleController.checkValidityOfTimeRestriction(advanceBooking!);
            if(restriction != null){
              customSnackBar(restriction, type: ToasterMessageType.info);
            }
          }
        },
      ),
    );
  }
}
