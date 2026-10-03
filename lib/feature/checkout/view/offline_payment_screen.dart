import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/checkout/widget/checkout_bottom_bar.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/guest_phone_verification_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/offline/offline_method_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/offline/offline_payment_form.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final String bookingId;
  final String readableId;
  final double amount;
  final int isPartialPayment;
  final bool createdAccount;
  final SignUpBody? newUserInfo;

  const OfflinePaymentScreen({
    super.key,
    required this.bookingId,
    this.readableId = '',
    this.amount = 0,
    this.isPartialPayment = 0,
    this.createdAccount = false,
    this.newUserInfo,
  });

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
  @override
  void initState() {
    super.initState();
    final CheckoutController controller = Get.find<CheckoutController>();

    if (controller.offlineMethodList.isEmpty) {
      controller.loadOfflineMethodList().then((_) {
        if (mounted) {
          _seedSelection(controller, notify: true);
        }
      });
      return;
    }

    _seedSelection(controller, notify: false);
  }

  void _seedSelection(CheckoutController controller, {required bool notify}) {
    if (controller.selectedOfflineMethod == null && controller.offlineMethodList.isNotEmpty) {
      controller.selectPaymentMethod(
        offlineMethod: controller.offlineMethodList.first,
        notify: false,
      );
    }
    controller.buildOfflineInputControllers(notify: notify);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      onPopInvoked: _confirmLeave,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          title: 'offline_payment'.tr,
          onBackPressed: _confirmLeave,
        ),
        body: SafeArea(
          child: GetBuilder<CheckoutController>(
            builder: (CheckoutController controller) {
              if (controller.isOfflineLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(Dimensions.padding16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Image.asset(Images.offlinePayment, height: 90),
                          ),
                          const SizedBox(height: Dimensions.padding16),
                          Text('pay_your_bill_using_the_info'.tr,
                            textAlign: TextAlign.center,
                            style: context.body.defaultSize,
                          ),
                          const SizedBox(height: Dimensions.padding16),

                          if (controller.offlineMethodList.isEmpty)
                            Text('no_offline_payment_method_available'.tr,
                              style: context.body.small,
                            )
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.offlineMethodList.map(
                                      (CheckoutOfflineMethodModel method) =>
                                        OfflineMethodCard(
                                        method: method,
                                        isSelected: controller.selectedOfflineMethod?.id == method.id,
                                        onTap: () {
                                          controller.selectPaymentMethod(
                                            offlineMethod: method,
                                            notify: false,
                                          );
                                          controller.buildOfflineInputControllers(notify: true);
                                        },
                                      )).toList(),
                              ),
                            ),
                          const SizedBox(height: Dimensions.padding24),

                          const OfflinePaymentForm(),
                        ],
                      ),
                    ),
                  ),
                  CheckoutBottomBar(
                    total: widget.amount,
                    originalTotal: widget.amount,
                    isLoading: controller.isLoading,
                    canConfirm: controller.selectedOfflineMethod != null,
                    buttonLabel: 'confirm_payment'.tr,
                    onConfirm: () => _submit(controller),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit(CheckoutController controller) async {
    final FormState? form = controller.offlineFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final bool isSubmitted = await controller.submitOfflinePaymentData(
      bookingId: widget.bookingId,
      isPartialPayment: widget.isPartialPayment,
    );
    if (!isSubmitted || !mounted) {
      return;
    }

    final SignUpBody? newUser = widget.newUserInfo;
    if (widget.createdAccount && newUser != null) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext _) => GuestPhoneVerificationSheet(userInfo: newUser),
      );
      return;
    }

    Get.offNamed(
      RouteHelper.getBookingSuccessRoute(
        readableId: widget.readableId,
        createdAccount: widget.createdAccount,
      ),
    );
  }

  void _confirmLeave() {
    Get.bottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.warning,
        title: 'incomplete_offline_payment'.tr,
        description: 'are_you_go_back_incomplete_offline_payment'.tr,
        noButtonText: 'cancel'.tr,
        yesButtonText: 'yes_go_back'.tr,
        onYesPressed: () => Get.offAllNamed(RouteHelper.getMainRoute('home')),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
    );
  }
}
