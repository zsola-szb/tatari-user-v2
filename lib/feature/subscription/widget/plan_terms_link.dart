import 'package:tatarigigs_user/feature/provider/widgets/pro_plan_terms_dialog_widget.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanTermsLink extends StatelessWidget {
  const PlanTermsLink({super.key});

  @override
  Widget build(BuildContext context) {
    final Color? linkColor = Theme.of(context).textTheme.bodyMedium?.color;

    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) => ProPlanTermsDialogWidget(
            scrollController: scrollController,
            isBottomSheet: true,
          ),
        ),
      ),
      child: Text(
        'terms_and_conditions'.tr,
        style: context.heading.small.copyWith(
          fontWeight: AppWeight.semiBold,
          color: linkColor,
          decoration: TextDecoration.underline,
          decorationColor: linkColor,
        ),
      ),
    );
  }
}
