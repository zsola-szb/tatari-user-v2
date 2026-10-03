import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletBannerView extends StatefulWidget {
  final BonusModel? bonusModel;
  const WalletBannerView({super.key, this.bonusModel}) ;

  @override
  State<WalletBannerView> createState() => _WalletBannerViewState();
}

class _WalletBannerViewState extends State<WalletBannerView> {
  final JustTheController _tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    BonusModel? bonusModel = widget.bonusModel;

    String bonusAmountText = bonusModel?.bonusAmountType == 'percent'
        ? '${bonusModel?.bonusAmount ?? '0'}%'
        : PriceConverter.convertPrice(double.tryParse(bonusModel?.bonusAmount ?? '0') ?? 0);

    String? minimumAddAmount = bonusModel?.minimumAddAmount;
    String? maximumBonusAmount = bonusModel?.maximumBonusAmount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        color: Theme.of(context).cardColor,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(bonusAmountText, style: context.heading.extraLarge, maxLines: 1, overflow: TextOverflow.ellipsis),

            Text(bonusModel?.bonusTitle ?? '', style: context.subHeading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),

            const SizedBox(height: Dimensions.padding8),

            if(bonusModel?.startDate != null && bonusModel?.endDate != null)
            Text(
              '${'validity'.tr} : ${DateConverter.stringToLocalDateOnly(bonusModel!.startDate!)} - ${DateConverter.stringToLocalDateOnly(bonusModel.endDate!)}',
              style: context.body.small,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),

        if(minimumAddAmount != null || maximumBonusAmount != null) ...[
          const SizedBox(width: Dimensions.padding8),

          JustTheTooltip(
            controller: _tooltipController,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 4,
            preferredDirection: AxisDirection.down,
            tailLength: 14, tailBaseWidth: 20,
            content: Padding(
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: SizedBox(
                width: 240,
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(bonusModel?.bonusTitle ?? '', style: context.subHeading.defaultSize.semiBold),
                  const SizedBox(height: Dimensions.padding8),

                  if(minimumAddAmount != null) _BonusInfoBullet(
                    text: '${'add_minimum_to_get_bonus'.tr} ${PriceConverter.convertPrice(double.tryParse(minimumAddAmount) ?? 0)}',
                  ),

                  if(maximumBonusAmount != null) _BonusInfoBullet(
                    text: '${'maximum_bonus_you_can_get'.tr} ${PriceConverter.convertPrice(double.tryParse(maximumBonusAmount) ?? 0)}',
                  ),
                ]),
              ),
            ),
            child: InkWell(
              onTap: () => _tooltipController.showTooltip(),
              child: Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 20),
            ),
          ),
        ],
      ]),
    );
  }
}

class _BonusInfoBullet extends StatelessWidget {
  final String text;
  const _BonusInfoBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 6, end: Dimensions.padding8),
          child: Icon(Icons.circle, size: 5, color: Theme.of(context).hintColor),
        ),
        Expanded(child: Text(text, style: context.body.small)),
      ]),
    );
  }
}
