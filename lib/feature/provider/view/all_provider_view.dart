import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/provider/widgets/provider_filter_view.dart';
import 'package:tatarigigs_user/feature/provider/widgets/provider_item_view.dart';
import 'package:get/get.dart';

class AllProviderView extends StatefulWidget {
  const AllProviderView({super.key}) ;

  @override
  State<AllProviderView> createState() => _AllProviderViewState();
}


class _AllProviderViewState extends State<AllProviderView> {

  @override
  void initState() {
    super.initState();
    _loadDart();
  }
  Future<void> _loadDart() async {
    await Get.find<CategoryController>().getCategoryList( false);
    Get.find<ProviderBookingController>().resetProviderFilterData();
    Get.find<ProviderBookingController>().getProviderList(1, true);
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return CustomPopWidget(
      child: Scaffold(
        drawer: null,

        endDrawer: null,
        appBar: CustomAppBar(title: 'provider_list'.tr,
          actionWidget: InkWell(onTap: (){
            showModalBottomSheet(
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context, builder: (context) => const ProviderFilterView());
            },
      
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: Image.asset(Images.filter,width: 20,color: Colors.white,),
            ),
          ),
        ),
      
        body: GetBuilder<ProviderBookingController>(builder: (providerBookingController){
          return FooterBaseView(
            isScrollView:true,
            scrollController: scrollController,
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  providerBookingController.providerModel!=null && providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty?
                  PaginatedListView(
                    scrollController: scrollController,
                    totalSize: providerBookingController.providerModel!.content!.total!,
                    limit: providerBookingController.providerModel?.content?.perPage,
                    onPaginate: (int offset) async => await providerBookingController.getProviderList(
                      offset, false,
                    ),
                    offset: providerBookingController.providerModel?.content?.currentPage,
                    itemView: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isTab(context)?2:1,
                      mainAxisExtent: ResponsiveHelper.isTab(context)?170:160
                    ),
                      itemCount: providerBookingController.providerList!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return ProviderItemView(fromHomePage: false,providerData: providerBookingController.providerList![index], index: index,);
                      },),
                  ) : (providerBookingController.providerModel == null || providerBookingController.providerList == null) ?
                  SizedBox( height : Get.height * 0.9 , child: const ProviderListViewShimmer()):
                  SizedBox(height: Get.height*0.9,
                      child: Center(
                          child: Text('no_provider_found'.tr,style: context.body.defaultSize,)),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}


class ProviderListViewShimmer extends StatelessWidget {
  const ProviderListViewShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: ResponsiveHelper.isTab(context) ? 170 : 160,
        crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
      ),
      itemBuilder: (context, index){
        return Shimmer(
          duration: const Duration(seconds: 1),
          interval: const Duration(seconds: 1),
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: Dimensions.padding8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Image.asset(Images.userPlaceHolder, height: 60, width: 60,),
                  const SizedBox(width: Dimensions.padding16,),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.padding10,),
                    Container(height: 15, width: 100, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).shadowColor,
                    ),),
                    const SizedBox(height: 5),
                    Container(height: 10, width: 130,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).shadowColor,
                    )),
                  ]),

                  const Expanded(child: SizedBox()),
                  Icon(Icons.favorite, size: 20, color: Theme.of(context).shadowColor,)
                ]),

                const SizedBox(height: 10),
                Container(height: 12,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                )),

                const SizedBox(height: 5),
                Container(height: 12,  width: 200,decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                )),
              ],
            ),
          ),
        );
      },
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shrinkWrap: true,
    );
  }
}

