import 'dart:isolate';
import 'dart:ui';

import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';




class ConversationBubbleWidget extends StatefulWidget {
  final ConversationData conversationData;
  final bool isRightMessage;
  final ConversationData? nextConversationData;
  final ConversationData? previousConversationData;
  final String? name;
  final String? image;

  const ConversationBubbleWidget({super.key,
    required this.conversationData,
    required this.isRightMessage,
    this.nextConversationData,
    this.previousConversationData,
    this.name,
    this.image
  });

  @override
  State<ConversationBubbleWidget> createState() => _ConversationBubbleWidgetState();
}

class _ConversationBubbleWidgetState extends State<ConversationBubbleWidget> {
  //final ReceivePort _port = ReceivePort();


  @override
  void initState() {
    super.initState();
    if(ResponsiveHelper.isMobile(Get.context!)){
      ReceivePort port = ReceivePort();
      IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');
      port.listen((dynamic data) {
        setState((){ });
      });

      //FlutterDownloader.registerCallback(downloadCallback);
    }

  }

  @override
  void dispose() {
    if(ResponsiveHelper.isMobile(Get.context!)){
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }



  @override
  Widget build(BuildContext context) {

    List<ConversationFile> imageList = [];
    List<ConversationFile> fileList = [];

    if(widget.conversationData.conversationFile != null && widget.conversationData.conversationFile!.isNotEmpty){
      for(ConversationFile conversationFile in widget.conversationData.conversationFile!){
        conversationFile.fileType == 'png' || conversationFile.fileType == 'jpg' ? imageList.add(conversationFile):
        fileList.add(conversationFile);
      }
    }


    List<String> imagePathList = [];

    for (var element in imageList) {
      imagePathList.add(element.storedFileNameFullPath??"");
    }

    if (kDebugMode) {
      print("User Type : ${widget.conversationData.user?.userType} and Logo is : ${widget.conversationData.user?.provider?.logo}");
    }
    return GetBuilder<ConversationController>(
        builder: (conversationController) {


          bool isLTR = Get.find<LocalizationController>().isLtr;
          String chatTime  = conversationController.getChatTime(widget.conversationData.createdAt!, widget.nextConversationData?.createdAt);

          bool isSameUserWithPreviousMessage = conversationController.isSameUserWithPreviousMessage(widget.previousConversationData, widget.conversationData);
          bool isSameUserWithNextMessage = conversationController.isSameUserWithNextMessage(widget.conversationData, widget.nextConversationData);
          String previousMessageHasChatTime = widget.previousConversationData != null? conversationController.getChatTime(widget.previousConversationData!.createdAt!, widget.conversationData.createdAt) : "";


          return Column(crossAxisAlignment: widget.isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [


            if(chatTime != "")
              Align(alignment: Alignment.center,
                child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.padding16, top: 5),
                  child: Text(conversationController.getChatTime(widget.conversationData.createdAt!, widget.nextConversationData?.createdAt),
                  ),
                ),
              ),

            Padding(padding: widget.isRightMessage
                ? EdgeInsets.fromLTRB(20, (widget.conversationData.message!=null && isSameUserWithNextMessage) ? 5 : 15, 5,
                (isSameUserWithNextMessage || isSameUserWithPreviousMessage) && (widget.conversationData.message!=null && previousMessageHasChatTime == "") ? 0 : 10)

                : EdgeInsets.fromLTRB(5, isSameUserWithNextMessage? 5 : 10, 20, (isSameUserWithNextMessage || isSameUserWithPreviousMessage)  && widget.conversationData.message!=null ? 0 : 10),

              child: Column(crossAxisAlignment: widget.isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [

                Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, mainAxisAlignment: widget.isRightMessage ? MainAxisAlignment.end : MainAxisAlignment.start, children: [

                  widget.isRightMessage ? const SizedBox() :
                  (!widget.isRightMessage && !isSameUserWithPreviousMessage) ||
                      ( (!widget.isRightMessage && isSameUserWithPreviousMessage) &&
                          conversationController.getChatTimeWithPrevious(widget.conversationData, widget.previousConversationData).isNotEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.padding24 * 2),
                    child: CustomImage(height: Dimensions.padding24 + 5,
                      width: Dimensions.padding24 + 5,
                      image: widget.image,
                      placeholder: widget.conversationData.user!.userType=="super-admin" ? Images.adminPlaceHolder : Images.userPlaceHolder,
                    ),
                  ): !widget.isRightMessage ? const SizedBox(width: Dimensions.padding24 + 5,) : const SizedBox() ,
                  const SizedBox(width: Dimensions.padding10,),

                  Flexible(child: Column(crossAxisAlignment: widget.isRightMessage? CrossAxisAlignment.end:CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                    if(widget.conversationData.message != null) Flexible(child: Container(
                      decoration: BoxDecoration(
                        color: widget.isRightMessage
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: widget.isRightMessage && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                          topRight: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime =="" ? Dimensions.radius6 : Dimensions.radius20 + 5),
                          bottomRight: Radius.circular(isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radius6 : Dimensions.radius20 + 5),
                          topLeft: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radius6 : Dimensions.radius20 + 5),
                          bottomLeft: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radius6 :Dimensions.radius20 + 5),

                        ) : !widget.isRightMessage && (isSameUserWithNextMessage || isSameUserWithPreviousMessage) ? BorderRadius.only(
                          topLeft: Radius.circular(isSameUserWithNextMessage && isLTR && chatTime ==""? Dimensions.radius6 : Dimensions.radius20 + 5),
                          bottomLeft: Radius.circular( isSameUserWithPreviousMessage && isLTR && previousMessageHasChatTime =="" ? Dimensions.radius6 : Dimensions.radius20 + 5),
                          topRight: Radius.circular(isSameUserWithNextMessage && !isLTR && chatTime ==""? Dimensions.radius6 : Dimensions.radius20 + 5),
                          bottomRight: Radius.circular(isSameUserWithPreviousMessage && !isLTR && previousMessageHasChatTime ==""? Dimensions.radius6 :Dimensions.radius20 + 5),

                        ) : BorderRadius.circular(Dimensions.radius20 + 5),
                      ),

                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20, vertical: 10),
                      child: InkWell(
                        onTap: (){
                          conversationController.toggleOnClickMessage(onMessageTimeShowID :
                          widget.conversationData.id!);
                        },
                        child: Text(widget.conversationData.message??'', style: context.subHeading.defaultSize.overrideWith(
                          color: !Get.isDarkMode && !widget.isRightMessage? Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.8),
                        )),
                      ),

                    )),
                    AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      height: conversationController.onMessageTimeShowID == widget.conversationData.id ? 25.0 : 0.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: conversationController.onMessageTimeShowID == widget.conversationData.id ?
                          Dimensions.padding6 : 0.0,
                        ),
                        child: Text(conversationController.getOnPressChatTime(widget.conversationData) ?? "", style: context.subHeading.small,),
                      ),
                    ),


