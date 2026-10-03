import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AddressDetailsSection extends StatelessWidget {
  final TextEditingController houseController;
  final TextEditingController floorController;
  final TextEditingController cityController;
  final TextEditingController countryController;
  final TextEditingController zipController;
  final TextEditingController streetController;

  final FocusNode houseNode;
  final FocusNode floorNode;
  final FocusNode cityNode;
  final FocusNode countryNode;
  final FocusNode zipNode;
  final FocusNode streetNode;

  const AddressDetailsSection({
    super.key,
    required this.houseController,
    required this.floorController,
    required this.cityController,
    required this.countryController,
    required this.zipController,
    required this.streetController,
    required this.houseNode,
    required this.floorNode,
    required this.cityNode,
    required this.countryNode,
    required this.zipNode,
    required this.streetNode,
  });

  void _syncControllerText(TextEditingController controller, String? value) {
    final text = value ?? "";
    if (controller.text == text) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.text != text) {
        controller.text = text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        _syncControllerText(houseController, locationController.address.house);
        _syncControllerText(floorController, locationController.address.floor);
        _syncControllerText(cityController, locationController.address.city);
        _syncControllerText(countryController, locationController.address.country);
        _syncControllerText(zipController, locationController.address.zipCode);
        _syncControllerText(streetController, locationController.address.street);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'house'.tr,
                    hintText: 'enter_house_no'.tr,
                    inputType: TextInputType.streetAddress,
                    focusNode: houseNode,
                    nextFocus: floorNode,
                    controller: houseController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(house: text),
                    isRequired: false,
                  ),
                ),
                const SizedBox(width: Dimensions.padding20),
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'floor'.tr,
                    hintText: 'enter_floor_no'.tr,
                    inputType: TextInputType.streetAddress,
                    focusNode: floorNode,
                    nextFocus: cityNode,
                    controller: floorController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(floor: text),
                    isRequired: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.padding16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'city'.tr,
                    hintText: 'enter_city'.tr,
                    inputType: TextInputType.streetAddress,
                    focusNode: cityNode,
                    nextFocus: countryNode,
                    controller: cityController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(city: text),
                    isRequired: false,
                  ),
                ),
                const SizedBox(width: Dimensions.padding20),
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'country'.tr,
                    hintText: 'enter_country'.tr,
                    inputType: TextInputType.text,
                    focusNode: countryNode,
                    inputAction: TextInputAction.next,
                    nextFocus: zipNode,
                    controller: countryController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(country: text),
                    isRequired: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.padding16),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'zip_code'.tr,
                    hintText: 'enter_zip_code'.tr,
                    inputType: TextInputType.text,
                    focusNode: zipNode,
                    nextFocus: streetNode,
                    controller: zipController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(zipCode: text),
                    isRequired: false,
                  ),
                ),
                const SizedBox(width: Dimensions.padding20),
                Expanded(
                  child: CustomTextField(
                    isShowBorder: true,
                    borderRadius: Dimensions.radius8,
                    title: 'street'.tr,
                    hintText: 'enter_street'.tr,
                    inputType: TextInputType.streetAddress,
                    focusNode: streetNode,
                    inputAction: TextInputAction.done,
                    controller: streetController,
                    onChanged: (text) =>
                        locationController.setPlaceMark(street: text),
                    isRequired: false,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AddressHeaderWidget extends StatelessWidget {
  const AddressHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('address_info'.tr, style: context.heading.large),
        const SizedBox(height: Dimensions.padding6),
        Text('address_info_subtitle'.tr, style: context.body.defaultSize),
        const SizedBox(height: Dimensions.padding20),
      ],
    );
  }
}
