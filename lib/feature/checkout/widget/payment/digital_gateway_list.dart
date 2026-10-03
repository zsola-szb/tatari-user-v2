import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_radio_indicator.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class DigitalGatewayList extends StatelessWidget {
  final List<DigitalPaymentMethod> methods;
  final String? selectedGateway;
  final ValueChanged<DigitalPaymentMethod> onSelected;

  const DigitalGatewayList({super.key, required this.methods, required this.onSelected, this.selectedGateway});

  static List<DigitalPaymentMethod> gatewaysOf(List<DigitalPaymentMethod> methods) => methods
      .where((DigitalPaymentMethod method) => method.gateway != 'offline').toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final List<DigitalPaymentMethod> gateways = gatewaysOf(methods);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: gateways
          .map((DigitalPaymentMethod method) => PaymentMethodTile(
                label: method.label ?? 'digital_payment'.tr,
                logoUrl: method.gatewayImageFullPath,
                isSelected: selectedGateway != null && selectedGateway == method.gateway,
                onTap: () => onSelected(method))).toList(growable: false),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String label;
  final String? description;
  final String? logoUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.description,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String? logo = logoUrl;
    final String? note = description;

    return CustomInkWell(
      radius: 0,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding20,
          vertical: Dimensions.padding16,
        ),
        child: Row(
          children: <Widget>[
            if (logo != null && logo.isNotEmpty) ...<Widget>[
              CustomImage(image: logo, height: 24, width: 34, fit: BoxFit.contain),
              const SizedBox(width: Dimensions.padding10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: context.heading.defaultSize),
                  if (note != null && note.isNotEmpty) ...<Widget>[
                    const SizedBox(height: Dimensions.padding2),
                    Text(note, style: context.body.small),
                  ],
                ],
              ),
            ),
            const SizedBox(width: Dimensions.padding10),
            CheckoutRadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}