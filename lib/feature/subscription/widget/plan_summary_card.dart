import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/feature/subscription/widget/plan_benefit_callout.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/price_converter.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanSummaryCard extends StatelessWidget {
  final Plans plan;
  final String benefitText;

  const PlanSummaryCard({super.key, required this.plan, required this.benefitText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: context.customThemeColors.secondaryBackGroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: Column(
        children: <Widget>[
          Image.asset(Images.premiumIcon, height: 40, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: Dimensions.padding6),

          Text('pro_member'.tr, style: context.heading.large),
          const SizedBox(height: Dimensions.padding2),

          Text('save_more_on_every_booking'.tr, style: context.body.small),
          const SizedBox(height: Dimensions.padding20),

          _PlanDurationPriceRow(plan: plan),
          const SizedBox(height: Dimensions.padding16),

          PlanBenefitCallout(title: benefitText, subtitle: 'applied_automatically_at_checkout'.tr),
        ],
      ),
    );
  }
}

class _PlanDurationPriceRow extends StatelessWidget {
  final Plans plan;

  const _PlanDurationPriceRow({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('duration'.tr, style: context.body.small),
              const SizedBox(height: Dimensions.padding2),

              Text('${plan.durationDays ?? 0} ${'days'.tr}', style: context.heading.defaultSize),
            ],
          ),
          const SizedBox(width: Dimensions.padding10),

          Flexible(
            child: Text(
              PriceConverter.convertPrice(plan.price ?? 0),
              style: context.heading.overLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
