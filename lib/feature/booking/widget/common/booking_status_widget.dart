import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingStatusWidget extends StatelessWidget {
  final String status;

  const BookingStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final CustomThemeColors colors = context.customThemeColors;
    final Color background = colors.buttonBackgroundColorMap[status] ?? Theme.of(context).hintColor.withValues(alpha: 0.10);
    final Color foreground = colors.buttonTextColorMap[status] ?? context.customThemeColors.secondaryTextColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding8, vertical: Dimensions.padding2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        border: Border.all(color: foreground)
      ),
      child: Text(
        status.isEmpty ? '' : status.tr,
        style: context.subHeading.small.medium.copyWith(color: foreground),
      ),
    );
  }
}
