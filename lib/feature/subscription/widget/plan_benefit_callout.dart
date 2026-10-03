import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';

class PlanBenefitCallout extends StatelessWidget {
  final String title;
  final String subtitle;

  const PlanBenefitCallout({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: context.customThemeColors.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(Dimensions.padding6),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
            child: Icon(Icons.check, size: 14, color: context.customThemeColors.success),
          ),
          const SizedBox(width: Dimensions.padding10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: context.heading.small),
                const SizedBox(height: Dimensions.padding2),

                Text(subtitle, style: context.body.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
