import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationAddressRow extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onTap;

  const SetLocationAddressRow({
    super.key,
    required this.address,
    required this.onTap,
  });

  IconData _icon() {
    switch (address.addressLabel?.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius8,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Row(
          children: [
            Icon(
              _icon(),
              color: context.customThemeColors.secondaryTextColor,
              size: Dimensions.fontSizeLarge,
            ),
            const SizedBox(width: Dimensions.padding12),
            Expanded(
              child: Text(
                address.address ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.body.defaultSize.overrideWith(
                  color: context.customThemeColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
