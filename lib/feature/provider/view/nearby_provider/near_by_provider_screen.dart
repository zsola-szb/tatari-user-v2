import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/provider/view/nearby_provider/widget/nearby_provider_filter_widget.dart';
import 'package:tatarigigs_user/feature/provider/view/nearby_provider/widget/nearby_provider_listview.dart';
import 'package:tatarigigs_user/feature/provider/view/nearby_provider/widget/nearby_provider_tabbar_view.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearByProviderScreen extends StatefulWidget {
  final int tabIndex;
  const NearByProviderScreen({super.key, this.tabIndex = 0});

  @override
  State<NearByProviderScreen> createState() => _NearByProviderScreenState();
}

class _NearByProviderScreenState extends State<NearByProviderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.tabIndex;

    _initialPosition = LatLng(
      double.tryParse(Get.find<LocationController>().getUserAddress()?.latitude ?? "23.0000") ?? 23.0000,
      double.tryParse(Get.find<LocationController>().getUserAddress()?.longitude ?? "90.0000") ?? 90.0000,
    );

   _loadDart();
  }
  Future<void> _loadDart() async {
    await Get.find<CategoryController>().getCategoryList( false);
    Get.find<NearbyProviderController>().resetCategoryCheckedList(shouldUpdate: false);
    Get.find<NearbyProviderController>().getProviderList(1, false);

  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        appBar: CustomAppBar(title: "nearby_provider".tr, onBackPressed: (){
          if(Navigator.canPop(context)){
            Get.back();
          }else{
            Get.offAllNamed(RouteHelper.getMainRoute("home"));
          }
        },
          actionWidget: GetBuilder<NearbyProviderController>(builder: (nearbyProviderController){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: 15),
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                    useRootNavigator: true, isScrollControlled: true, backgroundColor: Colors.transparent,
                    context: context, builder: (context) => ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.7),
                      child:  NearByFilterDialog(initialPosition: _initialPosition,)),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(Images.filter,width: 16),
                    if(nearbyProviderController.isFilteredApplied()) Positioned(
                      top: -5,right: -10,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                        child: Container(height: 8,width: 8,
                          padding: const EdgeInsets.all(3),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
        drawer: null,

        endDrawer: null,
        body: FooterBaseView(
          isCenter: false,
          physics: const ClampingScrollPhysics(),
          isScrollView: false,
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [
              NearbyProviderTaBarView(tabController: _tabController, initialPosition: _initialPosition,),

              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics() ,
                  controller: _tabController ,children:  [
                  const NearByProviderListView(),
                  NearByProviderMapView(
                    initialPosition: _initialPosition,
                  ),
                ],),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
