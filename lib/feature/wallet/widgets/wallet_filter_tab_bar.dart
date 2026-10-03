import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletFilterTabBar extends StatefulWidget {
  const WalletFilterTabBar({super.key});

  @override
  State<WalletFilterTabBar> createState() => _WalletFilterTabBarState();
}

class _WalletFilterTabBarState extends State<WalletFilterTabBar> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController){

      final List<WalletFilterBody> filters = walletController.walletFilterList;
      if(filters.isEmpty){
        return const SizedBox();
      }

      int rawIndex = walletController.selectedWalletFilter == null ? 0 :
        filters.indexWhere((filter) => filter.value == walletController.selectedWalletFilter!.value);
      final int selectedIndex = rawIndex < 0 ? 0 : rawIndex;

      if(_tabController == null || _tabController!.length != filters.length){
        _tabController?.dispose();
        _tabController = TabController(length: filters.length, vsync: this, initialIndex: selectedIndex);
      }else if(_tabController!.index != selectedIndex && !_tabController!.indexIsChanging){
        WidgetsBinding.instance.addPostFrameCallback((_){
          if(mounted && _tabController != null && _tabController!.index != selectedIndex){
            _tabController!.animateTo(selectedIndex);
          }
        });
      }

      return TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsetsDirectional.only(end: Dimensions.padding20),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).hintColor,
        labelStyle: context.heading.small,
        unselectedLabelStyle: context.subHeading.small,
        onTap: (index){
          final WalletFilterBody filter = filters[index];
          walletController.updateWalletFilterValue(filter);
          walletController.getWalletTransactionData(1, reload: true, type: filter.value ?? "");
        },
        tabs: filters.map((filter) => Tab(text: filter.title?.tr ?? "")).toList(),
      );
    });
  }
}
