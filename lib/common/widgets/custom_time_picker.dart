import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatelessWidget {
  final  TimeOfDay? time;
  final Function(TimeOfDay) onTimeChanged;
  final bool isExpandedRow;

  final DateTime? selectedDate;

  const CustomTimePicker({super.key, this.time, required this.onTimeChanged, this.isExpandedRow = true, this.selectedDate});

  static Future<TimeOfDay?> pick(BuildContext context, {TimeOfDay? initialTime, DateTime? selectedDate}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: Get.find<SplashController>().configModel.content?.timeFormat == "24",
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) {
      return null;
    }

    if (selectedDate != null &&
        DateConverter.combineDateTimeAndTimeOfDay(date: selectedDate, time: pickedTime)
            .isBefore(DateConverter.nowWithoutSeconds())) {
      customSnackBar('selected_time_cannot_earlier'.tr, type: ToasterMessageType.info);
      return null;
    }

    return pickedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      InkWell(
        onTap: () async {
          TimeOfDay? pickedTime = await CustomTimePicker.pick(context, initialTime: time, selectedDate: selectedDate);
          if(pickedTime != null) {
            onTimeChanged(pickedTime);
          }
        },
        child: Container(
          height: isExpandedRow ? 50 : 35, alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: isExpandedRow ?  Dimensions.padding16 : Dimensions.padding10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: 0.5),
          ),
          child: Row(children: [

            Text(
              time != null ? DateConverter.convertDateTimeToTime(DateTime(DateTime.now().year, 1, 1, time!.hour, time!.minute)) : 'time_hint'.tr,
              style: context.subHeading.defaultSize.overrideWith(color: time != null ? null : Theme.of(context).hintColor),
              maxLines: 1,
            ),
            isExpandedRow ? const Expanded(child: SizedBox()) : const SizedBox(width: Dimensions.padding10,),

            Icon(Icons.access_time, size: 20,   color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5)),

          ]),
        ),
      ),

    ]);
  }
}



