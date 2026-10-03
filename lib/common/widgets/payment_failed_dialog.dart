import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class PaymentFailedDialog extends StatelessWidget {
  final bool isAddFound;
  const PaymentFailedDialog({super.key, required this.isAddFound});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.all(Dimensions.padding20),
        child: Image.asset(Images.warning, width: 70, height: 70),
      ),
      Text(
        isAddFound ? 'are_you_agree_with_this_payment_fail'.tr :
        'are_you_agree_with_this_order_fail'.tr, textAlign: TextAlign.center,
        style: context.subHeading.extraLarge.overrideWith(fontWeight: AppWeight.medium, color: Colors.red),
      ),
      const SizedBox(height: Dimensions.padding20),
      CustomButton(
          onPressed: (){
            Get.back();
            Get.back();
          },
          buttonText: 'retry'.tr),
      const SizedBox(height: Dimensions.padding16,),

      TextButton(
        onPressed: () {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        },
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.3), minimumSize: const Size(Dimensions.webMaxWidth, 45), padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius6)),
        ),
        child: Text(isAddFound ? 'continue_with_payment_fail'.tr : 'continue_with_order_fail'.tr, textAlign: TextAlign.center, style: context.heading.defaultSize.overrideWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
      ),

    ]);
  }
}
