import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<PredictionModel> _predictions = [];
  bool _isSearching = false;
  SetLocationTab _selectedTab = SetLocationTab.recent;

  @override
  void initState() {
    super.initState();
    final locationController = Get.find<LocationController>();
    if (Get.find<AuthController>().isLoggedIn()) {
      locationController.getAddressList();
    }
    _checkPermission(
      () => locationController.getCurrentLocation(
        false,
        deviceCurrentLocation: true,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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

  Future<void> _onSearchChanged(String query) async {
    setState(() => _isSearching = query.isNotEmpty);
    if (query.isEmpty) {
      setState(() => _predictions = []);
      return;
    }
    final predictions = await Get.find<LocationController>().searchLocation(
      context,
      query,
    );
    if (!mounted) {
      return;
    }
    setState(() => _predictions = predictions);
  }

  Future<void> _finalizeAddress(AddressModel address) async {
    final locationController = Get.find<LocationController>();
    Get.dialog(const CustomLoader(), barrierDismissible: false);
    await locationController.getZone(
      address.latitude ?? '0',
      address.longitude ?? '0',
      true,
    );
    locationController.applyPickedAddress(address);
    await locationController.saveRecentAddress(address);
    Get.back();
    Get.back();
  }

  Future<void> _onSelectPrediction(PredictionModel prediction) async {
    final address = await Get.find<LocationController>().setLocation(
      prediction.placeId ?? prediction.placePrediction?.placeId ?? '',
      prediction.description ?? prediction.placePrediction?.text?.text ?? '',
      null,
    );
    _finalizeAddress(address);
  }

  void _onCurrentLocationTap() {
    final pickAddress = Get.find<LocationController>().pickAddress;
    if (pickAddress.address?.isNotEmpty ?? false) {
      _finalizeAddress(pickAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'set_location'.tr),
      backgroundColor: context.customThemeColors.backGroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.padding16),
            child: SetLocationSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ),
          Expanded(
            child: _isSearching
                ? SetLocationSearchResults(
                    query: _searchController.text,
                    predictions: _predictions,
                    onPredictionTap: _onSelectPrediction,
                    onAddressTap: _finalizeAddress,
                    onSetOnMap: () => Get.toNamed(RouteHelper.locationMapPicker),
                    onCurrentLocationTap: _onCurrentLocationTap,
                  )
                : SetLocationDefaultContent(
                    selectedTab: _selectedTab,
                    onTabChanged: (tab) => setState(() => _selectedTab = tab),
                    onFinalize: _finalizeAddress,
                  ),
          ),
        ],
      ),
    );
  }
}
