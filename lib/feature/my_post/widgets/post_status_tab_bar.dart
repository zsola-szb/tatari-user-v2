import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PostStatusTabBar extends StatelessWidget {
  final TabController? tabController;
  const PostStatusTabBar({super.key, this.tabController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController) {
      return Container(
        width: Get.width,
        color: Theme.of(context).cardColor,
        child: Center(
          child: IntrinsicWidth(
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsetsDirectional.only(end: Dimensions.padding20),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 2.5,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).hintColor,
              labelStyle: context.heading.small,
              unselectedLabelStyle: context.subHeading.small,
              onTap: (index) => createPostController.updatePostTabIndex(index),
              tabs: [
                Tab(text: '${'all'.tr} (${createPostController.postModel?.allCount ?? 0})'),
                Tab(text: '${'pending'.tr} (${createPostController.postModel?.pendingCount ?? 0})'),
                Tab(text: '${'accepted'.tr} (${createPostController.postModel?.acceptedCount ?? 0})'),
                Tab(text: '${'canceled'.tr} (${createPostController.postModel?.canceledCount ?? 0})'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
