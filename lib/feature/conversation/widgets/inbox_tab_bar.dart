import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

/// Provider / Serviceman switcher sitting under the inbox app bar.
///
/// While a search is running the tab shows how many of the matches belong to it.
class InboxTabBar extends StatelessWidget {
  final TabController? tabController;

  const InboxTabBar({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (ConversationController conversationController) {
        final bool isSearching =
            conversationController.isActiveSuffixIcon && conversationController.isSearchComplete;

        return Container(
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: tabController,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Theme.of(context).hintColor.withValues(alpha: 0.20),
            dividerHeight: 1,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: context.customThemeColors.secondaryTextColor,
            labelStyle: context.heading.large,
            unselectedLabelStyle: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
            tabs: <Widget>[
              _InboxTab(
                label: 'provider'.tr,
                count: isSearching ? conversationController.searchedProviderChannelList?.length : null,
              ),
              _InboxTab(
                label: 'serviceman'.tr,
                count: isSearching ? conversationController.searchedServicemanChannelList?.length : null,
              ),
            ],
            onTap: (int index) {
              if (isSearching) return;
              conversationController.getChannelList(1, type: index == 0 ? 'provider' : 'serviceman');
            },
          ),
        );
      },
    );
  }
}

class _InboxTab extends StatelessWidget {
  final String label;
  final int? count;

  const _InboxTab({required this.label, this.count});

  @override
  Widget build(BuildContext context) {
    final int matchCount = count ?? 0;

    return SizedBox(
      height: 46,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (matchCount > 0) ...<Widget>[
              const SizedBox(width: Dimensions.padding6),
              Container(
                height: 18,
                constraints: const BoxConstraints(minWidth: 18),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  '$matchCount',
                  style: context.subHeading.small.overrideWith(
                    color: Theme.of(context).cardColor,
                    fontWeight: AppWeight.medium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
