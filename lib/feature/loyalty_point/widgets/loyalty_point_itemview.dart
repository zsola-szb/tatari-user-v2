import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointItemView extends StatelessWidget {
  final LoyaltyPointTransactionData transactionData;
  const  LoyaltyPointItemView({super.key, required this.transactionData}) ;

  @override
  Widget build(BuildContext context) {
    bool isCredit;

    if(transactionData.credit!=null && transactionData.credit!>0){
      isCredit = true;
    }else{
      isCredit = false;
    }

    Color amountColor = isCredit ? context.customThemeColors.success : context.customThemeColors.error;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Row(children: [
        Text.rich(
          TextSpan(children: [
            TextSpan(text: transactionData.debit!=0?"- ${transactionData.debit}":"+ ${transactionData.credit}",
              style: context.heading.large.overrideWith(color: amountColor),
            ),
            TextSpan(text: ' ${'point'.tr}', style: context.heading.large),
          ]),
          textDirection: TextDirection.ltr,
        ),

        const Spacer(),

        Text(DateConverter.isoUtcStringToDashDateOnly(transactionData.createdAt!),
          textDirection: TextDirection.ltr,
          style: context.body.small,
        ),
      ]),

      const SizedBox(height: Dimensions.padding6),

      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text(isCredit ? "earned_from_booking".tr : "converted_wallet_money".tr, style: context.body.defaultSize, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: Dimensions.padding8),

        Flexible(
          child: Tooltip(
            message: transactionData.id,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('${'trx_id'.tr} : ', style: context.subHeading.small),
              Flexible(child: Text('${transactionData.id}', overflow: TextOverflow.ellipsis, style: context.subHeading.small)),
            ]),
          ),
        ),
      ]),
    ]);
  }
}
