import 'package:tatarigigs_user/feature/cart/controller/cart_controller.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tatarigigs_user/feature/provider/widgets/pro_plan_dialog_widget.dart';

class PremiumCardWidget extends StatelessWidget {
  const PremiumCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Get.find<UserController>().userInfoModel?.subscribedPlan == null ?
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xFFB58EFF),
              Color(0xFFA16BFF),
            ],
          ),
          borderRadius: BorderRadius.circular(Dimensions.padding10),
        ),
        padding: EdgeInsets.all(Dimensions.padding10),
        margin: EdgeInsets.symmetric(horizontal: Dimensions.padding16).copyWith(top: Dimensions.padding10),
        child:
        Row(spacing: Dimensions.padding10, children: [
          Flexible(
            child: Row(spacing: Dimensions.padding10, children: [
              Image.asset(Images.premiumIcon, height: 16, width: 16, color: Theme.of(context).colorScheme.secondary),


              Flexible(
                child: RichText(text: TextSpan(text: '${'enjoy_extra_savings_on_every'.tr} ', children: [
                  TextSpan(text: 'pro_member'.tr, style: context.heading.small.overrideWith(color: Theme.of(context).cardColor))
                ], style: context.subHeading.small.overrideWith(color: Theme.of(context).cardColor))),
              )
            ]),
          ),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.4,
                    maxChildSize: 0.95,
                    expand: false,
                    builder: (context, scrollController) {
                      return ProPlanDialogWidget(
                        scrollController: scrollController,
                        isBottomSheet: true,
                      );
                    },
                  );
                },
              );
            },
            child: Text('subscribe_now'.tr, style: context.heading.small.copyWith(
                fontWeight: AppWeight.semiBold,
                decorationColor: Theme.of(context).cardColor,
                decoration: TextDecoration.underline,
                color: Theme.of(context).cardColor
            )),
          )
        ]),
      ) :
      GetBuilder<CartController>(builder: (cardController){
        return (cardController.appliedProDiscount > 0 || !cardController.hasProBenefit) ?
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFFB58EFF),
                Color(0xFFA16BFF),
              ],
            ),
            borderRadius: BorderRadius.circular(Dimensions.padding10),
          ),
          padding: EdgeInsets.all(Dimensions.padding10),
          margin: EdgeInsets.symmetric(horizontal: Dimensions.padding16).copyWith(top: Dimensions.padding10),
          child:
          Row(spacing: Dimensions.padding10, children: [
            Flexible(
              child: Row(spacing: Dimensions.padding10, children: [
                Image.asset(Images.premiumIcon, height: 16, width: 16, color: Theme.of(context).colorScheme.secondary),

                cardController.hasProBenefit ?
                Flexible(
                  child: RichText(text: TextSpan(text: '${'applied'.tr} ', children: [
                    TextSpan(
                      text: '${PriceConverter.convertPrice(cardController.appliedProDiscount)} ${cardController.proBenefitType == 'coupon' ? 'coupon_discount'.tr : cardController.proBenefitType == 'service_fee' ? 'service_charge_discount'.tr : 'discount'.tr} ',
                      style: context.heading.small.overrideWith(color: Theme.of(context).cardColor),
                    ),
                    TextSpan(text: '${'for_pro_subscription'.tr}.', style: context.subHeading.small.overrideWith(color: Theme.of(context).cardColor)),

                  ], style: context.subHeading.small.overrideWith(color: Theme.of(context).cardColor))),
                ) :
                Text('apply_coupon_for_pro_subscription'.tr, style: context.subHeading.defaultSize.overrideWith(color: Theme.of(context).cardColor))
              ]),
            ),

          ]),
        ) :
        const SizedBox();
      });
  }
}