                    if(widget.conversationData.message != null && widget.conversationData.conversationFile!.isNotEmpty)
                      const SizedBox(height: Dimensions.padding10),

                    widget.conversationData.conversationFile!.isNotEmpty ?
                    Column(crossAxisAlignment: widget.isRightMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [

                      imageList.isNotEmpty ? Directionality(
                        textDirection: widget.isRightMessage  && Get.find<LocalizationController>().isLtr?
                        TextDirection.rtl: !Get.find<LocalizationController>().isLtr && !widget.isRightMessage?
                        TextDirection.rtl: TextDirection.ltr,

                        child: SizedBox(width: 200,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageList.length > 3 ? 4 : imageList.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: Dimensions.padding10,
                              crossAxisSpacing: Dimensions.padding10,
                            ),
                            itemBuilder: (context, index) {

                              String imageUrl = '';
                              try{
                                imageUrl = imageList[index].storedFileNameFullPath ?? '';
                              }catch(e) {
                                if (kDebugMode) {
                                  print("");
                                }
                              }


                              if(index == 3  ) { return Directionality(
                                textDirection: TextDirection.ltr,
                                child: InkWell(
                                  onTap: (){
                                    Get.to(ImageDetailScreen(
                                      imageList: imagePathList,
                                      index: index,
                                      createdAt:  DateConverter.dateMonthYearTime(DateConverter.isoUtcStringToLocalDate(widget.conversationData.createdAt!)),
                                      appbarTitle: widget.conversationData.user!.userType=="super-admin" ? 'admin'.tr : widget.conversationData.user!.userType=="customer"? "you".tr :
                                      widget.conversationData.user?.userType == 'provider-admin' ? widget.name : "${widget.conversationData.user?.firstName??""} ${widget.conversationData.user?.lastName??""}",
                                    ),
                                    );

                                  },
                                  onLongPress: (){
                                    conversationController.toggleOnClickImageAndFile(onImageOrFileTimeShowID :
                                    widget.conversationData.id!);
                                  },
                                  child: Hero(
                                    tag: imageList[index].storedFileNameFullPath??"",
                                    child: Stack(children: [


                                      SizedBox(height: double.infinity, width: double.infinity,
                                          child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radius16),
                                            child: CustomImage(image: imageUrl, fit: BoxFit.contain,),
                                          )),


                                      Container(decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(Dimensions.radius16)
                                      )),


                                      Positioned.fill(child: Center(
                                        child: Text("+${imageList.length - index}",
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeLarge,
                                        ),),
                                      )),
                                    ]),
                                  ),
                                ),
                              );}


