import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingOfflineUpdateSheet extends StatefulWidget {
  final BookingDetailModel booking;

  const BookingOfflineUpdateSheet({super.key, required this.booking});

  static Future<void> open({required BookingDetailModel booking}) {
    return Get.bottomSheet(
      BookingOfflineUpdateSheet(booking: booking),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  State<BookingOfflineUpdateSheet> createState() => _BookingOfflineUpdateSheetState();
}

class _BookingOfflineUpdateSheetState extends State<BookingOfflineUpdateSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _inputs = <String, TextEditingController>{};

  CheckoutOfflineMethodModel? _method;
  bool _isLoadingMethods = true;

  @override
  void initState() {
    super.initState();
    _loadMethod();
  }

  Future<void> _loadMethod() async {
    final CheckoutController checkout = Get.find<CheckoutController>();
    if (checkout.offlineMethodList.isEmpty) {
      await checkout.loadOfflineMethodList(notify: false);
    }
    if (!mounted) {
      return;
    }

    final List<CheckoutOfflineMethodModel> methods = checkout.offlineMethodList;
    final String? bookingMethodId = widget.booking.payment.offlinePaymentId;

    setState(() {
      _method = methods.firstWhereOrNull(
            (CheckoutOfflineMethodModel item) => item.id == bookingMethodId,
          ) ?? (methods.isEmpty ? null : methods.first);
      _seedInputs();
      _isLoadingMethods = false;
    });
  }

  void _seedInputs() {
    final List<CheckoutOfflineCustomerInformation> fields =
        _method?.customerInformation ?? <CheckoutOfflineCustomerInformation>[];

    for (final CheckoutOfflineCustomerInformation field in fields) {
      final String key = field.fieldName ?? '';
      final BookingOfflinePaymentField? existing =
          widget.booking.payment.offlineFields.firstWhereOrNull(
        (BookingOfflinePaymentField saved) => saved.key == key,
      );
      _inputs[key] = TextEditingController(text: existing?.value ?? '');
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _inputs.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<BookingDetailsController>(
        builder: (BookingDetailsController controller) {
          if (_isLoadingMethods) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.padding32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final List<CheckoutOfflineCustomerInformation> fields =
              _method?.customerInformation ?? <CheckoutOfflineCustomerInformation>[];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('update_payment_info'.tr, style: context.heading.extraLarge),
                if ((_method?.methodName ?? '').isNotEmpty) ...<Widget>[
                  const SizedBox(height: Dimensions.padding4),
                  Text(_method!.methodName!, style: context.body.small),
                ],
                const SizedBox(height: Dimensions.padding20),
                if (fields.isEmpty)
                  Text('no_data_found'.tr, style: context.body.defaultSize)
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.45),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: fields
                              .map((CheckoutOfflineCustomerInformation field) => Padding(
                                    padding: const EdgeInsets.only(bottom: Dimensions.padding16),
                                    child: CustomTextField(
                                      title: field.label,
                                      hintText: field.hint,
                                      controller: _inputs[field.fieldName ?? ''],
                                      isShowBorder: true,
                                      isRequired: field.required,
                                      onValidate: field.required
                                          ? (String? value) => FormValidation()
                                              .validateDynamicTextFiled(value ?? '', field.label)
                                          : null,
                                    ),
                                  ))
                              .toList(growable: false),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: Dimensions.padding10),
                CustomButton(
                  buttonText: 'submit'.tr,
                  radius: Dimensions.radius8,
                  isLoading: controller.isProcessing,
                  onPressed: fields.isEmpty ? null : () => _submit(controller),
                ),
                const SizedBox(height: Dimensions.padding16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit(BookingDetailsController controller) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final Map<String, String> values = <String, String>{
      for (final MapEntry<String, TextEditingController> entry in _inputs.entries)
        entry.key: entry.value.text.trim(),
    };

    final bool submitted = await controller.submitOfflinePaymentData(
      offlinePaymentId: _method?.id ?? widget.booking.payment.offlinePaymentId ?? '',
      fields: values,
    );

    if (submitted) {
      Get.back<void>();
    }
  }
}
