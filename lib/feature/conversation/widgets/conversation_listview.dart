import 'package:tatarigigs_user/feature/conversation/widgets/empty_conversation_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ConversationListView extends StatelessWidget {
  final List<ChannelData> channelList;
  final int tabIndex;

  const ConversationListView({super.key, required this.channelList, this.tabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (ConversationController conversationController) {
        final bool isSearching =
            conversationController.isActiveSuffixIcon && conversationController.isSearchComplete;

        if (channelList.isEmpty) return EmptyConversationWidget(fromSearch: isSearching);

        return RefreshIndicator(
          onRefresh: () async {
            await conversationController.getChannelList(1, type: tabIndex == 0 ? 'provider' : 'serviceman');
          },
          child: ListView.builder(
            controller: tabIndex == 0
                ? conversationController.channelScrollController1
                : conversationController.channelScrollController2,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding12,
              vertical: Dimensions.padding12,
            ),
            physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: channelList.length,
            itemBuilder: (BuildContext context, int index) => ChannelItem(channelData: channelList[index]),
          ),
        );
      },
    );
  }
}
