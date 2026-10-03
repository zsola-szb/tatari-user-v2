import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderTaBarView extends StatelessWidget {
  final TabController ? tabController;
  final LatLng? initialPosition;
  const NearbyProviderTaBarView({super.key, this.tabController, this.initialPosition});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return GetBuilder<NearbyProviderController>(builder: (nearbyProviderController){

      int providerCount = nearbyProviderController.providerModel?.content?.total ?? 0;

      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [

        Flexible(
          flex: 1,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(width: Dimensions.padding10),

           if( providerCount > 0) Flexible(
             child: Text("${nearbyProviderController.providerModel?.content?.total ?? ""} ${'providers_found'.tr}",style: context.subHeading.defaultSize),
           ),
          ]),
        ),
        SizedBox(width: Dimensions.padding10),

        Row(children: [

          (nearbyProviderController.providerList !=null && nearbyProviderController.providerList!.isNotEmpty) ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 45,
            margin: const EdgeInsets.only(top: Dimensions.padding16, bottom: Dimensions.padding16),
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Padding for better visuals
              child: Center(
                child: Wrap(
                  children: [
                    TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary, // background color for selected tab
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelColor: Colors.white, // text color for selected tab
                      unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color, // text color for unselected tabs
                      tabs: [
                        SizedBox(height: 34,child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:  width < 400 ? 5 : 10),
                          child: Tab(text: "list_view".tr),
                        )),
                        SizedBox(height: 34,child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width < 400 ? 5 : 10),
                          child: Tab(text: "map_view".tr),
                        )),
                      ],
                      isScrollable: true, // Allows TabBar to be dynamically sized
                      indicatorSize: TabBarIndicatorSize.tab, // Matches indicator to tab size
                    ),
                  ],
                ),
              ),
            ),
          ) : const SizedBox(height: 75,),

          const SizedBox(width: 20,),
        ])
      ]);
    });
  }
}
