import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class FavoriteTabBarView extends StatelessWidget {
  final TabController? tabController;
  final int serviceCount;
  final int providerCount;
  const FavoriteTabBarView({super.key, this.tabController, this.serviceCount = 0, this.providerCount = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: TabBar(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2.5,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).hintColor,
        labelStyle: context.heading.small,
        unselectedLabelStyle: context.subHeading.small,
        tabs: [
          Tab(text: '${'services'.tr} ($serviceCount)'),
          Tab(text: '${'providers'.tr} ($providerCount)'),
        ],
      ),
    );
  }
}
