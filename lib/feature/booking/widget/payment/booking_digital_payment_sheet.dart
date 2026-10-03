import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/digital_gateway_list.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingDigitalPaymentSheet extends StatefulWidget {
  final BookingDetailModel booking;

  const BookingDigitalPaymentSheet({super.key, required this.booking});

  static Future<void> open({required BookingDetailModel booking}) {
    return Get.bottomSheet(
      BookingDigitalPaymentSheet(booking: booking),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  State<BookingDigitalPaymentSheet> createState() => _BookingDigitalPaymentSheetState();
}

class _BookingDigitalPaymentSheetState extends State<BookingDigitalPaymentSheet> {
  static const double _contentInset = Dimensions.padding20;
  String? _selectedGateway;

  List<DigitalPaymentMethod> get _gateways {
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    if (config == null || config.digitalPayment != 1) {
      return const <DigitalPaymentMethod>[];
    }
    return DigitalGatewayList.gatewaysOf(
      config.paymentMethodList ?? const <DigitalPaymentMethod>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DigitalPaymentMethod> gateways = _gateways;

    return BaseBottomSheet(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _contentInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${'total_amount'.tr}  ${PriceConverter.convertPrice(widget.booking.payment.displayAmount)}',
                        style: context.heading.large,
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding20),
                  Text('pay_via_online'.tr, style: context.heading.defaultSize),
                  const SizedBox(height: Dimensions.padding4),
                  Text(
                    'faster_and_secure_way_to_pay_bill'.tr,
                    style: context.body.small,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.padding12),
            if (gateways.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _contentInset,
                  vertical: Dimensions.padding20,
                ),
                child: Text(
                  'no_payment_method_available'.tr,
                  style: context.body.defaultSize,
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                child: SingleChildScrollView(
                  child: DigitalGatewayList(
                    methods: gateways,
                    selectedGateway: _selectedGateway,
                    onSelected: (DigitalPaymentMethod method) =>
                        setState(() => _selectedGateway = method.gateway),
                  ),
                ),
              ),
            const SizedBox(height: Dimensions.padding16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _contentInset),
              child: CustomButton(
                buttonText: 'complete_payment'.tr,
                radius: Dimensions.radius8,
                onPressed: gateways.isEmpty ? null : _pay,
              ),
            ),
            const SizedBox(height: Dimensions.padding20),
          ],
        ),
      ),
    );
  }

  void _pay() {
    final String? gateway = _selectedGateway;
    if (gateway == null) {
      customSnackBar('select_payment_method'.tr, type: ToasterMessageType.info, showDefaultSnackBar: false);
      return;
    }

    final String url = Get.find<BookingDetailsController>().buildPaymentUrl(gateway: gateway);

    Get.back<void>();
    Get.to<void>(() => BookingPaymentWebviewScreen(url: url));
  }
}
