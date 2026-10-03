import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/common/widgets/staggered_list_animation.dart';
import 'package:tatarigigs_user/common/widgets/custom_highlight_animation_widget.dart';
import 'package:tatarigigs_user/feature/location/widget/pickmap_dialog_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  const AddressSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }

    return GetBuilder<LocationController>(
        builder: (locationController) {
          final bool hasAddress = isLoggedIn && (locationController.addressList?.isNotEmpty ?? false);

          return Container(
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.80,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
              color: Theme.of(context).cardColor,
            ),
            child: BaseBottomSheet(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding24),
                  child: Column(children: [
                    Text(
                      'select_your_address'.tr,
                      textAlign: TextAlign.center,
                      style: context.heading.large,
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Text(
                      hasAddress ? 'select_a_saved_address_or_add_a_new_one_to_continue'.tr : 'choose_your_preferred_address_to_continue'.tr,
                      textAlign: TextAlign.center,
                      style: context.body.small,
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.padding20),

                if(isLoggedIn)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('my_address'.tr, style: context.heading.defaultSize),

                        if(hasAddress)
                          InkWell(
                            onTap: () => Get.toNamed(RouteHelper.getAddAddressRoute(false)),
                            child: Row(children: [
                              Icon(Icons.add_circle_outline, size: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: Dimensions.padding4),
                              Text(
                                'add_new_address'.tr,
                                style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),
                              ),
                            ]),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding12),

                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                      child: hasAddress
                          ? AddressListContent(locationController: locationController)
                          : EmptyAddressState(isLoggedIn: isLoggedIn),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),
                ],

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AddressActionButtons(),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + Dimensions.padding16),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.padding16),
              ],
            )),
          );
        }
      );
  }
}

class AddressListContent extends StatelessWidget {
  final LocationController locationController;
  final Function(AddressModel)? onAddressTap;

  const AddressListContent({
    super.key,
    required this.locationController,
    this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {

    return Skeletonizer(
      enabled: locationController.addressList == null,
      child: StaggeredListAnimationWrapper(
        key: ValueKey(locationController.addressList?.length),
        duration: const Duration(milliseconds: 600),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: locationController.addressList!.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          itemBuilder: (context, index) {
            final address = locationController.addressList![index];
            final isSelected = locationController.getUserAddress()?.id == address.id;
            final isNewlyAdded = locationController.newlyAddedAddressId == address.id;

            return StaggeredListAnimationItem(
              index: index,
              child: AddressListItem(
                address: address,
                isSelected: isSelected,
                isNewlyAdded: isNewlyAdded,
                onTap: () async {
                  if (onAddressTap != null) {
                    onAddressTap!(address);
                  } else {
                    Get.dialog(const CustomLoader(), barrierDismissible: false);
                    await locationController.setAddressIndex(address, fromAddressScreen: false);
                    locationController.saveAddressAndNavigate(address, false, '', false, true);
                    Get.back(); // Close loader
                    Get.back(); // Close bottom sheet
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddressListItem extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final bool isNewlyAdded;
  final VoidCallback onTap;

  const AddressListItem({
    super.key,
    required this.address,
    required this.isSelected,
    required this.isNewlyAdded,
    required this.onTap,
  });

  IconData _getAddressIcon() {
    switch (address.addressLabel?.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.work_outline;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHighlightAnimationWidget(
      shouldAnimate: isNewlyAdded,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getAddressIcon(),
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          size: Dimensions.padding20,
                        ),
                        const SizedBox(width: Dimensions.padding8),

                        Text(
                          (address.addressLabel ?? 'others').tr,
                          style: context.heading.defaultSize,
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.padding4),

                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.padding24),
                      child: Text(
                        address.address ?? '',
                        style: context.body.small,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: Dimensions.padding10),

              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).hintColor.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyAddressState extends StatelessWidget {
  final bool isLoggedIn;

  const EmptyAddressState({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding24, horizontal: Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(
        children: [
          Image.asset(Images.emptyAddress, height: 60),
          const SizedBox(height: Dimensions.padding16),

          Text(
            'opps'.tr,
            textAlign: TextAlign.center,
            style: context.heading.large,
          ),
          const SizedBox(height: Dimensions.padding8),

          Text(
            'you_dont_have_any_saved_address_yet'.tr,
            textAlign: TextAlign.center,
            style: context.body.small,
          ),

          if(isLoggedIn) ...[
            const SizedBox(height: Dimensions.padding20),
            CustomButton(
              width: Get.width * 0.6,
              height: 44,
              buttonText: 'add_new_address'.tr,
              icon: Icons.add_circle_outline,
              radius: Dimensions.radius8,
              onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(false)),
            ),
          ],
        ],
      ),
    );
  }
}

class AddressActionButtons extends StatelessWidget {
  final bool fromDrawer;

  const AddressActionButtons({
    super.key,
    this.fromDrawer = false,
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomButton(
            buttonText: 'use_current_location'.tr,
            icon: Icons.gps_fixed,
            iconColor: Theme.of(context).primaryColor,
            textStyle: context.subHeading.defaultSize.overrideWith(
              fontWeight: AppWeight.medium,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            onPressed: () async {
              if (isRedundentClick(DateTime.now())) {
                return;
              }
              _checkPermission(() async {
                Get.back();
                Get.dialog(const CustomLoader(), barrierDismissible: false);
                AddressModel address = await Get.find<LocationController>().getCurrentLocation(
                  true,
                  deviceCurrentLocation: true,
                );
                ZoneResponseModel response = await Get.find<LocationController>().getZone(
                  address.latitude!,
                  address.longitude!,
                  false,
                );

                if (response.isSuccess) {
                  Get.find<LocationController>().saveAddressAndNavigate(address, false, '', false, true);
                } else {
                  Get.back();
                  customSnackBar(response.message);
                }
              });
            },
            radius: Dimensions.radius6,
          ),
        ),
        const SizedBox(height: Dimensions.padding16),

        InkWell(
          onTap: () {
            if (isRedundentClick(DateTime.now())) {
              return;
            }

            if (fromDrawer) {
              Get.dialog(
                PickMapDialogWidget(
                  previousAddress: Get.find<LocationController>().getUserAddress(),
                ),
              );
            } else {
              Get.back();

              Get.toNamed(RouteHelper.getPickMapRoute(
                Get.find<AuthController>().isLoggedIn() ? RouteHelper.getMainRoute('home') : RouteHelper.accessLocation,
                false,
                'false',
                null,
                Get.find<LocationController>().getUserAddress(),
              ));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.map_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: Dimensions.padding6),
              Text(
                'set_from_map'.tr,
                textAlign: TextAlign.center,
                style: context.subHeading.defaultSize.overrideWith(
                  fontWeight: AppWeight.medium,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
