import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/conversation_listview.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/inbox_list_shimmer.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/inbox_support_button.dart';
import 'package:tatarigigs_user/feature/conversation/widgets/inbox_tab_bar.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ConversationListScreen extends StatefulWidget {
  final String? fromNotification;

  const ConversationListScreen({super.key, this.fromNotification});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ConversationController>().clearSearchController(shouldUpdate: false);
    _loadData();
  }

  Future<void> _loadData() async {
    await Get.find<ConversationController>().getChannelList(1, type: 'provider');
    Get.find<ConversationController>().getChannelList(1, type: 'serviceman');
  }

  void _onBackPressed() {
    if (widget.fromNotification == 'fromNotification' || !Navigator.canPop(context)) {
      Get.offNamed(RouteHelper.getMainRoute(RouteHelper.chatInbox));
      return;
    }

    final ConversationController conversationController = Get.find<ConversationController>();
    if (conversationController.isActiveSuffixIcon && conversationController.isSearchComplete) {
      conversationController.clearSearchController();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: Get.isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor : context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'inbox'.tr,
          isBackButtonExist: true,
          onBackPressed: _onBackPressed,
          actionWidget: const InboxSupportButton(),
        ),
        body: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: GetBuilder<ConversationController>(
              builder: (ConversationController conversationController) {
                return Column(
                  children: <Widget>[
                    // Container(
                    //   color: Theme.of(context).cardColor,
                    //   padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding12),
                    //   child: const ConversationSearchWidget(),
                    // ),
                    InboxTabBar(tabController: conversationController.tabController),
                    Expanded(
                      child: conversationController.providerChannelList == null
                          ? const InboxListShimmer()
                          : TabBarView(
                              controller: conversationController.tabController,
                              children: <Widget>[
                                _InboxTabContent(
                                  conversationController: conversationController,
                                  tabIndex: 0,
                                ),
                                _InboxTabContent(
                                  conversationController: conversationController,
                                  tabIndex: 1,
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// One tab's list — search matches while a search is running, otherwise the
/// paginated channel list for that user type.
class _InboxTabContent extends StatelessWidget {
  final ConversationController conversationController;
  final int tabIndex;

  const _InboxTabContent({required this.conversationController, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final bool isSearchRunning =
        conversationController.searchedChannelList == null && !conversationController.isSearchComplete;
    if (isSearchRunning) return const InboxListShimmer();

    final List<ChannelData> searchedChannelList = (tabIndex == 0
            ? conversationController.searchedProviderChannelList
            : conversationController.searchedServicemanChannelList) ??
        <ChannelData>[];
    final List<ChannelData> channelList = (tabIndex == 0
            ? conversationController.providerChannelList
            : conversationController.servicemanChannelList) ??
        <ChannelData>[];

    return ConversationListView(
      channelList: conversationController.isSearchComplete ? searchedChannelList : channelList,
      tabIndex: tabIndex,
    );
  }
}
