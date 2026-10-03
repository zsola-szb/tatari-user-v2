import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/guest_phone_verification_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingSuccessScreen extends StatefulWidget {
  final String readableId;
  final String? token;
  final bool createdAccount;

  const BookingSuccessScreen({super.key, this.readableId = '', this.token, this.createdAccount = false});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveCallbackToken());
  }

  Future<void> _resolveCallbackToken() async {
    final CheckoutController controller = Get.find<CheckoutController>();

    if (widget.readableId.isNotEmpty) {
      controller.setBookingReadableId(widget.readableId);
    }

    final String? token = widget.token;
    if (token == null || token.isEmpty || token == 'null') {
      _maybeShowVerificationSheet(controller.pendingVerificationUser);
      return;
    }

    final String? decoded = CheckoutController.decodeToken(token);
    if (decoded == null) {
      return;
    }

    final String readableId = StringParser.parseString(decoded, 'attribute_id');
    if (readableId.isNotEmpty) {
      controller.setBookingReadableId(readableId);
    }

    final String transactionId = StringParser.parseString(decoded, 'transaction_reference');
    if (transactionId.isEmpty) {
      _maybeShowVerificationSheet(controller.pendingVerificationUser);
      return;
    }

    final CheckoutPaymentResponseModel? response = await controller.getDigitalPaymentResponse(transactionId: transactionId);
    final String? phone = response?.content?.newUserPhone;
    if (phone == null || phone.isEmpty) {
      return;
    }

    final String? loginToken = response?.content?.loginToken;
    final SignUpBody userInfo = SignUpBody(phone: phone);
    controller.handleGuestAccountToken(token: loginToken ?? '', userInfo: userInfo);
    _maybeShowVerificationSheet(userInfo);
  }

  void _maybeShowVerificationSheet(SignUpBody? userInfo) {
    if (userInfo == null || !mounted) {
      return;
    }
    Get.find<CheckoutController>().pendingVerificationUser = null;
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext _) => GuestPhoneVerificationSheet(userInfo: userInfo),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.padding24),
              child: GetBuilder<CheckoutController>(
                builder: (CheckoutController controller) {
                  final double proSavings = double.tryParse(controller.proDiscountAmount ?? '0') ?? 0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(Images.successIcon, width: 120, height: 120),
                      const SizedBox(height: Dimensions.padding20),
                      Text(
                        'you_placed_the_booking_successfully'.tr,
                        textAlign: TextAlign.center,
                        style: context.heading.extraLarge,
                      ),
                      if (controller.bookingReadableId.isNotEmpty) ...<Widget>[
                        const SizedBox(height: Dimensions.padding10),
                        Text(
                          '${'booking_id'.tr} ${controller.bookingReadableId}',
                          textAlign: TextAlign.center,
                          style: context.subHeading.defaultSize.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ],

                      // if (proSavings > 0) ...<Widget>[
                      //   const SizedBox(height: Dimensions.padding16),
                      //   _ProSavingsBox(amount: proSavings),
                      // ],

                      const SizedBox(height: Dimensions.padding24),
                      CustomButton(
                        buttonText: 'back_to_home'.tr,
                        width: 250,
                        radius: Dimensions.radius8,
                        onPressed: () => Get.offAllNamed(RouteHelper.getMainRoute('home')),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProSavingsBox extends StatelessWidget {
  final double amount;

  const _ProSavingsBox({required this.amount});

  @override
  Widget build(BuildContext context) {
    return CheckoutInfoBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(Images.premiumIcon, height: 18, width: 18),
          const SizedBox(width: Dimensions.padding6),
          Flexible(
            child: Text(
              '${'you_save'.tr} ${PriceConverter.convertPrice(amount)} ${'with_pro'.tr}',
              textAlign: TextAlign.center,
              style: context.heading.small,
            ),
          ),
        ],
      ),
    );
  }
}
