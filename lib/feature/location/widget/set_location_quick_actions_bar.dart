import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationQuickActionsBar extends StatelessWidget {
  final VoidCallback onSetOnMap;
  final VoidCallback onCurrentLocationTap;

  const SetLocationQuickActionsBar({
    super.key,
    required this.onSetOnMap,
    required this.onCurrentLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(Dimensions.radius16), right: Radius.circular(Dimensions.radius16))
      ),
      padding: EdgeInsets.only(
        top: Dimensions.padding12,
        bottom: MediaQuery.of(context).padding.bottom + Dimensions.padding12,
      ),
      child: Row(
        children: [
          Expanded(
            child: SetLocationQuickAction(
              icon: Icons.map_outlined,
              label: 'set_on_map'.tr,
              onTap: onSetOnMap,
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
          ),
          Expanded(
            child: SetLocationQuickAction(
              icon: Icons.my_location,
              label: 'current_location'.tr,
              onTap: onCurrentLocationTap,
            ),
          ),
        ],
      ),
    );
  }
}
