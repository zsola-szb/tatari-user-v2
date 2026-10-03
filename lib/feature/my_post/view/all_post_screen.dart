import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/my_post/widgets/my_post_view.dart';
import 'package:tatarigigs_user/feature/my_post/widgets/post_status_tab_bar.dart';
import 'package:get/get.dart';

class AllPostScreen extends StatefulWidget {
  final String? fromNotification;
  const AllPostScreen({super.key, this.fromNotification}) ;

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: 'custom_service_list'.tr, onBackPressed: (){
            if(widget.fromNotification == "fromNotification" || !Navigator.canPop(context)){
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            }else{
              Get.back();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).cardColor,
          onPressed: () => Get.toNamed(RouteHelper.getCreatePostScreen()),
          child: Icon(Icons.add, color: Theme.of(context).primaryColor),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Get.find<CreatePostController>().getMyPostList(1,reload: true);
            },
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: Column(
                    children: [
                      Center(child: PostStatusTabBar(tabController: tabController)),
                      Center(child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: Get.height * 0.8
                        ),
                        child: GetBuilder<CreatePostController>(
                          initState: (_){
                            Get.find<CreatePostController>().getMyPostList(1,reload: true, shouldUpdate: false, tabIndex: 0);
                          },
                          builder: (createPostController){

                            return (!createPostController.isLoading && createPostController.filteredPostTotalCount > 0) ?
                            PaginatedListView(
                              scrollController: scrollController,
                              totalSize: createPostController.postModel?.totalSize,
                              onPaginate: (int offset) async => await createPostController.getMyPostList(offset, reload: false),
                              offset: createPostController.postModel?.offset,
                              itemView: ListView.builder(
                                padding:  const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                                itemBuilder: (context, dateIndex) {
                                  final List<MyPostData> posts = createPostController.postsForDate(dateIndex);
                                  if(posts.isEmpty) return const SizedBox.shrink();

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: Dimensions.padding16),
                                      SuggestServiceDateDivider(label: createPostController.dateGroupLabel(dateIndex)),
                                      ListView.builder(
                                        itemBuilder: (context, index) {
                                          return MyPostView(postData: posts[index]);
                                        },
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: posts.length,
                                      )
                                    ],
                                  );
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: createPostController.dateList.length,
                              ),
                            ) : (createPostController.isLoading) ?
                            GridView.builder(
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: Dimensions.padding20,
                                mainAxisSpacing: Dimensions.padding10,
                                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 2 : 3,
                                mainAxisExtent: ResponsiveHelper.isMobile(context) ? 150 : 160,
                              ),
                              itemCount: 9, shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: Dimensions.padding24,top: Dimensions.padding16*2),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder:(BuildContext context, index) {
                                return  Padding(padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.padding16,
                                    vertical: 0
                                ),
                                  child: const SubCategoryShimmer(isEnabled: true, hasDivider: false),
                                );
                              },
                            ) :
                            Center(child: NoDataScreen(text: 'no_post_found'.tr.tr,type: NoDataType.bookings,));
                          }),
                      )),
                    ],
                  ),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
