import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletTopCard extends StatelessWidget {
  final JustTheController tooltipController;
  const WalletTopCard({super.key, required this.tooltipController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController){

      double walletBalance = walletController.walletTransactionModel?.content?.walletBalance ?? 0;
      bool canAddFund = Get.find<SplashController>().configModel.content?.addFundToWallet == 1;

      return Container(
        margin: const EdgeInsets.all(Dimensions.padding16),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.85)],
          ),
        ),
        child: Row(children: [
          Image.asset(Images.walletSmall, width: 28, height: 28, color: Theme.of(context).cardColor),
          const SizedBox(width: Dimensions.padding12),

          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('your_balance'.tr, style: context.body.small.overrideWith(color: Theme.of(context).cardColor)),
            const SizedBox(height: Dimensions.padding4),

            Row(children: [
              Directionality(textDirection: TextDirection.ltr,
                child: Text(PriceConverter.convertPrice(walletBalance),
                  style: context.heading.large.overrideWith(color: Theme.of(context).cardColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Dimensions.padding10),

              if(canAddFund) JustTheTooltip(
                backgroundColor: Colors.black87, controller: tooltipController,
                preferredDirection: AxisDirection.down, tailLength: 14, tailBaseWidth: 20,
                content: Padding(padding: const EdgeInsets.all(Dimensions.padding16),
                  child: Text("add_fund_instruction".tr, style: context.body.defaultSize.overrideWith(color: Theme.of(context).cardColor)),
                ),
                child: InkWell(onTap: () => tooltipController.showTooltip(),
                  child: Icon(Icons.info_outline_rounded, color: Theme.of(context).cardColor, size: 16),
                ),
              ),
            ]),
          ]),

          const Spacer(),

          if(canAddFund) const SizedBox(width: Dimensions.padding10),

          if(canAddFund) InkWell(
            onTap: () => _openAddFundDialog(),
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).cardColor, width: 2)),
              child: Icon(Icons.add_rounded, color: Theme.of(context).cardColor, size: 18),
            ),
          ),
        ]),
      );
    });
  }

  void _openAddFundDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
        ),
        child: const PaymentMethodListWidget(),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
