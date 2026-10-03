import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PlanDetailRow({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).hintColor),
          const SizedBox(width: Dimensions.padding12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.tr, style: context.body.small),
                const SizedBox(height: Dimensions.padding2),

                Text(value.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
