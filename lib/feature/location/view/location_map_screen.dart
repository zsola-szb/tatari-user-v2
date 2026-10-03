import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/common/widgets/map_view_widget.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  final SearchController _searchController = SearchController();
  late final LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    final locationController = Get.find<LocationController>();
    locationController.setPickData();

    final pick = locationController.pickPosition;
    _initialPosition = (pick.latitude != 0 || pick.longitude != 0)
        ? LatLng(pick.latitude, pick.longitude)
        : _defaultLatLng(locationController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  LatLng _defaultLatLng(LocationController locationController) {
    return LatLng(
      double.tryParse(locationController.getUserAddress()?.latitude ?? '') ??
          (Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.0000),
      double.tryParse(locationController.getUserAddress()?.longitude ?? '') ??
          (Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.0000),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMoveStarted() {
    Get.find<LocationController>().updateCameraMovingStatus(true);
    Get.find<LocationController>().disableButton();
  }

  void _onCameraMove(CameraPosition position) {
    _cameraPosition = position;
  }

  void _onCameraIdle() {
    Get.find<LocationController>().updateCameraMovingStatus(false);
    try {
      Get.find<LocationController>().updatePosition(_cameraPosition!, false);
    } catch (e) {
      if (kDebugMode) {
        print('');
      }
    }
  }

  void _onMyLocationTap() {
    _checkPermission(() {
      Get.find<LocationController>().getCurrentLocation(
        false,
        deviceCurrentLocation: true,
        mapController: _mapController,
      );
    });
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }

  void _onClearSearch() {
    _searchController.clear();
    final target = _defaultLatLng(Get.find<LocationController>());
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  void _onConfirm() {
    final locationController = Get.find<LocationController>();
    if (locationController.pickPosition.latitude != 0 &&
        (locationController.pickAddress.address?.isNotEmpty ?? false)) {
      locationController.setAddAddressData();
      locationController.saveRecentAddress(locationController.address);
      Get.back();
      Get.back();
    } else {
      customSnackBar('pick_an_address'.tr, type: ToasterMessageType.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              target: _initialPosition,
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
                  onTap: _onMyLocationTap,
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
            bottom:
                Dimensions.padding20 + MediaQuery.of(context).padding.bottom,
            child: GetBuilder<LocationController>(
              builder: (locationController) => CustomButton(
                buttonText: 'pick_location'.tr,
                radius: Dimensions.radius8,
                height: 52,
                onPressed:
                    (locationController.buttonDisabled ||
                        locationController.loading)
                    ? null
                    : _onConfirm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationMapAddressBar extends StatelessWidget {
  final SearchController searchController;
  final GoogleMapController? Function() getMapController;
  final VoidCallback onClear;

  const LocationMapAddressBar({
    super.key,
    required this.searchController,
    required this.getMapController,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        final hasAddress = locationController.pickAddress.address?.isNotEmpty ?? false;
        return LocationSearchDialog(
          searchController: searchController,
          getMapController: getMapController,
          pickedLocation: hasAddress ? locationController.pickAddress.address : null,
          child: Container(
            height: Dimensions.searchbarSize,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              border: Border.all(color: context.customThemeColors.secondaryBackGroundColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: Dimensions.fontSizeLarge,
                  color: context.customThemeColors.textColor,
                ),
                const SizedBox(width: Dimensions.padding8),
                Expanded(
                  child: Text(
                    hasAddress
                        ? locationController.pickAddress.address!
                        : 'search_location'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.body.defaultSize.overrideWith(
                      color: context.customThemeColors.textColor,
                    ),
                  ),
                ),
                CustomInkWell(
                  radius: Dimensions.radiusFull,
                  onTap: onClear,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.padding4),
                    child: Icon(
                      Icons.close,
                      size: Dimensions.fontSizeDefault,
                      color: context.customThemeColors.secondaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LocationMapAppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const LocationMapAppBarIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Container(
        height: Dimensions.searchbarSize,
        width: Dimensions.searchbarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Icon(icon, size: 20, color: context.customThemeColors.textColor),
      ),
    );
  }
}

class LocationMapCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const LocationMapCircleButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomInkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: context.customThemeColors.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class LocationMapZoomControls extends StatelessWidget {
  final GoogleMapController? Function() getMapController;

  const LocationMapZoomControls({super.key, required this.getMapController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomInkWell(
            radius: Dimensions.radius12,
            onTap: () =>
                getMapController()?.animateCamera(CameraUpdate.zoomIn()),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.padding10,
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: context.customThemeColors.textColor,
              ),
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding8,
            ),
            color: context.customThemeColors.secondaryBackGroundColor,
          ),
          CustomInkWell(
            radius: Dimensions.radius12,
            onTap: () =>
                getMapController()?.animateCamera(CameraUpdate.zoomOut()),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.padding10,
              ),
              child: Icon(
                Icons.remove,
                size: 20,
                color: context.customThemeColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
