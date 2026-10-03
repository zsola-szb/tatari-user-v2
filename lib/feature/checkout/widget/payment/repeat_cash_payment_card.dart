import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_row.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatCashPaymentCard extends StatelessWidget {
  const RepeatCashPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('payment_method'.tr, style: context.heading.defaultSize),
          const SizedBox(height: Dimensions.padding16),
          PaymentMethodRow(
            label: 'cash_after_service'.tr,
            assetIcon: Images.cod,
          ),
          const SizedBox(height: Dimensions.padding6),
          Text('pay_for_each_service_after_it_is_completed'.tr,
            style: context.body.small,
          ),
        ],
      ),
    );
  }
}
