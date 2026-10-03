import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/guest_contact_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/checkout_address_picker_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/checkout_provider_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/location_type_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/location_type_pill.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/service_location_row.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class GetServiceAtSection extends StatelessWidget {
  const GetServiceAtSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return GetBuilder<LocationController>(
          initState: (_) => Get.find<LocationController>().getAddressList(),
          builder: (LocationController locationController) {
            final bool isAtProvider =
                controller.locationType == ServiceLocationType.provider;
            final bool canChoose = controller.allowChooseServiceLocation;

            return CheckoutSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('get_service_at'.tr,
                        style: context.heading.defaultSize,
                      ),
                      const Spacer(),
                      LocationTypePill(
                        label: isAtProvider ? 'provider_location'.tr : 'my_location'.tr,
                        onTap: canChoose ? () => _openTypeSheet(context, controller) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  if (isAtProvider)
                    _ProviderLocationBlock(controller: controller)
                  else
                    _CustomerLocationBlock(controller: controller),

                  const SizedBox(height: Dimensions.padding10),
                  const GuestContactSection(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openTypeSheet(BuildContext context, CheckoutController controller) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => LocationTypeBottomSheet(
        current: controller.locationType,
        onSelected: (ServiceLocationType type) {
          controller.setLocationType(type);
          controller.syncAddressFromLocationController();
        },
      ),
    );
  }
}

class _CustomerLocationBlock extends StatelessWidget {
  final CheckoutController controller;

  const _CustomerLocationBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    final AddressModel? address = controller.resolvedAddress;
    final String? line = address?.address;
    final bool hasAddress = line != null && line.isNotEmpty && line != 'null';

    return ServiceLocationRow(
      icon: Icons.location_on_outlined,
      title: 'service_location'.tr,
      subtitle: hasAddress ? line : 'please_set_your_service_location'.tr,
      onEdit: () => _openAddressPicker(context),
    );
  }

  void _openAddressPicker(BuildContext context) {
    final bool isLoggedIn = controller.isLoggedIn;
    final AddressModel? address = controller.resolvedAddress;

    if (!isLoggedIn) {
      Get.toNamed(RouteHelper.getEditAddressRoute(address ?? AddressModel(), true));
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => CheckoutAddressPickerSheet(
        selectedAddressId: address?.id,
        onSelected: (AddressModel _) => controller.syncAddressFromLocationController(),
      ),
    );
  }
}

class _ProviderLocationBlock extends StatelessWidget {
  final CheckoutController controller;

  const _ProviderLocationBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    final ProviderData? provider = controller.bookingProvider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (provider != null)
          CheckoutProviderCard(
            imageUrl: provider.logoFullPath,
            name: provider.name ?? '',
            phone: provider.phone ?? '',
            address: provider.address ?? '',
          ),
        const SizedBox(height: Dimensions.padding10),
        CheckoutInfoBox(
          tone: CheckoutInfoTone.accent,
          child: Text('you_have_to_go_to_provider_location_in_order_to_receive_this_service'.tr,
            style: context.subHeading.small,
          ),
        ),
      ],
    );
  }
}
