import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OfflinePaymentForm extends StatelessWidget {
  const OfflinePaymentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        final List<CheckoutOfflineCustomerInformation> fields =
            controller.selectedOfflineMethod?.customerInformation ??
                <CheckoutOfflineCustomerInformation>[];
        final List<TextEditingController> inputs = controller.offlineInputControllers;

        if (fields.isEmpty || inputs.length != fields.length) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('payment_info'.tr, style: context.heading.extraLarge),
            const SizedBox(height: Dimensions.padding16),
            Form(
              key: controller.offlineFormKey,
              child: Column(
                children: List<Widget>.generate(
                  fields.length,
                  (int index) => Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.padding20),
                    child: CustomTextField(
                      title: fields[index].label,
                      hintText: fields[index].hint,
                      controller: inputs[index],
                      isShowBorder: true,
                      isRequired: fields[index].required,
                      inputAction: index == fields.length - 1 ? TextInputAction.done : TextInputAction.next,
                      onValidate: fields[index].required
                          ? (String? value) => FormValidation().validateDynamicTextFiled(value ?? '', fields[index].label) : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
