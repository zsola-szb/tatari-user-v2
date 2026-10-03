import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class InboxSupportButton extends StatelessWidget {
  const InboxSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (ConversationController conversationController) {
        final ChannelData? adminChannel = conversationController.adminConversationModel;
        final List<ConversationUserModel>? channelUsers = adminChannel?.channelUsers;
        if (adminChannel == null || channelUsers == null || channelUsers.length < 2) {
          return const SizedBox();
        }

        final ConversationUserModel customer =
            channelUsers.first.user?.userType == 'customer' ? channelUsers.first : channelUsers[1];
        final bool isUnread = (customer.isRead ?? 1) == 0;
        final String logo = Get.find<SplashController>().configModel.content?.logoFullPath ?? '';

        return Padding(
          padding: const EdgeInsetsDirectional.only(end: Dimensions.padding16, top: Dimensions.padding8),
          child: CustomInkWell(
            radius: Dimensions.radius12,
            onTap: () {
              conversationController.resetImageFile();
              Get.toNamed(RouteHelper.getChatScreenRoute(adminChannel.id ?? '', 'admin'.tr, logo, '', 'super-admin'));
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(Dimensions.padding8),
                  decoration: BoxDecoration(
                    color: context.customThemeColors.secondaryBackGroundColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                  ),
                  child: CustomImage(
                    image: logo,
                    fit: BoxFit.cover,
                    placeholder: Images.adminPlaceHolder,
                    placeHolderBoxFit: BoxFit.contain,
                  ),
                ),
                if (isUnread)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      height: 18,
                      width: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.error,
                        border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
                      ),
                      child: Text(
                        '1',
                        style: context.body.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.semiBold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
