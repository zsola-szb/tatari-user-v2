import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/widget/subscription_payment_dialog.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/subscription_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/feature/provider/widgets/pro_plan_terms_dialog_widget.dart';

class ProPlanDialogWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final bool isBottomSheet;

  const ProPlanDialogWidget({
    super.key,
    this.scrollController,
    required this.isBottomSheet,
  });

  @override
  State<ProPlanDialogWidget> createState() => _ProPlanDialogWidgetState();
}

class _ProPlanDialogWidgetState extends State<ProPlanDialogWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.isBottomSheet) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          Dimensions.padding16,
          0,
          Dimensions.padding16,
          Dimensions.padding16,
        ),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: _ContentView(isBottomSheet: widget.isBottomSheet),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: _ContentView(isBottomSheet: widget.isBottomSheet),
      );
    }
  }
}

class _ContentView extends StatelessWidget {
  final bool isBottomSheet;
  const _ContentView({required this.isBottomSheet});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController){
      return GetBuilder<UserController>(builder: (userController){
        return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (isBottomSheet) ...[
            Center(child: Container(
              margin: const EdgeInsets.only(top: Dimensions.padding10),
              height: 5,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius12),
                color: Theme.of(context).hintColor.withValues(alpha: 0.15),
              ),
            )),
          ],

          Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding10,
                  left: Dimensions.padding24,
                  right: Dimensions.padding24,
                ),
                child: Column(children: [
                  Text(
                    'choose_your_pro_plan'.tr,
                    style: context.heading.large.overrideWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimensions.padding6),

                  Text(
                    'unlock_exclusive_benefits'.tr,
                    style: context.body.small,
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  ),
                  padding: const EdgeInsets.all(Dimensions.padding6),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.padding20),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(Dimensions.padding10)
            ),
            padding: EdgeInsets.all(Dimensions.padding10),
            margin: EdgeInsets.only(bottom: Dimensions.padding16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'select_package'.tr,
                style: context.subHeading.small.overrideWith(
                  fontWeight: AppWeight.medium,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: Dimensions.padding10),

              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.padding10)
                ),
                padding: EdgeInsets.all(Dimensions.padding6),
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subscriptionController.subscriptionModel?.content?.plans?.length,
                  itemBuilder: (context, index) {
                    bool isSelected = subscriptionController.selectedPlanIndex == index;
                    return GestureDetector(
                      onTap: () {
                        subscriptionController.setPlanIndex(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: Dimensions.padding10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.padding16,
                          vertical: Dimensions.padding6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ?
                          Theme.of(context).cardColor :
                          null,
                          boxShadow: isSelected ?
                          [BoxShadow(color: Theme.of(context).cardColor, blurRadius: 2, offset: Offset(0, 1), spreadRadius: -1)] :
                          null,
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          subscriptionController.subscriptionModel?.content?.plans?[index].planName ?? '',
                          style: context.subHeading.small.overrideWith(
                            fontWeight: AppWeight.medium,
                            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.padding20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.padding16),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radius16),
                ),
                child: Column(children: [
                  Image.asset(
                    Images.premiumIcon,
                    height: 40,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: Dimensions.padding6),

                  Text(
                    'pro_member'.tr,
                    style: context.subHeading.large.overrideWith(
                      fontWeight: AppWeight.medium,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    'save_more_on_every_order'.tr,
                    style: context.body.small,
                  ),
                  const SizedBox(height: Dimensions.padding20),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.padding16,
                      vertical: Dimensions.padding10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'duration'.tr,
                          style: context.body.extraSmall,
                        ),
                        const SizedBox(height: 2),

                        Text(
                          '${subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex].durationDays} ${'days'.tr}',
                          style: context.heading.defaultSize.overrideWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ]),

                      Text(
                        PriceConverter.convertPrice(subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex].price ?? 0),
                        style: context.heading.overLarge.overrideWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    decoration: BoxDecoration(
                      color: context.customThemeColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                      border: Border.all(color: context.customThemeColors.warning.withValues(alpha: 0.2)),
                    ),
                    child: Row(children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                        ),
                        padding: const EdgeInsets.all(Dimensions.padding6),
                        child: Icon(
                          Icons.check,
                          color: context.customThemeColors.success,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding10),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          _checkDiscountType(subscriptionController),
                          style: context.heading.small.overrideWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 2),

                        Text(
                          'applied_automatically_at_checkout'.tr,
                          style: context.body.extraSmall,
                        ),
                      ]),
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: Dimensions.padding20),

              CustomButton(
                width: Get.width * 0.4,
                buttonText: _getSubscriptionButtonText(subscriptionController, userController),
                onPressed: () {
                  final  plan = subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex];

                  if(plan?.type == 'paid'){
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return SubscriptionPaymentDialog(
                          plan: subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex],
                        );
                      },
                    );
                  }else{
                    subscriptionController.paySubscriptionAmount(plan?.id ?? '', '', '', '').then((value){
                      if(value.statusCode == 200){
                        SubscriptionHelper().showSuccessDialog();
                        Get.find<UserController>().getUserInfo(reload: false);
                        Get.find<CartController>().refreshCart();
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: Dimensions.padding6),
            ]),
          ),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.padding10),
                border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2))
            ),
            padding: EdgeInsets.all(Dimensions.padding16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('frequently_asked_questions'.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium)),

              ListView.separated(
                itemCount: subscriptionController.subscriptionModel?.content?.faqs?.length ?? 0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    shape: const Border(),
                    collapsedShape: const Border(),
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                    iconColor: Theme.of(context).textTheme.bodyMedium?.color,
                    title: Text(subscriptionController.subscriptionModel?.content?.faqs?[index].question ?? '', style: context.subHeading.small),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          subscriptionController.subscriptionModel?.content?.faqs?[index].answer ?? '',
                          style: context.subHeading.small,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (ctx, idx){
                  return Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.5));
                },
              )
            ]),
          ),
          const SizedBox(height: Dimensions.padding16),

          Center(child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      minChildSize: 0.4,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (context, scrollController) {
                        return ProPlanTermsDialogWidget(
                          scrollController: scrollController,
                          isBottomSheet: true,
                        );
                      },
                    );
                  },
                );
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: context.heading.small.copyWith(
                  fontWeight: AppWeight.semiBold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  decorationColor: Theme.of(context).textTheme.bodyMedium?.color,
                  decoration: TextDecoration.underline,
                ),
                child: Text('terms_and_conditions'.tr),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.padding10),
        ]);
      });
    });
  }

  String _getSubscriptionButtonText(SubscriptionController subscriptionController, UserController userController) {
    final selectedPlan = subscriptionController
        .subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex];
    final subscribedPlan = userController.userInfoModel?.subscribedPlan;

    if (subscribedPlan == null) {
      return selectedPlan?.type == 'paid' ? 'subscribe_now'.tr : 'start_free_trial'.tr;
    }

    return selectedPlan?.id == subscribedPlan.subscriptionPlanId
        ? 'renew_subscription'.tr
        : 'shift_plan'.tr;
  }

  String _checkDiscountType(SubscriptionController subscriptionController){

    if(subscriptionController.subscriptionModel?.content?.benefits?.discount?.status == 1){
      return '${'you_can_able_discount'.tr} ${subscriptionController.subscriptionModel?.content?.benefits?.discount?.discount}% ${'for_all_bookings'.tr}';
    }else if(subscriptionController.subscriptionModel?.content?.benefits?.coupon?.status == 1){
      return 'you_can_able_coupon_from_coupon_list'.tr;
    }else{
      return '${'you_can_able_service'.tr} ${subscriptionController.subscriptionModel?.content?.benefits?.serviceFee?.type}';
    }
  }

}

