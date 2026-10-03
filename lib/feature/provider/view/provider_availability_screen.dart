import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderAvailabilityWidget extends StatelessWidget {
  final String providerId;
  const ProviderAvailabilityWidget({super.key, required this.providerId}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(

      initState: (_){
        Get.find<ProviderBookingController>().getProviderDetailsData(providerId, false);
      },
      builder: (providerBookingController){

        final daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday","friday"];
        final weekends = providerBookingController.providerDetailsContent?.provider?.weekends ?? [];
        List<String> workingDays = [];
        for (var element in daysOfWeek) {
          if(!weekends.contains(element)){
            workingDays.add(element);
          }
        }
        String? startTime = providerBookingController.providerDetailsContent?.provider?.timeSchedule?.startTime;
        String? endTime = providerBookingController.providerDetailsContent?.provider?.timeSchedule?.endTime;
        String currentTime = DateConverter.convertStringTimeToDate(DateTime.now());
        String dayOfWeek = DateConverter.dateToWeek(DateTime.now());

        bool timeSlotAvailable;
        if(startTime !=null && endTime !=null){
          timeSlotAvailable = _isUnderTime(currentTime, startTime, endTime) && (!weekends.contains(dayOfWeek.toLowerCase()));
        }else{
          timeSlotAvailable = false;
        }


        return SizedBox(
          width: Dimensions.webMaxWidth / 2,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(Dimensions.padding10),
            child: Column(mainAxisSize: MainAxisSize.min,children: [

              InkWell(
                onTap: (){
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close, color: Theme.of(context).hintColor),
                ),
              ),

              const SizedBox(height: Dimensions.padding10),
              (providerBookingController.providerDetailsContent?.provider?.isAvailable == false) ? Column(children: [

                Text('provider_is_currently_unavailable'.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),),

                Row(mainAxisAlignment: MainAxisAlignment.center , children: [

                  Icon(Icons.schedule,size: Dimensions.fontSizeLarge, color:Theme.of(context).textTheme.bodyLarge?.color ,),
                  const SizedBox(width: Dimensions.padding6,),
                  Text("availability".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),),
                ],),

                const SizedBox(height: Dimensions.padding16,),

                Text("unavailability_hint_text".tr,
                  style: context.subHeading.defaultSize,
                  textAlign: TextAlign.center,
                ),

              ],) :

              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start ,children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                  child: Text("availability".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),),
                ),
                const SizedBox(height: Dimensions.padding8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start , children: [

                    Icon(Icons.schedule,size: Dimensions.fontSizeDefault, color:Theme.of(context).textTheme.bodySmall?.color ,),
                    const SizedBox(width: Dimensions.padding6,),
                    Text( timeSlotAvailable ? "${'today_available_till'.tr} ${DateConverter.convertStringDateTimeToTime(endTime ?? "00:00")}" : "provider_is_currently_on_a_break".tr, style: context.body.defaultSize,),
                  ],),
                ),


                weekends.length == 7 || providerBookingController.providerDetailsContent?.provider?.timeSchedule == null ? const SizedBox(height: Dimensions.padding16,) :
                Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

                  workingDays.isNotEmpty ?  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                      color: Theme.of(context).hintColor.withValues(alpha: 0.1)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20, vertical: Dimensions.padding16),
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.padding20, horizontal: Dimensions.padding10),
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: Dimensions.padding6),
                      Text("usually_available_from".tr, style: context.body.defaultSize,),
                      const SizedBox(height: Dimensions.padding10,),
                      if(providerBookingController.providerDetailsContent?.provider?.timeSchedule != null)
                        Text("${DateConverter.convertStringDateTimeToTime(startTime!)} - ${DateConverter.convertStringDateTimeToTime(endTime!)}", style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),),

                      const SizedBox(height: Dimensions.padding16,),
                      Text(providerBookingController.formatDays(workingDays), style: context.body.defaultSize,textAlign: TextAlign.center,),

                      const Row(),

                             ]),
                  ) : const SizedBox(),

                  weekends.isNotEmpty ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                    child: Row(children: [
                      Text("day_off".tr, style: context.body.defaultSize,),
                      const SizedBox(width: Dimensions.padding8,),
                      Text(providerBookingController.formatDays(weekends), style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium), textAlign: TextAlign.center,),

                    ],),
                  ) : const SizedBox(),

                  const SizedBox(height: Dimensions.padding16),

                ],),
              ],)
            ]),
          ),
        );
      },
    );
  }

  bool _isUnderTime(String time, String startTime, String? endTime) {
    return DateConverter.convertTimeToDateTime(time).isAfter(DateConverter.convertTimeToDateTime(startTime))
        && DateConverter.convertTimeToDateTime(time).isBefore(DateConverter.convertTimeToDateTime(endTime!));
  }
}
