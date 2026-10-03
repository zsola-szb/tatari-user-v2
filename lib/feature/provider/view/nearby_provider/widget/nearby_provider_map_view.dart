import 'package:tatarigigs_user/feature/provider/view/nearby_provider/widget/nearby_provider_listview.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearByProviderMapView extends StatefulWidget {
  final Function(bool)? onValueChanged;
  final LatLng? initialPosition;
  const NearByProviderMapView({super.key, this.onValueChanged, this.initialPosition});

  @override
  State<NearByProviderMapView> createState() => _NearByProviderMapViewState();
}

class _NearByProviderMapViewState extends State<NearByProviderMapView> {




  @override
  void initState() {
    super.initState();

    Get.find<NearbyProviderController>().scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
  }

  void _onPanStart() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(true);
      });
    }
  }
  void _onPanEnd() {
    if(widget.onValueChanged != null){
      setState(() {
        widget.onValueChanged!(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(builder: (nearbyProviderController){
      return  nearbyProviderController.providerList != null && nearbyProviderController.providerList!.isNotEmpty ?
      Row( crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(),
        const SizedBox(),
        Expanded( flex: 2,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: MouseRegion(
                  onEnter: (event) => _onPanStart(),
                  onExit: (event) => _onPanEnd(),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: widget.initialPosition!, zoom: 16),
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    onMapCreated: (GoogleMapController mapController) async  {
                      nearbyProviderController.setMapController(controller: mapController);
                      Future.delayed( const Duration(milliseconds: 100), (){
                        nearbyProviderController.setMarker(mapController, widget.initialPosition!);
                      });
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    markers: nearbyProviderController.markers,
                    style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                    zoomGesturesEnabled: nearbyProviderController.isPopupMenuOpened == false,
                    scrollGesturesEnabled: nearbyProviderController.isPopupMenuOpened == false,
                    rotateGesturesEnabled: nearbyProviderController.isPopupMenuOpened == false,
                    tiltGesturesEnabled: nearbyProviderController.isPopupMenuOpened == false,

                  ),
                ),
              ),

              GetBuilder<LocationController>(builder: (locationController){

                String? pickedAddress;
                if(locationController.pickAddress.address !=null && locationController.pickAddress.address !=""){
                  pickedAddress = locationController.pickAddress.address;
                } else if(nearbyProviderController.selectedProviderIndex !=-1 ){
                  pickedAddress = nearbyProviderController.providerList?[nearbyProviderController.selectedProviderIndex].address;
                } else{
                  pickedAddress = Get.find<LocationController>().getUserAddress()?.address;
                }

                return Positioned(
                  top: Dimensions.padding20, left: Dimensions.padding10, right: Dimensions.padding10,
                  child: LocationSearchDialog(
                    getMapController: () => nearbyProviderController.mapController,
                    pickedLocation: pickedAddress,
                  ),
                );
              }),

              Positioned(
                bottom: 180, right: Dimensions.padding10,
                child: FloatingActionButton(
                  hoverColor: Colors.transparent,
                  mini: true, backgroundColor:Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    nearbyProviderController.getCurrentLocation(mapController : nearbyProviderController.mapController, defaultLatLng: widget.initialPosition);
                  },
                  child: Icon(Icons.my_location,
                      color: Colors.white.withValues(alpha: 0.9)
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 170,
                  child: SingleChildScrollView(
                    controller: nearbyProviderController.scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(children: nearbyProviderController.providerList!.map((provider) => SizedBox(
                      width: ResponsiveHelper.isTab(context)? Get.width/ 2.5 :  Get.width/1.16,
                      child: InkWell(
                        onTap: () async {
                          await nearbyProviderController.scrollController!.scrollToIndex(nearbyProviderController.providerList!.indexOf(provider),
                              preferPosition: AutoScrollPosition.middle);
                          await  nearbyProviderController.scrollController!.highlight(nearbyProviderController.providerList!.indexOf(provider));
                        },
                        child: AutoScrollTag(
                          controller:  nearbyProviderController.scrollController!,
                          key: ValueKey(nearbyProviderController.providerList!.indexOf(provider)),
                          index: nearbyProviderController.providerList!.indexOf(provider),
                          child: NearbyProviderMapItemView(
                            providerData: provider,
                            index: nearbyProviderController.providerList!.indexOf(provider),
                            googleMapController: nearbyProviderController.mapController,
                          ),
                        ),
                      ),
                    )).toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]): nearbyProviderController.providerList == null ? const Center(child: ExploreProviderShimmerWidget()) :
      const EmptyProviderWidget();
    });
  }
}

class ExploreProviderShimmerWidget extends StatelessWidget {

  const ExploreProviderShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: false,
      child: Row(
        children: [

          const SizedBox(),

          const SizedBox(),

          Expanded( flex: 2,
            child: Stack(
              children: [
                ClipRRect(
                  child: Shimmer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Theme.of(context).shadowColor
                      ),
                    ),
                  ),
                ),

                GetBuilder<LocationController>(builder: (locationController){

                  return Positioned(
                    top: Dimensions.padding20, left: Dimensions.padding10, right: Dimensions.padding10,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radius6)),
                      child: Row(children: [
                        Icon(Icons.location_on, size: 25, color: Theme.of(context).shadowColor),
                        const SizedBox(width: Dimensions.padding6),
                        Expanded(
                          child: Text(locationController.pickAddress.address ?? "",
                            style: context.subHeading.large, maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding10),
                        Icon(Icons.search, size: 25, color: Theme.of(context).shadowColor),
                      ]),
                    ),
                  );
                }),

                Positioned(
                  bottom: 180, right: Dimensions.padding10,
                  child: FloatingActionButton(
                    hoverColor: Colors.transparent,
                    mini: true, backgroundColor: !Get.isDarkMode ? Theme.of(context).cardColor.withValues(alpha: 0.7) : Theme.of(context).shadowColor,
                    onPressed: null,
                    child: Icon(Icons.my_location,
                        color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 170,
                    child: SingleChildScrollView(

                      scrollDirection: Axis.horizontal,
                      child: Row(children: [1,2,3,4,5,6,7].map((provider) => SizedBox(
                        width: ResponsiveHelper.isTab(context)? Get.width/ 2.5 :  Get.width/1.16,
                        child: const ExploreProviderMapShimmer(),
                      )).toList()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreProviderMapShimmer extends StatelessWidget {
  const ExploreProviderMapShimmer({super.key,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.padding6),
      child: Shimmer(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radius12),
            border: Border.all(
              color: Theme.of(context).hintColor.withValues(alpha: 0.4), width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(Dimensions.padding16),
          child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [

              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                child: CustomImage(height: 60, width: 60, fit: BoxFit.cover,
                  image: "", placeholder: Images.userPlaceHolder,
                ),
              ),

              const SizedBox(width: Dimensions.padding10),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
                      children: [
                        Container(
                          height: 20, width: 150,
                          decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius6),
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding24,)
                      ],
                    ),
                  ),

                  Padding(padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      RatingBar(rating: 5, size: 15, color: Theme.of(context).shadowColor,),
                      Gaps.horizontalGapOf(5),
                      Container(
                        height: 13, width: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6),
                        ),
                      ),
                    ],
                    ),
                  ),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(children: [
                      Image.asset(Images.iconLocation, height:12, color: Theme.of(context).shadowColor,),
                      const SizedBox(width: Dimensions.padding6,),
                      Container(
                        height: 13, width: 170,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius6),
                        ),
                      ),
                    ],),
                  )
                ],),
              ),


            ],),

            const SizedBox(height: Dimensions.padding10,),

            const Row(children: [
              Expanded(child: ProviderInfoButton(title: "", subtitle: "",)),
              SizedBox(width: Dimensions.padding10,),
              Expanded(child: ProviderInfoButton(title: "", subtitle: "",)),

            ],)

          ]),
        ),
      ),
    );
  }
}

