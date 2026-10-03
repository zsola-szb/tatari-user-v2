import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_add_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/service_location_row.dart';
import 'package:tatarigigs_user/feature/create_post/widget/select_address_dialog.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/contact_info_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CreatePostLocationCard extends StatelessWidget {
  final PostFullDetails? editingPost;

  const CreatePostLocationCard({super.key, this.editingPost});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return GetBuilder<LocationController>(
      initState: (_) => Get.find<LocationController>().getAddressList(),
      builder: (LocationController locationController) {
        final ServiceLocationType selectedLocationType = locationController.selectedServiceLocationType;

        final AddressModel? address = CheckoutHelper.selectedAddressModel(
          selectedAddress: locationController.selectedAddress,
          pickedAddress: locationController.getUserAddress(),
          selectedLocationType: selectedLocationType,
        );

        if (address == null) {
          return const SizedBox();
        }

        return GetBuilder<UserController>(
          builder: (_) => _CreatePostLocationCardBody(
            address: address,
            isLoggedIn: isLoggedIn,
            isProviderLocation: selectedLocationType == ServiceLocationType.provider,
            locationController: locationController,
            editingPost: editingPost,
          ),
        );
      },
    );
  }
}

class _CreatePostLocationCardBody extends StatelessWidget {
  final AddressModel address;
  final bool isLoggedIn;
  final bool isProviderLocation;
  final LocationController locationController;
  final PostFullDetails? editingPost;

  const _CreatePostLocationCardBody({
    required this.address,
    required this.isLoggedIn,
    required this.isProviderLocation,
    required this.locationController,
    this.editingPost,
  });

  @override
  Widget build(BuildContext context) {
    final String contactName = ContactInfoHelper.resolveName(fallbackName: editingPost?.contactPersonName);
    final String contactNumber = ContactInfoHelper.resolvePhone(fallbackPhone: editingPost?.contactPersonNumber);
    final bool contactMissing = contactName.isEmpty || contactNumber.isEmpty;

    return CheckoutSectionCard(
      padding: const EdgeInsets.all(Dimensions.padding16),
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('getting_service_at'.tr, style: context.heading.defaultSize),
          const SizedBox(height: Dimensions.padding16),

          ServiceLocationRow(
            icon: Icons.location_on_outlined,
            title: (address.addressLabel ?? 'current_location').tr,
            subtitle: address.address ?? '',
            onEdit: isProviderLocation ? null : () => _openAddressSelector(context),
          ),

          const SizedBox(height: Dimensions.padding16),
          if (contactMissing)
            CheckoutAddButton(
              label: 'add_contact_info'.tr,
              onTap: () => _openContactSheet(context, name: contactName, phone: contactNumber),
            )
          else
            ServiceLocationRow(
              icon: Icons.person_outline_rounded,
              title: contactName,
              subtitle: contactNumber,
              forceLtrSubtitle: true,
              onEdit: () => _openContactSheet(context, name: contactName, phone: contactNumber),
            ),
        ],
      ),
    );
  }

  void _openAddressSelector(BuildContext context) {
    if (!isLoggedIn) {
      Get.toNamed(RouteHelper.getEditAddressRoute(address, true));
      return;
    }

    showGeneralDialog(
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Center(child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                  color: Theme.of(context).cardColor
              ),
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding20, vertical: 100),
              child: Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  SelectAddressDialog(addressList: locationController.addressList ?? [], selectedAddressId: address.id,),
                  Positioned(top: -20, right: -20, child: Icon(Icons.cancel, color: Theme.of(context).cardColor)),
                ],
              ),
            )),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: Get.context!,
      pageBuilder: (context, animation1, animation2) => Container(),
    );
  }

  void _openContactSheet(BuildContext context, {required String name, required String phone}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => ContactInfoBottomSheet(
        initialName: name,
        initialPhone: phone,
        onSaved: () => Get.find<LocationController>().update(),
      ),
    );
  }
}
