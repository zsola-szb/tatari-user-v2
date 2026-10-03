import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SuggestServiceStatusFilterOption {
  final String value;
  final String titleKey;
  const SuggestServiceStatusFilterOption(this.value, this.titleKey);
}

const List<SuggestServiceStatusFilterOption> suggestServiceStatusFilterOptions = [
  SuggestServiceStatusFilterOption('all', 'all'),
  SuggestServiceStatusFilterOption('pending', 'pending'),
  SuggestServiceStatusFilterOption('reviewed', 'reviewed'),
  SuggestServiceStatusFilterOption('denied', 'deny'),
];

class SuggestServiceStatusTabBar extends StatefulWidget {
  const SuggestServiceStatusTabBar({super.key});

  @override
  State<SuggestServiceStatusTabBar> createState() => _SuggestServiceStatusTabBarState();
}

class _SuggestServiceStatusTabBarState extends State<SuggestServiceStatusTabBar> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuggestServiceController>(builder: (suggestServiceController) {
      final int rawIndex = suggestServiceStatusFilterOptions.indexWhere((option) => option.value == suggestServiceController.selectedStatusFilter);
      final int selectedIndex = rawIndex < 0 ? 0 : rawIndex;

      if(_tabController == null){
        _tabController = TabController(length: suggestServiceStatusFilterOptions.length, vsync: this, initialIndex: selectedIndex);
      }else if(_tabController!.index != selectedIndex && !_tabController!.indexIsChanging){
        WidgetsBinding.instance.addPostFrameCallback((_){
          if(mounted && _tabController != null && _tabController!.index != selectedIndex){
            _tabController!.animateTo(selectedIndex);
          }
        });
      }

      return TabBar(
        controller: _tabController,
        isScrollable: false,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).hintColor,
        labelStyle: context.heading.defaultSize,
        unselectedLabelStyle: context.subHeading.defaultSize.overrideWith(fontWeight: FontWeight.w700),
        onTap: (index) => suggestServiceController.updateStatusFilter(suggestServiceStatusFilterOptions[index].value),
        tabs: suggestServiceStatusFilterOptions.map((option) => Tab(text: option.titleKey.tr)).toList(),
      );
    });
  }
}
