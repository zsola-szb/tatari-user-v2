import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/address/widget/address_details_section.dart';
import 'package:tatarigigs_user/feature/address/widget/location_picker_field.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final AddressModel? address;
  const AddAddressScreen({super.key, required this.fromCheckout, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _countryNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();
  final FocusNode _streetNode = FocusNode();

  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.find<LocationController>().resetAddress();
    if (widget.address != null) {
      setControllerData();
    } else {
      Get.find<LocationController>().updateAddressLabel(
        addressLabelString: 'home'.tr,
      );
      Get.find<LocationController>().countryDialCode = CountryCode.fromCountryCode(
        Get.find<SplashController>().configModel.content?.countryCode ?? "BD",
      ).dialCode!;
      _countryController.text = '';
    }
  }

  Future<void> setControllerData() async {
    _cityController.text = widget.address?.city ?? '';
    _countryController.text = widget.address?.country ?? '';
    _streetController.text = widget.address?.street ?? "";
    _zipController.text = widget.address?.zipCode ?? '';
    _houseController.text = widget.address?.house ?? '';
    _floorController.text = widget.address?.floor ?? '';

    Get.find<LocationController>().updateAddressLabel(
      addressLabelString: widget.address?.addressLabel ?? "",
    );
    Get.find<LocationController>().setPlaceMark(addressModel: widget.address);
    Get.find<LocationController>().buttonDisabledOption = false;

    Get.find<LocationController>().setUpdateAddress(widget.address!);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: widget.address == null
              ? 'add_new_address'.tr
              : 'update_address'.tr,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Form(
                    key: addressFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AddressHeaderWidget(),

                        const AddressLabelWidget(),
                        const SizedBox(height: Dimensions.padding16),

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radius16)
                          ),
                          padding: EdgeInsets.all(Dimensions.padding16),
                          child: Column(children: [
                            const LocationPickerField(),
                            const SizedBox(height: Dimensions.padding16),

                            AddressDetailsSection(
                              houseController: _houseController,
                              floorController: _floorController,
                              cityController: _cityController,
                              countryController: _countryController,
                              zipController: _zipController,
                              streetController: _streetController,
                              houseNode: _houseNode,
                              floorNode: _floorNode,
                              cityNode: _cityNode,
                              countryNode: _countryNode,
                              zipNode: _zipNode,
                              streetNode: _streetNode,
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              _AddAddressBottomBar(
                isUpdate: widget.address != null,
                onCancel: () => Get.back(),
                onSave: () => _saveAddress(Get.find<LocationController>()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddress(LocationController locationController) {
    if ((locationController.address.address ?? '').isEmpty) {
      customSnackBar('enter_your_address'.tr, type: ToasterMessageType.info);
      return;
    }

    final isValid = addressFormKey.currentState!.validate();

    if (isValid) {
      addressFormKey.currentState!.save();

      AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        addressType: locationController.selectedAddressType.name,
        addressLabel: locationController.selectedAddressLabel.name.toLowerCase(),
        address: locationController.address.address ?? '',
        city: _cityController.text,
        zipCode: _zipController.value.text,
        country: _countryController.text,
        house: _houseController.text,
        floor: _floorController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        street: _streetController.text,
      );
      if (widget.address == null) {
        locationController.addAddress(addressModel, true);
      } else {
        if ((widget.address!.id != null &&
            widget.address!.id != "null" &&
            Get.find<AuthController>().isLoggedIn())) {
          locationController.updateAddress(addressModel, widget.address!.id!).then((response) {
            if (response.isSuccess!) {
              if (widget.fromCheckout) {
                locationController.updateSelectedAddress(addressModel);
              }
              Get.back();
              customSnackBar(
                response.message!.tr,
                type: ToasterMessageType.success,
                showDefaultSnackBar: false,
              );
            } else {
              customSnackBar(
                response.message!.tr,
                showDefaultSnackBar: false,
              );
            }
          });
        } else {
          locationController.updateSelectedAddress(addressModel);
          Get.back();
        }
      }
    }
  }
}

class _AddAddressBottomBar extends StatelessWidget {
  final bool isUpdate;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _AddAddressBottomBar({
    required this.isUpdate,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Container(
          padding: EdgeInsets.only(
            left: Dimensions.padding16,
            right: Dimensions.padding16,
            top: Dimensions.padding16,
            bottom: MediaQuery.of(context).padding.bottom + Dimensions.padding16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'cancel'.tr,
                  backgroundColor: context.customThemeColors.secondaryBackGroundColor,
                  textColor: context.customThemeColors.textColor,
                  width: double.infinity,
                  radius: Dimensions.radius8,
                  onPressed: onCancel,
                ),
              ),
              const SizedBox(width: Dimensions.padding16),
              Expanded(
                child: CustomButton(
                  buttonText: isUpdate
                      ? 'update_address'.tr
                      : 'save_location'.tr,
                  width: double.infinity,
                  radius: Dimensions.radius8,
                  isLoading: locationController.isLoading,
                  onPressed:
                      (locationController.buttonDisabled || locationController.loading)
                      ? null
                      : onSave,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
