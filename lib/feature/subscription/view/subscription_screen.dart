import 'package:tatarigigs_user/common/widgets/custom_app_bar.dart';
import 'package:tatarigigs_user/common/widgets/custom_loader_widget.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/provider/widgets/pro_plan_terms_dialog_widget.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/feature/subscription/widget/subscription_purchase_button.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/helper/route_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  @override
  void initState() {
    Get.find<SubscriptionController>().getSubscriptionList();
    Get.find<SubscriptionController>().getSubscriptionTerms();
    Get.find<SubscriptionController>().setPlanIndex(0, isUpdate: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: CustomAppBar(
        title: 'pro_member'.tr,
        onBackPressed: (){
          if(Navigator.canPop(context)){
            Get.back();
          }else{
            Get.offAllNamed(RouteHelper.getMainRoute("home"));
          }
        },
      ),
      body: GetBuilder<SubscriptionController>(builder: (subscriptionController){
        return subscriptionController.subscriptionModel != null ?
        GetBuilder<UserController>(builder: (userController){
          return (subscriptionController.subscriptionModel?.content?.plans ?? []).isNotEmpty ?
          Padding(
            padding: const EdgeInsets.all(Dimensions.padding16),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        style: context.heading.large,
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
                const SizedBox(height: Dimensions.padding20),

                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius16)
                  ),
                  padding: EdgeInsets.all(Dimensions.padding10),
                  margin: EdgeInsets.only(bottom: Dimensions.padding16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: context.customThemeColors.secondaryBackGroundColor,
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
                              margin: const EdgeInsets.only(right: Dimensions.padding6),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.padding16,
                                      vertical: Dimensions.padding6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ?
                                      Theme.of(context).primaryColor :
                                      null,
                                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      subscriptionController.subscriptionModel?.content?.plans?[index].planName ?? '',
                                      style: context.heading.small.overrideWith(
                                        color: isSelected ?
                                        Theme.of(context).cardColor :
                                        context.customThemeColors.secondaryTextColor,
                                      ),
                                    ),
                                  ),
                                  if (subscriptionController.subscriptionModel?.content?.plans?[index].id == userController.userInfoModel?.subscribedPlan?.subscriptionPlanId)
                                    Positioned(
                                      top: 0,
                                      right: -3,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                        child: Icon(Icons.check, size: 10, color: Theme.of(context).cardColor),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.padding20),

                    Column(children: [
                      Image.asset(
                        Images.premiumIcon,
                        height: 40,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: Dimensions.padding6),

                      Text(
                        'pro_member'.tr,
                        style: context.heading.large,
                      ),
                      const SizedBox(height: 2),

                      Text(
                        'save_more_on_every_order'.tr,
                        style: context.body.defaultSize,
                      ),
                      const SizedBox(height: Dimensions.padding20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.padding16,
                          vertical: Dimensions.padding10,
                        ),
                        decoration: BoxDecoration(
                          color: context.customThemeColors.secondaryBackGroundColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              'duration'.tr,
                              style: context.heading.small.overrideWith(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 2),

                            Text(
                              '${subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex].durationDays} ${'days'.tr}',
                              style: context.heading.defaultSize,
                            ),
                          ]),

                          Text(
                            PriceConverter.convertPrice(subscriptionController.subscriptionModel?.content?.plans?[subscriptionController.selectedPlanIndex].price ?? 0),
                            style: context.heading.extraLarge,
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
                              style: context.heading.small,
                            ),
                            const SizedBox(height: 2),

                            Text(
                              'applied_automatically_at_checkout'.tr,
                              style: context.body.small,
                            ),
                          ]),
                          ),
                        ]),
                      ),
                    ]),
                  ]),
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.padding16),
                      color: Theme.of(context).cardColor
                  ),
                  padding: EdgeInsets.all(Dimensions.padding16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('frequently_asked_questions'.tr, style: context.heading.defaultSize),

                    ListView.separated(
                      itemCount: subscriptionController.subscriptionModel?.content?.faqs?.length ?? 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          shape: const Border(),
                          collapsedShape: const Border(),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          textColor: Theme.of(context).textTheme.bodyMedium?.color,
                          iconColor: Theme.of(context).textTheme.bodyMedium?.color,
                          title: Text(subscriptionController.subscriptionModel?.content?.faqs?[index].question ?? '', style: context.heading.small.overrideWith(fontWeight: FontWeight.w500)),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                subscriptionController.subscriptionModel?.content?.faqs?[index].answer ?? '',
                                style: context.body.small,
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
              ]),
            ),
          ) :
          Center(child: Text('no_data_found'.tr));
        }) :
        CustomLoaderWidget(color: Theme.of(context).primaryColor);
      }),
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [const SubscriptionPurchaseButton()]),
    );
  }

  String _checkDiscountType(SubscriptionController subscriptionController){

    if(subscriptionController.subscriptionModel?.content?.benefits?.discount?.status == 1){
      return '${'you_can_able_discount'.tr} ${subscriptionController.subscriptionModel?.content?.benefits?.discount?.discount}% ${'for_all_bookings'.tr}';
    }else if(subscriptionController.subscriptionModel?.content?.benefits?.coupon?.status == 1){
      return 'you_can_able_coupon_from_coupon_list'.tr;
    }else{
      return '${'you_can_able_service'.tr} ${subscriptionController.subscriptionModel?.content?.benefits?.serviceFee?.type.toString().tr}';
    }
  }
}
