import 'package:tatarigigs_user/common/widgets/selectable_chip.dart';
import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanPackageSelector extends StatelessWidget {
  final List<Plans> plans;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PlanPackageSelector({
    super.key,
    required this.plans,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('select_package'.tr, style: context.heading.large.overrideWith(fontWeight: AppWeight.medium)),
        const SizedBox(height: Dimensions.padding10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.padding6),
          decoration: BoxDecoration(
            color: context.customThemeColors.secondaryBackGroundColor,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (int index = 0; index < plans.length; index++) ...<Widget>[
                  if (index > 0) const SizedBox(width: Dimensions.padding6),

                  SelectableChip(
                    label: plans[index].planName ?? '',
                    isSelected: selectedIndex == index,
                    onTap: () => onSelected(index),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
