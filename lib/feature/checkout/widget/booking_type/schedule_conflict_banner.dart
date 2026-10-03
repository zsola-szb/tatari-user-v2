import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_info_box.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ScheduleConflictBanner extends StatelessWidget {
  final String message;

  const ScheduleConflictBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CheckoutInfoBox(
      tone: CheckoutInfoTone.error,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 18,
            color: context.customThemeColors.error,
          ),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: Text(message, style: context.subHeading.small),
          ),
        ],
      ),
    );
  }
}
