import 'package:tatarigigs_user/common/models/config_model.dart';
import 'package:tatarigigs_user/common/widgets/custom_button.dart';
import 'package:tatarigigs_user/common/widgets/custom_image.dart';
import 'package:tatarigigs_user/common/widgets/gateway_webview_screen.dart';
import 'package:tatarigigs_user/feature/cart/controller/cart_controller.dart';
import 'package:tatarigigs_user/feature/coupon/controller/coupon_controller.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/splash/controller/splash_controller.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/helper/subscription_helper.dart';
import 'package:tatarigigs_user/util/app_constants.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPaymentDialog extends StatefulWidget {
  final Plans? plan;

  const SubscriptionPaymentDialog({
    super.key,
    required this.plan,
  });

  @override
  State<SubscriptionPaymentDialog> createState() => _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  int _selectedPaymentMethodIndex = -1;
  bool _isWalletSelected = false;

  @override
  Widget build(BuildContext context) {
    List<DigitalPaymentMethod> paymentMethodList = Get.find<SplashController>().configModel.content?.paymentMethodList ?? [];
    double walletBalance = Get.find<UserController>().userInfoModel?.walletBalance ?? 0;
    bool canProceed = _isWalletSelected || _selectedPaymentMethodIndex != -1;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20))
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.padding10).copyWith(bottom: 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.padding6),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 18, color: Theme.of(context).hintColor),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.padding20).copyWith(top: 0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('choose_payment_method'.tr, style: context.heading.large),
            const SizedBox(height: Dimensions.padding8),

            RichText(
              text: TextSpan(
                text: '${'total_price'.tr}  ',
                style: context.body.defaultSize,
                children: [
                  TextSpan(
                    text: PriceConverter.convertPrice(widget.plan?.price),
                    style: context.heading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.padding24),

            if(Get.find<SplashController>().configModel.content?.walletStatus == 1)...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.padding16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('wallet_balance'.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: Dimensions.padding4),

                        Text(PriceConverter.convertPrice(walletBalance), style: context.heading.large.overrideWith(color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        if(walletBalance >= (widget.plan?.price ?? 0.0)){
                          setState(() {
                            _isWalletSelected = !_isWalletSelected;
                            if (_isWalletSelected) {
                              _selectedPaymentMethodIndex = -1;
                            }
                          });
                        }
                        // else{
                        //   customSnackBar('insufficient_wallet_balance'.tr, showDefaultSnackBar: false);
                        // }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius8),
                          color: (walletBalance < (widget.plan?.price ?? 0.0)) ? Theme.of(context).hintColor : Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          _isWalletSelected ? 'pay_via_wallet'.tr : 'use_wallet'.tr,
                          style: context.body.small.overrideWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.padding20),
            ],

            paymentMethodList.isNotEmpty ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentMethodList.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
                child: Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
              ),
              itemBuilder: (context, index) {
                bool isSelected = _selectedPaymentMethodIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethodIndex = index;
                      _isWalletSelected = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.padding4),
                    child: Row(
                      children: [
                        CustomImage(
                          height: 30, width: 50, fit: BoxFit.contain,
                          image: paymentMethodList[index].gatewayImageFullPath ??"",
                        ),
                        const SizedBox(width: Dimensions.padding12),

                        Expanded(
                          child: Text(
                            paymentMethodList[index].label ?? "",
                            style: context.subHeading.defaultSize,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Container(
                          height: 20, width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withValues(alpha: 0.4)),
                          ),
                          child: isSelected
                              ? Center(child: Container(height: 11, width: 11, decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary)))
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ) : const SizedBox(),

            const SizedBox(height: Dimensions.padding24),

            GetBuilder<SubscriptionController>(builder: (subscriptionController){
              return CustomButton(
                buttonText: 'proceed'.tr,
                radius: Dimensions.radius12,
                isLoading: subscriptionController.isLoading,
                onPressed: canProceed ? () {

                  String methodName = _isWalletSelected ? 'wallet' : paymentMethodList[_selectedPaymentMethodIndex].gateway ?? '';

                  subscriptionController.paySubscriptionAmount(widget.plan?.id ?? '', methodName, AppConstants.baseUrl, "app").then((value) async{
                    if(_isWalletSelected){
                      if(value.statusCode == 200){
                        Get.back();
                        SubscriptionHelper().showSuccessDialog();
                        Get.find<UserController>().getUserInfo(reload: false);
                        Get.find<CartController>().refreshCart();
                        Get.find<CouponController>().getCouponList();
                      }
                    }else{
                      if(value.statusCode == 200){
                        String url = value.body['content']['redirect_link'];
                        Get.back();
                        await Get.to(()=> GatewayWebviewScreen(url:url, fromPage: "subscription_plan"));
                      }
                    }

                  });

                } : null,
              );
            }),
          ]),
        ),
      ]),
    );
  }
}
