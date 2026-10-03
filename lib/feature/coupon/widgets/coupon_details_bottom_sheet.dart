import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CouponDetailsBottomSheet extends StatelessWidget {
  final CouponModel couponModel;
  final bool isExpired;
  final Function()? onUseNow;
  const CouponDetailsBottomSheet({super.key, required this.couponModel, required this.isExpired, this.onUseNow});

  @override
  Widget build(BuildContext context) {
    List<String> requirements = [
      if ((couponModel.discount?.minPurchase ?? 0) > 0)
        '${'minimum_purchase'.tr} ${PriceConverter.convertPrice(couponModel.discount?.minPurchase ?? 0)}',
      if ((couponModel.discount?.maxDiscountAmount ?? 0) > 0)
        '${'maximum_discount_up_to'.tr} ${PriceConverter.convertPrice(couponModel.discount?.maxDiscountAmount?.toDouble() ?? 0)}',
      if ((couponModel.discount?.limitPerUser ?? 0) > 0)
        '${'maximum'.tr} ${couponModel.discount?.limitPerUser} ${'redemptions_per_user'.tr}',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Theme.of(context).primaryColorDark : Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20), bottom: Radius.circular(0)),
        boxShadow: cardShadow,
      ),

      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.padding8, right: Dimensions.padding8),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.padding6),
                  decoration: BoxDecoration(color: context.customThemeColors.secondaryBackGroundColor, shape: BoxShape.circle),
                  child: Icon(Icons.close, size: Dimensions.fontSizeDefault, color: context.customThemeColors.textColor),
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(Dimensions.padding20).copyWith(top: 0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 60, width: 60,
                decoration: BoxDecoration(shape: BoxShape.circle, color: context.customThemeColors.secondaryBackGroundColor),
                child: Image.asset(Images.voucherImage),
              ),
              const SizedBox(height: Dimensions.padding16),

              Text(
                couponModel.discount?.discountTitle ?? '',
                textAlign: TextAlign.center,
                style: context.heading.defaultSize,
              ),
              const SizedBox(height: Dimensions.padding4),

              Text(
                '${isExpired ? 'expired_on'.tr : 'valid_till'.tr} : ${couponModel.discount?.endDate ?? ''}',
                textAlign: TextAlign.center,
                style: context.body.small,
              ),
              const SizedBox(height: Dimensions.padding20),

              Container(
                decoration: BoxDecoration(
                  color: context.customThemeColors.backGroundColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius12)
                ),
                padding: EdgeInsets.all(Dimensions.padding12),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
                      color: Theme.of(context).cardColor
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Flexible(
                        child: Text(
                          PriceConverter.percentageOrAmount('${couponModel.discount?.discountAmount ?? 0}', couponModel.discount?.discountAmountType ?? 'percent'),
                          style: context.heading.large,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding8),

                      DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(Dimensions.radius6),
                          color: Theme.of(context).colorScheme.primary,
                          dashPattern: const [4, 3],
                          strokeWidth: 1,
                          padding: EdgeInsets.zero,
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [

                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding6),
                              child: Text(
                                couponModel.couponCode ?? '',
                                style: context.body.extraSmall.overrideWith(color: Theme.of(context).colorScheme.primary, fontWeight: AppWeight.medium),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: couponModel.couponCode ?? ''));
                              customSnackBar('coupon_code_copied'.tr, type: ToasterMessageType.success);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius6), bottomRight: Radius.circular(Dimensions.radius6))
                              ),
                              child: Text(
                                'copy'.tr,
                                style: context.body.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.medium),
                              ),
                            ),
                          ),

                        ]),
                      ),

                    ]),
                  ),

                  if (requirements.isNotEmpty) ...[
                    const SizedBox(height: Dimensions.padding20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('requirement'.tr, style: context.heading.defaultSize),
                    ),

                    const SizedBox(height: Dimensions.padding10),

                    Column(children: requirements.map((requirement) => Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.padding8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.padding8),
                          child: Container(
                            height: 5, width: 5,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding10),
                        Expanded(child: Text(requirement, style: context.body.defaultSize)),
                      ]),
                    )).toList()),
                  ],
                ]),
              ),

              if (onUseNow != null) ...[
                const SizedBox(height: Dimensions.padding20),

                CustomButton(
                  buttonText: 'use_now'.tr,
                  height: 45,
                  radius: Dimensions.radius12,
                  onPressed: () {
                    Get.back();
                    onUseNow!();
                  },
                ),
              ],

            ]),
          ),
        ]),
      ),
    );
  }
}
