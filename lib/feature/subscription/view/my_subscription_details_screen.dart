import 'package:tatarigigs_user/common/widgets/confirmation_bottomsheet.dart';
import 'package:tatarigigs_user/common/widgets/custom_app_bar.dart';
import 'package:tatarigigs_user/common/widgets/custom_button.dart';
import 'package:tatarigigs_user/feature/splash/controller/splash_controller.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_detail_row.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/feature/provider/widgets/pro_plan_terms_dialog_widget.dart';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/helper/date_converter.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/helper/route_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySubscriptionDetailsScreen extends StatefulWidget {
  const MySubscriptionDetailsScreen({super.key});

  @override
  State<MySubscriptionDetailsScreen> createState() => _MySubscriptionDetailsScreenState();
}

class _MySubscriptionDetailsScreenState extends State<MySubscriptionDetailsScreen> {
  @override
  void initState() {
    Get.find<SubscriptionController>().getSubscriptionTerms();
    Get.find<SubscriptionController>().getSubscriptionList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: CustomAppBar(
        title: 'pro_member'.tr,
        bgColor: Theme.of(context).cardColor,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: GetBuilder<UserController>(builder: (userController){
        return GetBuilder<SubscriptionController>(builder: (subscriptionController){
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.padding16),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.padding10),
                Text('my_subscription'.tr, style: context.heading.large),
                const SizedBox(height: Dimensions.padding6),

                Text(
                  'my_subscription_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: context.body.small,
                ),
                const SizedBox(height: Dimensions.padding20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius16),
                  ),
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(Images.subscriptionIcon, height: 48, width: 48),
                      const SizedBox(height: Dimensions.padding10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              userController.userInfoModel?.subscribedPlan?.planName ?? '',
                              style: context.heading.large,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Dimensions.padding8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.padding10,
                              vertical: Dimensions.padding4,
                            ),
                            decoration: BoxDecoration(
                              color: context.customThemeColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                            ),
                            child: Text(
                              'active'.tr,
                              style: context.body.small.overrideWith(color: context.customThemeColors.success, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.padding4),

                      Text('save_more_on_every_booking'.tr, style: context.body.small),
                      const SizedBox(height: Dimensions.padding20),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.padding12),
                              decoration: BoxDecoration(
                                color: context.customThemeColors.secondaryBackGroundColor,
                                borderRadius: BorderRadius.circular(Dimensions.radius12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('total_saved'.tr, style: context.body.small),
                                  const SizedBox(height: Dimensions.padding4),

                                  Text(
                                    PriceConverter.convertPrice(userController.userInfoModel?.currentPlanTotalSaved ?? 0),
                                    style: context.heading.defaultSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.padding12),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.padding12),
                              decoration: BoxDecoration(
                                color: context.customThemeColors.secondaryBackGroundColor,
                                borderRadius: BorderRadius.circular(Dimensions.radius12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('orders_placed'.tr, style: context.body.small),
                                  const SizedBox(height: Dimensions.padding4),

                                  Text(
                                    '${userController.userInfoModel?.currentPlanTotalOrder ?? 0}',
                                    style: context.heading.defaultSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.padding16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimensions.padding12),
                        decoration: BoxDecoration(
                          color: context.customThemeColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30, width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                              child: Icon(Icons.check, color: context.customThemeColors.success, size: 12),
                            ),
                            const SizedBox(width: Dimensions.padding10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_checkDiscountType(), style: context.subHeading.small.overrideWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: Dimensions.padding2),

                                  Text('applied_automatically_at_checkout'.tr, style: context.body.small),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.padding16),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius16),
                          border: Border.all(color: context.customThemeColors.secondaryBackGroundColor)
                        ),
                        padding: const EdgeInsets.all(Dimensions.padding16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('plan_details'.tr, style: context.heading.defaultSize.overrideWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: Dimensions.padding8),

                            PlanDetailRow(
                              icon: Icons.calendar_month_outlined,
                              title: 'active_since',
                              value: userController.userInfoModel?.subscribedPlan?.startDate != null ? DateConverter.isoStringToLocalDateOnly(userController.userInfoModel?.subscribedPlan?.startDate ?? '') : '',
                            ),

                            PlanDetailRow(
                              icon: Icons.calendar_month_outlined,
                              title: 'expires_on',
                              value: userController.userInfoModel?.subscribedPlan?.expireDate != null ? DateConverter.isoStringToLocalDateOnly(userController.userInfoModel?.subscribedPlan?.expireDate ?? '') : '',
                            ),

                            PlanDetailRow(
                              icon: Icons.calendar_today_outlined,
                              title: 'days_remaining',
                              value: '${userController.userInfoModel?.currentPlanRemainingDays ?? 0}',
                            ),

                            PlanDetailRow(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'paid_by',
                              value: userController.userInfoModel?.subscribedPlan?.paidBy ?? '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.padding16),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius16),
                  ),
                  padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('frequently_asked_questions'.tr, style: context.heading.defaultSize),

                    ListView.separated(
                      itemCount: subscriptionController.subscriptionModel?.content?.faqs?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                style: context.body.small,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (ctx, idx){
                        return Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.15));
                      },
                    )
                  ]),
                ),
                const SizedBox(height: Dimensions.padding10),

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
                const SizedBox(height: Dimensions.padding20),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar: GetBuilder<SubscriptionController>(builder: (subscriptionController){
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.padding16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(top: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.15))),
              ),
              child: Row(children: [
                Expanded(child: CustomButton(
                  isLoading: subscriptionController.isLoading,
                  buttonText: 'cancel_subscription'.tr,
                  radius: Dimensions.radius12,
                  onPressed: () => Get.bottomSheet(
                    ConfirmationBottomsheet(
                      icon: Images.warning,
                      title: "${"are_you_sure".tr} ?",
                      description: "are_you_want_to_cancel_subscription".tr,
                      onYesPressed: () {
                        Get.back();
                        subscriptionController.cancelSubscription();
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  ),
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                )),

                if(Get.find<SplashController>().configModel.content?.isProFeatureActive == 1)...[
                  const SizedBox(width: Dimensions.padding16),
                  Expanded(child: CustomButton(
                    buttonText: 'renew_subscription'.tr,
                    radius: Dimensions.radius12,
                    textColor: Theme.of(context).cardColor,
                    onPressed: () => Get.toNamed(RouteHelper.getSubscriptionRoute()),
                  ))
                ]
              ]),
            ),
          ]),
        );
      }),
    );
  }

  String _checkDiscountType(){
    final benefits = Get.find<SubscriptionController>().subscriptionModel?.content?.benefits;

    if(benefits?.discount?.status == 1){
      return '${'you_can_able_discount'.tr} ${benefits?.discount?.discount}% ${'for_all_bookings'.tr}';
    }else if(benefits?.coupon?.status == 1){
      return 'you_can_able_coupon_from_coupon_list'.tr;
    }else{
      return '${'you_can_able_service'.tr} ${(benefits?.serviceFee?.type ?? '').tr}';
    }
  }
}
