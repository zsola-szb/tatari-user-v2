import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_add_button.dart';
import 'package:tatarigigs_user/feature/checkout/widget/guest/contact_info_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/service_location_row.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class GuestContactSection extends StatelessWidget {
  const GuestContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (CheckoutController controller) {
        return GetBuilder<UserController>(
          builder: (UserController _) {
            final String name = controller.contactName;
            final String phone = controller.contactPhone;

            if (name.isEmpty || phone.isEmpty) {
              return CheckoutAddButton(
                label: 'add_contact_info'.tr,
                onTap: () => _openSheet(context, controller, name: name, phone: phone),
              );
            }

            return ServiceLocationRow(
              icon: Icons.person_outline_rounded,
              title: name,
              subtitle: phone,
              forceLtrSubtitle: true,
              onEdit: () => _openSheet(context, controller, name: name, phone: phone),
            );
          },
        );
      },
    );
  }

  void _openSheet(BuildContext context, CheckoutController controller, {required String name, required String phone}) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext _) => ContactInfoBottomSheet(
        initialName: name,
        initialPhone: phone,
        onSaved: controller.syncAddressFromLocationController,
      ),
    );
  }
}
