import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class MyAddressItem extends StatelessWidget {
  final AddressModel address;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const MyAddressItem({
    super.key,
    required this.address,
    required this.isDefault,
    required this.onTap,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  IconData _addressIcon() {
    switch (address.addressLabel?.toLowerCase()) {
      case 'home': return Icons.home_outlined;
      case 'office': return Icons.work_outline;
      default: return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius16),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(_addressIcon(), size: Dimensions.padding20, color: Theme.of(context).textTheme.bodyLarge?.color),
            const SizedBox(width: Dimensions.padding8),

            Expanded(child: Text((address.addressLabel ?? 'others').tr, style: context.heading.defaultSize)),

            if(isDefault)
              Container(
                decoration: BoxDecoration(
                  color: context.customThemeColors.success.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(Dimensions.radiusFull)
                ),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.padding6, vertical: Dimensions.padding2),
                child: Text('selected'.tr, style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: context.customThemeColors.success)),
              )
            else
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                  side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                ),
                surfaceTintColor: Theme.of(context).cardColor,
                position: PopupMenuPosition.under,
                padding: EdgeInsets.zero,
                elevation: 8,
                shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    height: 35,
                    onTap: onEditPressed,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.padding6),
                      Icon(Icons.edit_outlined, size: Dimensions.fontSizeLarge, color: context.customThemeColors.info),
                      const SizedBox(width: Dimensions.padding10),
                      Text('edit'.tr, style: context.subHeading.small),
                    ]),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    height: 35,
                    onTap: onDeletePressed,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.padding6),
                      Icon(Icons.delete_outline, size: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: Dimensions.padding10),
                      Text('delete'.tr, style: context.subHeading.small),
                    ]),
                  ),
                ],
                child: Icon(Icons.more_vert, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
              ),
          ]),
          const SizedBox(height: Dimensions.padding10),

          Divider(color: context.customThemeColors.secondaryBackGroundColor),

          Text(address.address ?? '', style: context.body.small, maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}