                              else if(index > 3) {return const SizedBox();}

                              else{
                                return InkWell(
                                  onTap: () {

                                    Get.to(ImageDetailScreen(
                                      imageList: imagePathList,
                                      index: index,
                                      createdAt:  DateConverter.dateMonthYearTime(DateConverter.isoUtcStringToLocalDate(widget.conversationData.createdAt!)),
                                      appbarTitle: widget.conversationData.user!.userType=="super-admin" ? 'admin'.tr : widget.conversationData.user!.userType=="customer"? "you".tr :
                                      widget.conversationData.user?.userType == 'provider-admin' ? widget.name :
                                      "${widget.conversationData.user?.firstName??""} ${widget.conversationData.user?.lastName??""}" ,
                                    ),
                                    );
                                  },
                                  onLongPress: (){
                                    conversationController.toggleOnClickImageAndFile(onImageOrFileTimeShowID :
                                    widget.conversationData.id!);
                                  },
                                  child: Hero(
                                    tag: imageList[index].storedFileNameFullPath??"",
                                    child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radius16),
                                        child: CustomImage(image: imageUrl, fit: BoxFit.fill)),
                                  ),
                                );
                              }

                            },
                          ),
                        ),
                      ): const SizedBox(),


                      fileList.isNotEmpty ?
                      Directionality(
                        textDirection: widget.isRightMessage  && Get.find<LocalizationController>().isLtr?
                        TextDirection.rtl : !Get.find<LocalizationController>().isLtr && !widget.isRightMessage?
                        TextDirection.rtl : TextDirection.ltr,

                        child: SizedBox(
                          width: 300,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: fileList.length,
                              padding: imageList.isNotEmpty ? const EdgeInsets.only(top: Dimensions.padding10) : EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 60,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: Dimensions.padding6,
                                  crossAxisSpacing: Dimensions.padding6
                              ),
                              itemBuilder: (context, index){

                                return InkWell(
                                  onTap: ()async{
                                    final status = await Permission.notification.request();
                                    if (kDebugMode) {
                                      print("Status is $status");
                                    }
                                    if(status.isGranted){
                                      Directory? directory = Directory('/storage/emulated/0/Download');
                                      if (!await directory.exists()){
                                        directory = Platform.isAndroid
                                            ? await getExternalStorageDirectory() //FOR ANDROID
                                            : await getApplicationSupportDirectory();
                                      }
                                      Get.find<ConversationController>().downloadFile(
                                        fileList[index].storedFileNameFullPath ?? '',
                                        directory!.path,
                                      );
                                    }else if(status.isDenied){
                                      await openAppSettings();
                                    }
                                  },
                                  onLongPress: (){
                                    conversationController.toggleOnClickImageAndFile(onImageOrFileTimeShowID :
                                    widget.conversationData.id!);
                                  },
                                  child: Container(width: 200, height: 60,
                                      decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(Dimensions.radius12),),
                                      child: Padding(padding: const EdgeInsets.all(Dimensions.padding10),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Row(children: [


                                              Image(image: AssetImage(Images.fileIcon),
                                                height: 30,
                                                width: 30,
                                              ),
                                              const SizedBox(width: Dimensions.padding6),


                                              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start, children: [


                                                  Text(fileList[index].originalFileName.toString().capitalizeFirst ?? "",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: context.heading.defaultSize,
                                                  ),


                                                  Text("${fileList[index].filSize}", style: context.body.defaultSize
                                                  ),


                                                ],),


                                              )],

                                            ),
                                          )
                                      )
                                  ),
                                );
                              }
                          ),
                        ),
                      ) : const SizedBox(),
                      AnimatedContainer(
                        padding: const EdgeInsets.only(top: Dimensions.padding6),
                        curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 500),
                        height: conversationController.onImageOrFileTimeShowID == widget.conversationData.id ? 25.0 : 0.0,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: conversationController.onMessageTimeShowID == widget.conversationData.id ?
                            Dimensions.padding6 : 0.0,
                          ),
                          child: Text(conversationController.getOnPressChatTime(widget.conversationData) ?? "", style: context.subHeading.small,),
                        ),
                      ),

                    ]) :const SizedBox.shrink(),
                  ]),)
                ]),

              ]),
            ),


          ]);
        }
    );
  }
}



