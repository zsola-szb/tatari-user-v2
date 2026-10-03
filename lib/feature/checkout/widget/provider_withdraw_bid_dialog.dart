import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ProviderWithdrawBidDialog extends StatefulWidget {

  const ProviderWithdrawBidDialog({super.key});

  @override
  State<ProviderWithdrawBidDialog> createState() => _ProviderWithdrawBidDialogState();
}

class _ProviderWithdrawBidDialogState extends State<ProviderWithdrawBidDialog> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius16)),
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: Dimensions.webMaxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20,),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          Align(alignment: Alignment.topRight,
            child: SizedBox(
              height: 20, width: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close, color: Theme.of(context).hintColor),
                onPressed: (){
                  Get.back();
                  Get.offNamed(RouteHelper.getMyPostScreen());
                },
              ),
            ),
          ),

          const SizedBox(height: Dimensions.padding20),
          Image.asset(Images.notAvailableIcon, width:  50.0, height: 50.0, color: Get.isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor),
          const SizedBox(height: Dimensions.padding20),

          Text("services_request_has_been_withdrawn".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium), textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.padding20),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Text('you_can_not_processed_to_checkout_custom_booking_because'.tr , style: context.body.defaultSize, textAlign: TextAlign.center),
          ),
          const SizedBox(height: Dimensions.padding20 * 1.3),

          InkWell(
            onTap: () {
              Get.back();
              Get.offNamed(RouteHelper.getMyPostScreen());
            },
            child: Text("view_other_offers".tr, style: context.subHeading.defaultSize.copyWith(fontWeight: AppWeight.medium, color: Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor, decoration: TextDecoration.underline)),
          ),

          const SizedBox(height: Dimensions.padding20 ),
        ]),
      ),
    );
  }
}
