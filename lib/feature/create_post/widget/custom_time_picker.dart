import 'package:tatarigigs_user/common/widgets/time_picker_snipper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.padding16 ),
      child: Row(
        children: [
          Text('time'.tr, style: context.heading.large.overrideWith(color:  Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(Get.context!).colorScheme.primary)),
          const SizedBox(width: Dimensions.padding20,),
          GetBuilder<ScheduleController>(builder: (createPostController){
            return TimePickerSpinner(
              is24HourMode: Get.find<SplashController>().configModel.content?.timeFormat == '24',
              normalTextStyle: context.body.small,
              highlightedTextStyle: context.subHeading.large.overrideWith(
                fontWeight: AppWeight.medium,
                color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary,
              ),
              spacing: Dimensions.padding16,
              itemHeight: Dimensions.fontSizeLarge + 2,
              itemWidth: 50,

              alignment: Alignment.topCenter,
              isForce2Digits: true,
              onTimeChange: (time) {
                createPostController.selectedTime = "${time.hour}:${time.minute}:${time.second}";
                //createPostController.buildSchedule(scheduleType: ScheduleType.schedule);
              },
            );
          }),
        ],
      ),
    );
  }
}
