import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProviderChatButton extends StatelessWidget {
  final ProviderData? provider;
  final double buttonSize;
  final double iconSize;
  final bool closesBottomSheet;

  const ProviderChatButton({super.key, required this.provider, this.buttonSize = 36, this.iconSize = 20, this.closesBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (ConversationController conversationController) => InkWell(
        onTap: conversationController.isLoading ? null : () => _startChat(conversationController),
        borderRadius: BorderRadius.circular(buttonSize),
        child: SizedBox(
          height: buttonSize,
          width: buttonSize,
          child: Center(
            child: SvgPicture.asset(Images.chatIcon, height: iconSize, width: iconSize),
          ),
        ),
      ),
    );
  }

  void _startChat(ConversationController conversationController) {
    final String userId = provider?.id ?? '';
    if (userId.isEmpty) {
      customSnackBar('something_went_wrong'.tr);
      return;
    }
    if (provider?.chatEligibility == false) {
      customSnackBar('this_provider_have_not_permission_to_chat'.tr, showDefaultSnackBar: false);
      return;
    }

    conversationController.createChannel(
      userId, '',
      name: provider?.name ?? '',
      image: provider?.logoFullPath ?? '',
      phone: provider?.phone ?? '',
      userType: 'provider',
      fromBookingDetailsPage: closesBottomSheet,
    );
  }
}
