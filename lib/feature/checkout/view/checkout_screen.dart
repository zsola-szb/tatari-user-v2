import 'package:tatarigigs_user/feature/checkout/widget/booking_type/booking_type_tabs.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/instant_service_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/booking_type/multiple_booking_type_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/checkout_bottom_bar.dart';
import 'package:tatarigigs_user/feature/checkout/widget/checkout_shimmer_view.dart';
import 'package:tatarigigs_user/feature/checkout/widget/coupon/checkout_coupon_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/guest_create_account_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/get_service_at_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/repeat_cash_payment_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/summary/billing_summary_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CheckoutController>().initData(flow: CheckoutFlow.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: SafeArea(
        child: GetBuilder<CheckoutController>(
          builder: (CheckoutController controller) {
            if (controller.isPageLoading) {
              return const CheckoutShimmerView();
            }
            return GetBuilder<CartController>(
              builder: (CartController cartController) {
                if (cartController.isLoading) {
                  return const CheckoutShimmerView();
                }

                if (cartController.isEmpty) {
                  return _EmptyCartView(onBack: () => Get.offAllNamed(RouteHelper.home));
                }

                return _CheckoutBody(controller: controller);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  final CheckoutController controller;

  const _CheckoutBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutScheduleController>(
      builder: (CheckoutScheduleController schedule) {
        final bool isRepeat = !schedule.isSingleBooking;
        final CheckoutTotals totals = controller.displayTotals;

        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.padding16),
                child: Center(
                  child: SizedBox(
                    width: Dimensions.webMaxWidth,
                    child: Column(
                      children: <Widget>[
                        if (controller.isRepeatBookingAllowed) ...<Widget>[
                          BookingTypeTabs(
                            isSingleBooking: schedule.isSingleBooking,
                            onChanged: (bool isSingle) {
                              schedule.setBookingMode(isSingle);
                              controller.autoSelectPaymentMethod();
                              controller.recalculateTotals();
                            },
                          ),
                          const SizedBox(height: Dimensions.padding16),
                        ],

                        if (isRepeat)
                          const MultipleBookingTypeSection()
                        else
                          const InstantServiceSection(),
                        const SizedBox(height: Dimensions.padding16),

                        const GetServiceAtSection(),
                        const SizedBox(height: Dimensions.padding16),

                        if (controller.canCreateGuestAccount &&
                            controller.hasContactInfo) ...<Widget>[
                          const GuestCreateAccountSection(),
                          const SizedBox(height: Dimensions.padding16),
                        ],

                        if (controller.isLoggedIn) ...<Widget>[
                          const CheckoutCouponSection(),
                          const SizedBox(height: Dimensions.padding16),
                        ],

                        if (isRepeat)
                          const RepeatCashPaymentCard()
                        else
                          const PaymentMethodSection(),
                        const SizedBox(height: Dimensions.padding16),

                        const BillingSummarySection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CheckoutBottomBar(
              total: totals.dueAmount,
              originalTotal: totals.originalTotal,
              showStrikethrough: totals.hasDiscount,
              isLoading: controller.isLoading,
              canConfirm: controller.scheduleAvailabilityError == null,
              onConfirm: (){
                controller.checkPriceAreUpdated(Get.find<CartController>().scopeProviderId).then((value){
                  if(value.body['response_code'] == 'default_200'){
                    controller.submitBooking(
                      onPaymentMethodMissing: () => CheckoutPaymentMethodSheet.open(context),
                    );
                  }else if (value.body['response_code'] == 'checkout_total_changed_409'){
                    Get.find<CartController>().refreshCart().then((_){
                      Get.bottomSheet(
                        ConfirmationBottomsheet(
                          icon: Images.warning,
                          title: 'some_services_price'.tr,
                          description: 'services_price_has_been_updates'.tr,
                          customButton: CustomButton(
                            buttonText: 'ok'.tr,
                            onPressed: ()=> Get.back(),
                          ),
                          yesButtonColor: Theme.of(Get.context!).colorScheme.primary,
                        ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );
                    });

                  }else{
                    Get.find<CartController>().refreshCart().then((_){
                      customSnackBar('${value.body['message']}', showDefaultSnackBar: false);
                    });
                  }

                });
              },
            ),
          ],
        );
      },
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  final VoidCallback onBack;

  const _EmptyCartView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NoDataScreen(
              text: 'your_cart_is_empty'.tr,
              type: NoDataType.cart,
              isShowHomePage: false,
            ),
            const SizedBox(height: Dimensions.padding20),
            CustomButton(
              buttonText: 'back_to_home'.tr,
              width: 250,
              radius: Dimensions.radius12,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
