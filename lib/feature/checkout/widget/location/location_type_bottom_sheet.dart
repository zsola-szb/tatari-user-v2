import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_radio_indicator.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LocationTypeBottomSheet extends StatelessWidget {
  final ServiceLocationType current;
  final ValueChanged<ServiceLocationType> onSelected;

  const LocationTypeBottomSheet({
    super.key,
    required this.current,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('get_service_at'.tr, style: context.heading.large),
            const SizedBox(height: Dimensions.padding16),
            _LocationTypeOption(
              label: 'my_location'.tr,
              description: 'service_at_my_location_hint'.tr,
              isSelected: current == ServiceLocationType.customer,
              onTap: () => _select(ServiceLocationType.customer),
            ),
            Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
            _LocationTypeOption(
              label: 'provider_location'.tr,
              description: 'service_at_provider_location_hint'.tr,
              isSelected: current == ServiceLocationType.provider,
              onTap: () => _select(ServiceLocationType.provider),
            ),
          ],
        ),
      ),
    );
  }

  void _select(ServiceLocationType type) {
    Get.back();
    onSelected(type);
  }
}

class _LocationTypeOption extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationTypeOption({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: context.heading.defaultSize),
                const SizedBox(height: Dimensions.padding2),
                Text(description, style: context.body.small),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          CheckoutRadioIndicator(isSelected: isSelected),
        ],
      ),
    );
  }
}
