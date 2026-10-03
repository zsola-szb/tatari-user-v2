import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CampaignInfoCard extends StatelessWidget {
  final CampaignData campaign;

  final int? categoryCount;

  const CampaignInfoCard({super.key, required this.campaign, this.categoryCount});

  @override
  Widget build(BuildContext context) {
    final String? minPurchase = campaign.minimumPurchaseAmount;
    final DateTime? validTill = campaign.validTillDate;
    final bool isCategoryAndMixedWise = campaign.isCategoryAndMixedWise;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius28)),
      ),
      padding: const EdgeInsets.all(Dimensions.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            child: CustomImage(
              image: campaign.thumbnailFullPath ?? '',
              height: 64,
              width: 64,
              placeholder: Images.placeholder,
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  campaign.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.heading.large.strong,
                ),

                if(minPurchase != null && minPurchase.isNotEmpty) ...<Widget>[
                  Gaps.verticalGapOf(Dimensions.padding2),
                  Row(children: <Widget>[
                    Text('${'min_purchase_amount'.tr} ', style: context.subHeading.small.overrideWith(color: context.customThemeColors.textColor)),

                    Flexible(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(minPurchase, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.subHeading.small.overrideWith(color: context.customThemeColors.textColor)),
                      ),
                    ),
                  ]),
                ],

                Gaps.verticalGapOf(Dimensions.padding10),
                Wrap(
                  spacing: Dimensions.padding16,
                  runSpacing: Dimensions.padding6,
                  children: <Widget>[
                    if(isCategoryAndMixedWise) ...<Widget>[
                      if(categoryCount != null)
                        CampaignMetaItem(
                          icon: SvgPicture.asset(
                            Images.category,
                            width: 14, height: 14,
                            colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn),
                          ),
                          label: '$categoryCount ${'categories'.tr}',
                        ),
                    ] else
                      CampaignMetaItem(
                        icon: SvgPicture.asset(
                          Images.service,
                          width: 14, height: 14,
                          colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn),
                        ),
                        label: '${campaign.serviceCount ?? 0} ${'services'.tr}',
                      ),

                    if(validTill != null)
                      CampaignMetaItem(
                        icon: Image.asset(Images.calendar2, width: 14, height: 14),
                        label: '${'valid_till'.tr} – ${DateConverter.dateStringMonthYear(validTill)}',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CampaignMetaItem extends StatelessWidget {
  final Widget icon;
  final String label;
  const CampaignMetaItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        Gaps.horizontalGapOf(Dimensions.padding6),
        Text(label, style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor, fontWeight: AppWeight.regular)),
      ],
    );
  }
}