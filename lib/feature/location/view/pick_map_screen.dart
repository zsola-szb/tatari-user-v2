import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/common/widgets/map_view_widget.dart';



class PickMapScreen extends StatefulWidget {
  final bool? fromSignUp;
  final bool? fromAddAddress;
  final bool? canRoute;
  final String? route;
  final bool formCheckout;
  final GoogleMapController? googleMapController;
  final ZoneModel? zone;
  final AddressModel? previousAddress;
  const PickMapScreen({super.key,
    required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController,
    required this.formCheckout, required this.zone,
    this.previousAddress
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  LatLng? _initialPosition;
  LatLng? _centerLatLng;
  final SearchController _searchController = SearchController();

  Set<Polygon> _polygone = {};
  List<LatLng> zoneLatLongList = [];

  String? pageTitle;
  String? pageSubTitle;

  @override
  void initState() {
    super.initState();
    if(widget.fromAddAddress!) {
      Get.find<LocationController>().setPickData();

    }

    if(widget.zone !=null){
      _centerLatLng = Get.find<ServiceAreaController>().computeCentroid(coordinates: widget.zone!.formattedCoordinates!);
      _initialPosition = LatLng(_centerLatLng!.latitude , _centerLatLng!.longitude);

      widget.zone?.formattedCoordinates?.forEach((element) {
        zoneLatLongList.add(LatLng(element.latitude!, element.longitude!));
      });

      List<Polygon> polygonList = [];

      polygonList.add(
        Polygon(
          polygonId: const PolygonId('1'),
          points: zoneLatLongList,
          strokeWidth: 2,
          strokeColor: Get.theme.colorScheme.primary,
          fillColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
        ),
      );

      _polygone = HashSet<Polygon>.of(polygonList);

    }else{
      _initialPosition = LatLng(
        Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.00000,
        Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.00000,
      );
    }

    if(widget.route == "search_service"){
      pageTitle = "search_services_near_you".tr;
      pageSubTitle = "${'you_must_select_location_first_to_view'.tr} ${'services'.tr.toLowerCase()}";
    } else if(widget.route == RouteHelper.allServiceScreen){
      pageTitle = "services_near_you".tr;
      pageSubTitle = "${'you_must_select_location_first_to_view'.tr} ${'services'.tr.toLowerCase()}";
    }
    else if(widget.route == RouteHelper.home){
      pageTitle = "home".tr;
      pageSubTitle = "${'you_must_select_location_first_to_view'.tr} ${'home_content'.tr.toLowerCase()}";
    }else if(widget.route == RouteHelper.categories || widget.route ==  RouteHelper.cart || widget.route ==  RouteHelper.offers || widget.route ==  RouteHelper.notification || widget.route == RouteHelper.voucherScreen){
      pageTitle = widget.route?.replaceAll("/", "").tr;
      pageSubTitle = "${'you_must_select_location_first_to_view'.tr} ${widget.route?.replaceAll("/", "").tr.toLowerCase()}";
    }


  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final LatLng cameraTarget = widget.fromAddAddress!
        ? LatLng(locationController.position.latitude, locationController.position.longitude)
        : _initialPosition!;

    return CustomPopWidget(
      isExit: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.customThemeColors.backGroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: Dimensions.padding10,
          leadingWidth: 56,
          leading: Center(
            child: LocationMapAppBarIconButton(
              icon: Icons.arrow_back,
              onTap: () => Get.back(),
            ),
          ),
          title: LocationMapAddressBar(
            searchController: _searchController,
            getMapController: () => _mapController,
            onClear: _onClearSearch,
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: cameraTarget,
                zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              onMapCreated: _onMapCreated,
              onCameraMoveStarted: _onCameraMoveStarted,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              style: Get.isDarkMode
                  ? Get.find<ThemeController>().darkMap
                  : Get.find<ThemeController>().lightMap,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              polygons: _polygone,
            ),

            if(pageTitle != null)
              Positioned(
                top: Dimensions.padding16,
                left: Dimensions.padding16,
                right: Dimensions.padding16,
                child: _PageHeaderCard(
                  title: pageTitle,
                  subtitle: pageSubTitle,
                ),
              ),

            GetBuilder<LocationController>(
              builder: (locationController) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 100 * 0.65,
                  ),
                  child: locationController.isCameraMoving
                      ? const AnimatedMapIconExtended()
                      : const AnimatedMapIconMinimised(),
                ),
              ),
            ),

            Positioned(
              bottom: 96,
              right: Dimensions.padding16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocationMapCircleButton(
                    icon: Icons.my_location,
                    onTap: _onLocationTap,
                  ),
                  const SizedBox(height: Dimensions.padding10),
                  LocationMapZoomControls(
                    getMapController: () => _mapController,
                  ),
                ],
              ),
            ),

            Positioned(
              left: Dimensions.padding16,
              right: Dimensions.padding16,
              bottom: Dimensions.padding20 + MediaQuery.of(context).padding.bottom,
              child: GetBuilder<LocationController>(
                builder: (locationController) => CustomButton(
                  buttonText: locationController.inZone
                      ? widget.fromAddAddress!
                          ? 'pick_address'.tr
                          : 'pick_location'.tr
                      : 'service_not_available_in_this_area'.tr,
                  radius: Dimensions.radius8,
                  height: 52,
                  onPressed: (locationController.buttonDisabled || locationController.loading)
                      ? null
                      : _onPickLocationTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onClearSearch() {
    _searchController.clear();
    final locationController = Get.find<LocationController>();
    final LatLng target = widget.fromAddAddress!
        ? LatLng(locationController.position.latitude, locationController.position.longitude)
        : _initialPosition!;
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  // Callback methods for _MapViewWidget
  void _onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;
    if (!widget.fromAddAddress!) {
      if (widget.zone != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          mapController.animateCamera(CameraUpdate.newLatLngBounds(
            MapHelper.boundsFromLatLngList(zoneLatLongList),
            100.5,
          ));
        });
      } else {
        Get.find<LocationController>().getCurrentLocation(
          false,
          mapController: mapController,
          isFromCheckout: widget.formCheckout,
        );
      }
    }
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition;
  }

  void _onCameraMoveStarted() {
    Get.find<LocationController>().updateCameraMovingStatus(true);
    Get.find<LocationController>().disableButton();
  }

  void _onCameraIdle() {
    Get.find<LocationController>().updateCameraMovingStatus(false);
    try {
      Get.find<LocationController>().updatePosition(
        _cameraPosition!,
        false,
        formCheckout: widget.formCheckout,
      );
    } catch (e) {
      if (kDebugMode) {
        print('');
      }
    }
  }

  void _onLocationTap() {
    _checkPermission(() {
      Get.find<LocationController>().getCurrentLocation(
        false,
        deviceCurrentLocation: true,
        isFromCheckout: widget.formCheckout,
        mapController: _mapController,
      );
    });
  }

  void _onPickLocationTap() {
    final locationController = Get.find<LocationController>();
    if (locationController.pickPosition.latitude != 0 &&
        locationController.pickAddress.address!.isNotEmpty) {
      if (widget.fromAddAddress!) {
        if (widget.googleMapController != null) {
          widget.googleMapController!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  locationController.pickPosition.latitude,
                  locationController.pickPosition.longitude,
                ),
                zoom: 16,
              ),
            ),
          );
          locationController.setAddAddressData();
        }
        Get.back();
      } else {
        AddressModel address = AddressModel(
          latitude: locationController.pickPosition.latitude.toString(),
          longitude: locationController.pickPosition.longitude.toString(),
          addressType: 'others',
          address: locationController.pickAddress.address ?? "",
          city: locationController.pickAddress.city ?? "",
          country: locationController.pickAddress.country ?? "",
          house: locationController.pickAddress.house ?? "",
          street: locationController.pickAddress.street ?? "",
          zipCode: locationController.pickAddress.zipCode ?? "",
          addressLabel: AddressLabel.home.name,
        );

        if (kDebugMode) {
          print("Inside Here ===> Route === > ${widget.route}");
        }
        locationController.saveAddressAndNavigate(
          address,
          widget.fromSignUp!,
          widget.route ?? RouteHelper.getMainRoute('home'),
          widget.canRoute!,
          true,
        );
      }
    } else {
      customSnackBar('pick_an_address'.tr, type: ToasterMessageType.info);
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}


/// Overlay card shown above the map with contextual title and subtitle
class _PageHeaderCard extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _PageHeaderCard({
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? "",
            style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
          ),
          const SizedBox(height: Dimensions.padding4),
          Text(
            subtitle ?? "",
            style: context.body.defaultSize,
          ),
        ],
      ),
    );
  }
}
