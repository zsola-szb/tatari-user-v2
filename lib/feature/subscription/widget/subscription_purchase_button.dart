import 'package:tatarigigs_user/common/widgets/custom_button.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/widget/subscription_payment_dialog.dart';
import 'package:tatarigigs_user/helper/subscription_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPurchaseButton extends StatelessWidget {
  const SubscriptionPurchaseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController) {
      final plans = subscriptionController.subscriptionModel?.content?.plans ?? [];
      if (plans.isEmpty) {
        return const SizedBox.shrink();
      }

      return GetBuilder<UserController>(builder: (userController) {
        final plan = plans[subscriptionController.selectedPlanIndex];

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(Dimensions.padding16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.15))),
            ),
            child: CustomButton(
              buttonText: _getSubscriptionButtonText(subscriptionController, userController),
              isLoading: subscriptionController.isLoading,
              onPressed: (plan.isActive ?? false) ? () {
                subscriptionController.setTabIndex(subscriptionController.selectedPlanIndex);
                if (plan.type == 'paid') {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return SubscriptionPaymentDialog(plan: plan);
                    },
                  );
                } else {
                  subscriptionController.paySubscriptionAmount(plan.id ?? '', '', '', '').then((value) {
                    if (value.statusCode == 200) {
                      SubscriptionHelper().showSuccessDialog();
                      Get.find<UserController>().getUserInfo(reload: false);
                    }
                  });
                }
              } : null,
            ),
          ),
        );
      });
    });
  }

  String _getSubscriptionButtonText(SubscriptionController subscriptionController, UserController userController) {
    final selectedPlan = subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex];
    final subscribedPlan = userController.userInfoModel?.subscribedPlan;

    if (subscribedPlan == null) {
      return selectedPlan?.type == 'paid' ? 'subscribe_now'.tr : 'start_free_trial'.tr;
    }

    return selectedPlan?.id == subscribedPlan.subscriptionPlanId
        ? 'renew_subscription'.tr
        : 'shift_plan'.tr;
  }
}
