import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_segmented_tabs.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingTypeTabs extends StatelessWidget {
  final bool isSingleBooking;
  final ValueChanged<bool> onChanged;

  const BookingTypeTabs({
    super.key,
    required this.isSingleBooking,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckoutSegmentedTabs(
      labels: <String>['only_once'.tr, 'multiple_times'.tr],
      selectedIndex: isSingleBooking ? 0 : 1,
      onChanged: (int index) => onChanged(index == 0),
    );
  }
}
