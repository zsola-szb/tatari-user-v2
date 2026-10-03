import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceNotAvailableDialog extends StatefulWidget {
  final AddressModel? address;
  final  bool forCard;
  final bool showButton;
  final VoidCallback? onBackPressed;
  const ServiceNotAvailableDialog({super.key, this.address, this.forCard = false, this.showButton = true, this.onBackPressed});

  @override
  State<ServiceNotAvailableDialog> createState() => _ServiceNotAvailableDialogState();
}

class _ServiceNotAvailableDialogState extends State<ServiceNotAvailableDialog> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius16)),
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: Dimensions.webMaxWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radius20)),
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 20, width: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close, color: Theme.of(context).hintColor),
                    onPressed: widget.onBackPressed,
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.padding20),
              Image.asset(Images.notAvailableIcon, width:  50.0, height: 50.0, color: Get.isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor),
              const SizedBox(height: Dimensions.padding20),

              Text("services_are_not_available".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.padding20),

              Text(widget.forCard ? 'services_from_your_cart_is_not'.tr : "there_are_no_services".tr, style: context.body.defaultSize, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.padding20),

              widget.showButton ? Row(children: [
                Expanded(child: CustomButton(backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.65), buttonText: 'dont_change'.tr,
                  onPressed: () {
                    Get.back();
                    Get.find<LocationController>().saveAddressAndNavigate(widget.address!, false, '', true , true,  fromAddressDialog: true,showDialog: "false");
                  }
                )),
                const SizedBox(width: Dimensions.padding10),
                Expanded(child: CustomButton(buttonText: 'continue'.tr,
                  onPressed: widget.onBackPressed,
                )),
              ]) : const SizedBox(),
              widget.showButton ? const SizedBox(height: Dimensions.padding20) : const SizedBox(),

              InkWell(
                onTap: () {
                  Get.back();
                  Get.toNamed(RouteHelper.getServiceArea());
                },
                child: Text("view_available_areas".tr, style: context.subHeading.defaultSize.copyWith(fontWeight: AppWeight.medium, color: Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor, decoration: TextDecoration.underline)),
              ),

            ]
        ),
      ),
    );
  }
}
