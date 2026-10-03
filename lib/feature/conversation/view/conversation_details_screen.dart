import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/conversation_bubble_widget.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/conversation_details_appbar.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/conversation_details_shimmer.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/conversation_send_message_widget.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/empty_conversation_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';



class ConversationDetailsScreen extends StatefulWidget {
  final String? channelID;
  final String? name;
  final String? image;
  final String? phone;
  final String bookingID;
  final String userType;
  final String formNotification;

  const ConversationDetailsScreen({super.key,
    this.name,
    this.image,
    this.channelID,
     this.phone,
    this.bookingID = "",
    this.formNotification = "",
    this.userType =""});
  @override
  State<ConversationDetailsScreen> createState() => _ConversationDetailsScreenState();
}

class _ConversationDetailsScreenState extends State<ConversationDetailsScreen> {

  String phone ='';
  String customerID = Get.find<UserController>().userInfoModel?.id?? '';

  @override
  void initState() {
    super.initState();
    Get.find<ConversationController>().cleanOldData();
    Get.find<ConversationController>().setChannelId(widget.channelID ?? "");
    Get.find<ConversationController>().getConversation(widget.channelID ??"", 1,isInitial:true);

    if(Get.find<SplashController>().configModel.content?.phoneNumberVisibility==0 && widget.userType.contains("provider-admin")){
      phone = "";
    }else{
      phone = "+${widget.phone}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      isNavigationOnOnPop: true,
      onPopInvoked: () async {
        await Future.delayed(Duration(microseconds: 100));
        Get.offAllNamed(RouteHelper.getInboxScreenRoute(fromNotification: widget.formNotification));
      },
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 55),
          child: ConversationDetailsAppBar(
            fromNotification: widget.formNotification,
            name: widget.name, phone: phone, image: widget.image,
          ),
        ),


        body: widget.channelID == null ?  const EmptyConversationWidget(fromSearch: false,) : GetBuilder<ConversationController>(builder: (conversationController) {
          if(conversationController.conversationList != null){
            List<ConversationData> conversationList = conversationController.conversationList!;

            return Column(
              children: [
                const SizedBox(height: Dimensions.padding10),

                Expanded(child:conversationList.isNotEmpty ? ListView.builder(
                  controller: conversationController.messageScrollController,
                  itemCount:  conversationList.length,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
                  reverse: true,
                  itemBuilder: (context,index){
                    bool isRightMessage = conversationList[index].userId == customerID;
                    return ConversationBubbleWidget(
                      image: widget.image,
                      name: widget.name,
                      conversationData: conversationList[index],
                      isRightMessage: isRightMessage,
                      previousConversationData: index == 0  ?
                      null : conversationController.conversationList?.elementAt(index-1),
                      nextConversationData: index == (conversationList.length - 1)  ? null : conversationList.elementAt(index+1),
                    );
                  },): SizedBox(child: Center(child: Text('no_conversation_yet'.tr)),),
                ),

                ConversationSendMessageWidget(channelId: widget.channelID ??""),

              ],
            );
            }else{
            return SizedBox(
              height: null,
              child: const ConversationDetailsShimmer(),
            );
          }},
        ),
      ),
    );
  }
}
