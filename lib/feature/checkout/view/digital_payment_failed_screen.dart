import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_inset_panel.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class DigitalPaymentFailedScreen extends StatelessWidget {
  final double amount;

  const DigitalPaymentFailedScreen({super.key, this.amount = 0});

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          title: 'payment_failed'.tr,
          onBackPressed: () => Get.offAllNamed(RouteHelper.getMainRoute('home')),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(Images.warning, width: 70, height: 70),
                  const SizedBox(height: Dimensions.padding20),

                  CheckoutInfoBox(
                    tone: CheckoutInfoTone.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.padding16,
                      vertical: Dimensions.padding8,
                    ),
                    child: Text(
                      '${'payment_failed'.tr} !!',
                      textAlign: TextAlign.center,
                      style: context.heading.defaultSize.copyWith(color: context.customThemeColors.error),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  Text(
                    'your_bookings_is_failed_to_place'.tr,
                    textAlign: TextAlign.center,
                    style: context.heading.large,
                  ),
                  const SizedBox(height: Dimensions.padding6),
                  Text(
                    'you_can_try_again_later'.tr,
                    textAlign: TextAlign.center,
                    style: context.body.small,
                  ),

                  if (amount > 0) ...<Widget>[
                    const SizedBox(height: Dimensions.padding20),
                    CheckoutInsetPanel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.padding16,
                        vertical: Dimensions.padding10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'due_amount'.tr,
                            style: context.subHeading.defaultSize,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              PriceConverter.convertPrice(amount),
                              style: context.heading.defaultSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: Dimensions.padding24),

                  CustomButton(
                    buttonText: 'retry'.tr,
                    width: 250,
                    radius: Dimensions.radius12,
                    onPressed: () => Get.offNamed(RouteHelper.getCheckoutRoute()),
                  ),
                  const SizedBox(height: Dimensions.padding10),

                  CustomButton(
                    buttonText: 'back_to_home'.tr,
                    width: 250,
                    radius: Dimensions.radius8,
                    onPressed: () => Get.offAllNamed(RouteHelper.getMainRoute('home')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
