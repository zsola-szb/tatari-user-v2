import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class ConversationSendMessageWidget extends StatelessWidget {
  final String channelId;
  const ConversationSendMessageWidget({super.key, required this.channelId}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(builder: (conversationController){
      return Container(
        color: conversationController.isLoading == false && ( conversationController.pickedImageFile!=null && conversationController.pickedImageFile!.isNotEmpty
            || (conversationController.objFile!=null && conversationController.objFile!.isNotEmpty)) ?
        Theme.of(context).primaryColor.withValues(alpha: 0.1) : null,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.only(top: Dimensions.padding10),

        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          conversationController.pickedImageFile != null && conversationController.pickedImageFile!.isNotEmpty && conversationController.isLoading == false ?

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70, child: ListView.builder(
                 padding: const EdgeInsets.only(bottom: Dimensions.padding6),
                clipBehavior: Clip.none,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: conversationController.pickedImageFile!.length,
                itemBuilder: (context, index){
                  return Padding(
                    key: UniqueKey(),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                    child: Stack( clipBehavior: Clip.none, children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.padding10),
                        child: SizedBox( height: 70, width: 70,
                          child:
                          Image.file(
                            File(conversationController.pickedImageFile![index].path),
                            fit: BoxFit.cover,
                            height: 65, width: 65,
                          ),
                        ),
                      ),

                      Positioned(top: -5, right: -5,
                        child: InkWell(
                          child: Image(image: AssetImage(Images.cancelIcon),
                            height: 20,
                            width: 20,
                          ),
                          onTap: () => conversationController.pickMultipleImage(true,index: index),
                        ),
                      ),


                    ]),
                  );
                },
              )),

              if(conversationController.pickedFIleCrossMaxLength)
                Text( conversationController.pickedFIleCrossMaxLength ? "• ${"can_not_select_more_than".tr} ${AppConstants.maxLimitOfTotalFileSent.floor()} ${'files'.tr}" :"",
                  style: context.subHeading.small.overrideWith(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ) : conversationController.objFile != null && conversationController.objFile!.isNotEmpty && conversationController.isLoading == false ?

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70,
                child: ListView.separated(
                  shrinkWrap: true, scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 5),
                  separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding16),
                  itemCount: conversationController.objFile!.length,
                  itemBuilder: (context, index){
                    String fileSize = index < conversationController.objFileSizes.length ? conversationController.objFileSizes[index] : '';
                    return Container(width: 180,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                      ),
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                        Image.asset(Images.fileIcon,height: 30, width: 30,),
                        const SizedBox(width: Dimensions.padding6,),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                          Text(conversationController.objFile![index].name,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: context.heading.defaultSize,
                          ),

                          Text(fileSize, style: context.body.defaultSize),
                        ])),


                        InkWell(
                          onTap: () {
                            conversationController.pickOtherFile(true, index: index);
                          },
                          child: Padding(padding: const EdgeInsets.only(top: 5),
                            child: Align(alignment: Alignment.topRight,
                              child: Icon(Icons.close,
                                size: Dimensions.padding20,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        )

                      ]),
                    );
                  },
                ),
              ),
              if(conversationController.pickedFIleCrossMaxLength)
                Text( conversationController.pickedFIleCrossMaxLength ? "• ${"can_not_select_more_than".tr} ${AppConstants.maxLimitOfTotalFileSent.floor()} ${'files'.tr}" :"",
                  style: context.subHeading.small.overrideWith(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ) : const SizedBox(),


          conversationController.isLoading ? conversationController.pickedImageFile != null && conversationController.pickedImageFile!.isNotEmpty ?

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
            child: Align(alignment: Alignment.bottomRight,
              child: Text("${'uploading'.tr} ${conversationController.pickedImageFile!.length} ${conversationController.pickedImageFile!.length >1 ? "files".tr : "file"}",
                style: context.subHeading.small.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
          ): conversationController.objFile != null && conversationController.objFile!.isNotEmpty ?

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
            child: Align(alignment: Alignment.bottomRight,
              child: Text("${'uploading'.tr} ${conversationController.objFile!.length} ${conversationController.objFile!.length >1 ? "files".tr : "file"}",
                style: context.subHeading.small.copyWith(color: Theme.of(context).hintColor),
              ),
            ),
          ): const SizedBox() : const SizedBox(),


          const SizedBox(height: Dimensions.padding6),

          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

            Expanded(flex: 6, child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius12),
                color: conversationController.isLoading ? Theme.of(context).hintColor.withValues(alpha: 0.1):
                Theme.of(context).cardColor,
                border: Border.all(
                  color: conversationController.isLoading ? Colors.transparent:
                  Theme.of(context).primaryColor.withValues(alpha: 0.4),
                ),
              ),
              padding:  const EdgeInsets.symmetric( horizontal: Dimensions.padding10,),

              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

                Expanded(child: TextField(
                  enabled: conversationController.isLoading ? false : true,
                  controller: conversationController.conversationController,
                  textCapitalization: TextCapitalization.sentences,
                  style: context.subHeading.defaultSize.overrideWith(
                    fontWeight: AppWeight.medium,
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3, minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "type_a_message".tr,
                    hintStyle: context.body.defaultSize,
                    contentPadding: const EdgeInsets.only(bottom: 7, left: 5),
                  ),
                )),
                const SizedBox(width: Dimensions.padding16),

                Padding(padding: const EdgeInsets.only(bottom: Dimensions.padding16,),
                  child: Row(children: [


                    InkWell(onTap: conversationController.isLoading ? null : () async {
                      await conversationController.pickMultipleImage(false);
                    },
                      child: Image.asset(Images.imageIcon,height: 18,width: 18),
                    ),
                    const SizedBox(width: Dimensions.padding10,),

                    InkWell(onTap: conversationController.isLoading ? null : () async {
                       await conversationController.pickOtherFile(false);

                    },
                       child: Image.asset(Images.file,height: 18,width: 18 , color: Theme.of(context).hintColor,),
                    ),
                    const SizedBox(width: Dimensions.padding10,),

                  ]),
                )],


              ),
            )),
            const SizedBox(width: Dimensions.padding16),

            Expanded(child: InkWell(
              onTap: (){
                if(conversationController.conversationController.text.isEmpty
                    && conversationController.pickedImageFile!.isEmpty
                    && conversationController.objFile==null){
                  customSnackBar("write_something".tr);
                }else{
                  conversationController.sendMessage(channelId);
                  conversationController.conversationController.clear();
                }
              },
              child: Container(
                height: Dimensions.padding24 * 2,
                width: Dimensions.padding24 * 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child:  Center(child: conversationController.isLoading ? SizedBox(
                  height: Dimensions.padding24,
                  width: Dimensions.padding24,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  ),
                ): Image(image: AssetImage(Images.sendIcon),
                  height: Dimensions.padding20 + Dimensions.padding10,
                  width: Dimensions.padding20 + Dimensions.padding10,
                  color: Get.isDarkMode ? Colors.white : null,
                ),
                ),
              ),
            ),),
          ],),

          SizedBox(height: GetPlatform.isIOS ? 5 : 0,)

        ]),
      );
    });
  }
}
