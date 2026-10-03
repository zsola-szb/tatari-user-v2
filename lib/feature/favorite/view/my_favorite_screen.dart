import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class MyFavoriteScreen extends StatefulWidget {
  final String? fromPage;
  const MyFavoriteScreen({super.key, this.fromPage}) ;

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Get.find<MyFavoriteController>().getFavoriteServiceList(1, true);
    Get.find<MyFavoriteController>().getProviderList(1, true);
  }


  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: "my_favorite".tr,
          onBackPressed: () {
            if(widget.fromPage == 'fromNotification'){
              Get.offAllNamed(RouteHelper.getInitialRoute());
            }else{
              if(Navigator.canPop(context)){
                Get.back();
              }else{
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }
            }
          },
        ),
        body: GetBuilder<MyFavoriteController>(builder: (myFavoriteController){
          return SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(
              children: [
                FavoriteTabBarView(
                  tabController: tabController,
                  serviceCount: myFavoriteController.favoriteServiceList?.length ?? 0,
                  providerCount: myFavoriteController.providerList?.length ?? 0,
                ),

                SizedBox(
                  height : Get.height * 0.83,
                  child: TabBarView( controller: tabController, children: const [
                    FavoriteServiceListView(),
                    FavoriteProviderListView(),
                  ]),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
