import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletListItem extends StatelessWidget {
  final LoyaltyPointTransactionData transactionData;
  const  WalletListItem({super.key, required this.transactionData}) ;

  @override
  Widget build(BuildContext context) {

    String transactionType;
    if(transactionData.toUserAccount!=null && transactionData.toUserAccount == "balance_pending"){
      transactionType = transactionData.toUserAccount!.tr;
    }else{
      transactionType = transactionData.trxType.toString().tr;
    }

    bool isDebit = transactionData.debit!=null && transactionData.debit != 0;
    double transactionAmount = isDebit ? transactionData.debit ?? 0 : transactionData.credit ?? 0;
    Color amountColor = isDebit ? context.customThemeColors.error : context.customThemeColors.success;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(children: [
        Icon(Icons.paid_outlined, color: amountColor, size: 18),

        const SizedBox(width: Dimensions.padding10),

        Text.rich(
          TextSpan(text: isDebit ? "- ${PriceConverter.convertPrice(transactionAmount).replaceAll("-", "")}" : "+ ${PriceConverter.convertPrice(transactionAmount)}",
            style: context.heading.large,
          ),
          textDirection: TextDirection.ltr,
        ),

        const Spacer(),

        Text(DateConverter.isoUtcStringToDashDateOnly(transactionData.createdAt!),
          textDirection: TextDirection.ltr,
          style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
        ),
      ]),

      const SizedBox(height: Dimensions.padding6),

      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text(transactionType, style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor), overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: Dimensions.padding8),

        Flexible(
          child: Tooltip(
            message: transactionData.id,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('XID'.tr, style: context.subHeading.small),
              Text(': '.tr, style: context.subHeading.small),
              Flexible(child: Text('${transactionData.id}', overflow: TextOverflow.ellipsis, style: context.subHeading.small)),
            ]),
          ),
        ),
      ]),
    ]);
  }
}
