import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutAddressPickerSheet extends StatelessWidget {
  final String? selectedAddressId;
  final ValueChanged<AddressModel> onSelected;

  const CheckoutAddressPickerSheet({
    super.key,
    required this.onSelected,
    this.selectedAddressId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<LocationController>(
        initState: (_) => Get.find<LocationController>().getAddressList(),
        builder: (LocationController locationController) {
          final String? activeZoneId = locationController.getUserAddress()?.zoneId;
          final List<AddressModel> addresses = (locationController.addressList ?? <AddressModel>[]).where((AddressModel address) => address.zoneId == activeZoneId).toList();

          return Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('please_select_an_address'.tr, style: context.heading.large),
                const SizedBox(height: Dimensions.padding4),

                Text('where_you_want_to_take_the_service'.tr, style: context.body.small),
                const SizedBox(height: Dimensions.padding16),

                if (addresses.isEmpty)
                  const _EmptyAddressState()
                else
                  ...addresses.map(
                    (AddressModel address) => AddressWidget(
                      address: address,
                      fromAddress: false,
                      fromCheckout: true,
                      isShowOnlyEdit: false,
                      selectedUserAddressId: selectedAddressId,
                      onEditPressed: () {
                        Get.back();
                        Get.toNamed(RouteHelper.getEditAddressRoute(address, true));
                      },
                      onTap: () {
                        locationController.updateSelectedAddress(address);
                        Get.back();
                        onSelected(address);
                      },
                    ),
                  ),

                const SizedBox(height: Dimensions.padding10),
                CustomButton(
                  buttonText: 'add_new_address'.tr,
                  icon: Icons.add_circle_outline_sharp,
                  width: double.infinity,
                  radius: Dimensions.radius12,
                  transparent: true,
                  showBorder: true,
                  textStyle: context.heading.defaultSize.copyWith(color: Colors.white),
                  onPressed: () {
                    Get.back();
                    Get.toNamed(RouteHelper.getAddAddressRoute(true));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyAddressState extends StatelessWidget {
  const _EmptyAddressState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20),
      child: Column(
        children: <Widget>[
          Image.asset(Images.emptyAddress, width: 140),
          const SizedBox(height: Dimensions.padding16),
          Text("you_don't_have_any_address_yet_please_add_address".tr,
            textAlign: TextAlign.center,
            style: context.body.small,
          ),
        ],
      ),
    );
  }
}
