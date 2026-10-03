import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AdditionalInstructionDialog extends StatelessWidget {
  const AdditionalInstructionDialog({super.key,}) ;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius20)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GetBuilder<CreatePostController>(
          builder: (createPostController) {
        return SizedBox(
          width: Dimensions.webMaxWidth/1.5,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [

                const SizedBox(height: Dimensions.padding24,),

                Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('add_additional_instruction'.tr,style:  context.subHeading.defaultSize),
                    const SizedBox(height: Dimensions.padding24,)
                  ]),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16,vertical: Dimensions.padding6),
                  child: CustomTextFormField(
                    hintText: "write_something".tr,
                    inputType: TextInputType.text,
                    controller: createPostController.additionalInstructionController,
                    maxLines: 3,
                    isShowBorder: true,
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
                  child: CustomButton(
                    buttonText: "add".tr, height: 35, width: 80,
                    radius: Dimensions.radiusFull,
                    fontSize: Dimensions.fontSizeDefault,
                    onPressed: (){
                      String value = createPostController.additionalInstructionController.text;
                      if(value.isNotEmpty){
                        createPostController.addAdditionalInstruction(value);
                      }else{
                        customSnackBar('enter_additional_instruction'.tr, type: ToasterMessageType.info);
                      }
                      Get.back();
                    },
                  ),
                ),
              ]),

              Padding(
                padding: const EdgeInsets.all(Dimensions.padding10),
                child: GestureDetector(
                  onTap: (){
                    Get.find<CreatePostController>().additionalInstructionController.text = '';
                    Get.back();
                    },

                  child: Icon(Icons.close,size: 25,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).primaryColor,),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
