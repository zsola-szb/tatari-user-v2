import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class GuestCreateAccountSection extends StatelessWidget {
  const GuestCreateAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return CheckoutSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('create_account_with_existing_info'.tr, style: context.heading.defaultSize),
                        const SizedBox(height: Dimensions.padding2),

                        Text('your_provided_contact_info_user_as'.tr, style: context.body.small),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: controller.isCreateAccount,
                      activeColor: Theme.of(context).colorScheme.primary,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radius4),
                      ),
                      onChanged: (bool? value) =>
                          controller.toggleCreateAccount(value: value ?? false),
                    ),
                  ),
                ],
              ),

              if (controller.isCreateAccount) ...<Widget>[
                const SizedBox(height: Dimensions.padding20),
                CustomTextField(
                  title: 'password'.tr,
                  hintText: '****************',
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocus,
                  nextFocus: controller.confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  isPassword: true,
                  isShowBorder: true,
                  onValidate: (String? value) =>
                      FormValidation().isValidPassword(value ?? ''),
                ),
                const SizedBox(height: Dimensions.padding20),
                CustomTextField(
                  title: 'confirm_password'.tr,
                  hintText: '****************',
                  controller: controller.confirmPasswordController,
                  focusNode: controller.confirmPasswordFocus,
                  inputType: TextInputType.visiblePassword,
                  inputAction: TextInputAction.done,
                  isPassword: true,
                  isShowBorder: true,
                  onValidate: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'this_field_can_not_empty'.tr;
                    }
                    return FormValidation().isValidConfirmPassword(
                      controller.passwordController.text,
                      controller.confirmPasswordController.text,
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
