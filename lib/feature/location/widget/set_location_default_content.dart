import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationDefaultContent extends StatelessWidget {
  final SetLocationTab selectedTab;
  final ValueChanged<SetLocationTab> onTabChanged;
  final ValueChanged<AddressModel> onFinalize;

  const SetLocationDefaultContent({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onFinalize,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        final List<AddressModel> list = selectedTab == SetLocationTab.recent
            ? locationController.getRecentAddresses()
            : (locationController.addressList ?? []);

        final bool hasCurrentLocationPreview =
            locationController.pickAddress.address?.isNotEmpty ?? false;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              padding: EdgeInsets.all(Dimensions.padding16),
              child: Column(
                children: [
                  SetLocationActionRow(
                    icon: Icons.map_outlined,
                    title: 'set_on_map'.tr,
                    showChevron: true,
                    onTap: () => Get.toNamed(RouteHelper.locationMapPicker),
                  ),

                  SetLocationActionRow(
                    icon: Icons.location_on_outlined,
                    title: 'current_location'.tr,
                    subtitle: hasCurrentLocationPreview
                        ? locationController.pickAddress.address
                        : 'fetching_your_location'.tr,
                    onTap: hasCurrentLocationPreview
                        ? () => onFinalize(locationController.pickAddress)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.padding20),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              padding: EdgeInsets.all(Dimensions.padding16),
              child: Column(
                children: [
                  SetLocationTabToggle(
                    selectedTab: selectedTab,
                    onChanged: onTabChanged,
                  ),
                  const SizedBox(height: Dimensions.padding12),

                  if (list.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.padding24,
                      ),
                      child: Text(
                        selectedTab == SetLocationTab.recent
                            ? 'no_recent_location_found'.tr
                            : 'no_saved_address_found'.tr,
                        textAlign: TextAlign.center,
                        style: context.body.defaultSize,
                      ),
                    )
                  else
                    ...list.map(
                      (address) => SetLocationAddressRow(
                        address: address,
                        onTap: () => onFinalize(address),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.padding20),
          ],
        );
      },
    );
  }
}
