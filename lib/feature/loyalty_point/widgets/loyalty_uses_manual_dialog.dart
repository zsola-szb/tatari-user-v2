import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointUsesManualDialog extends StatelessWidget {
  const LoyaltyPointUsesManualDialog({super.key}) ;

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(() => LoyaltyPointController(loyaltyPointRepo: LoyaltyPointRepo(apiClient: Get.find())));

    return GetBuilder<LoyaltyPointController>(builder: (controller){
      double minimumConvertAblePoint = double.tryParse(controller.loyaltyPointModel?.content?.minLoyaltyPointToTransfer??"0")??0;
      return Padding(
        padding:const EdgeInsets.fromLTRB(20,70,20,0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(child: const Row(mainAxisAlignment: MainAxisAlignment.end,children: [Icon(Icons.highlight_remove,size: 20,)]),
                        onTap: ()=>Get.back(),
                      ),

                      Padding(
                          padding: const EdgeInsets.fromLTRB(0,Dimensions.padding6,0,Dimensions.padding10),
                          child: Text('how_to_use'.tr,style: context.heading.large.overrideWith(color:Get.isDarkMode?Colors.white70 : Theme.of(context).primaryColor),)),

                      Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        const Padding(padding: EdgeInsets.only(left: Dimensions.padding10, right: Dimensions.padding10,top: 3),
                          child: Icon(Icons.circle,size: 7,),
                        ),
                        Expanded(child: Text('convert_point_hint_text'.tr)),
                      ]),
                      const SizedBox(height: Dimensions.padding10,),

                      Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        const Padding(padding: EdgeInsets.only(left: Dimensions.padding10, right: Dimensions.padding10,top: 3),
                          child: Icon(Icons.circle,size: 7,),
                        ),
                        Expanded(child: Text('${'minimum'.tr} $minimumConvertAblePoint ${'points_required_to_convert_point'.tr}'.tr)),
                      ]),
                      const SizedBox(height: Dimensions.padding24,),
                    ],),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


