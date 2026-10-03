import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ConvertLoyaltyPointBottomSheet extends StatelessWidget {

  const ConvertLoyaltyPointBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyPointController>(builder: (loyaltyPointController){

      double availablePoint = loyaltyPointController.loyaltyPointModel?.content?.loyaltyPoint ?? 0;
      String pointValuePerCurrencyUnit = loyaltyPointController.loyaltyPointModel?.content?.loyaltyPointValuePerCurrencyUnit ?? '0';

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.padding10).copyWith(bottom: 0),
              child: Align(
                alignment: Alignment.centerRight,
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

              Padding(
                padding: const EdgeInsets.all(Dimensions.padding20).copyWith(top: 0),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(
                    child: Container(
                      width: 45, height: 45,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffFFA726)),
                      child: const Icon(Icons.star_rounded, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding16),

                  Center(child: Text('convert_points_to_wallet_balance'.tr, style: context.heading.large, textAlign: TextAlign.center)),
                  const SizedBox(height: Dimensions.padding6),

                  Center(child: Text('convert_point_wallet_subtitle'.tr, style: context.body.small, textAlign: TextAlign.center)),
                  const SizedBox(height: Dimensions.padding16),

                  Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: '${'available_point'.tr} : ', style: context.heading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.primary)),
                        TextSpan(text: availablePoint.toStringAsFixed(0), style: context.heading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.primary)),
                      ])),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding20),

                  Text('point_amount'.tr, style: context.subHeading.small),
                  const SizedBox(height: Dimensions.padding8),

                  TextFormField(
                    controller: loyaltyPointController.loyaltyPointController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    style: context.subHeading.defaultSize,
                    decoration: InputDecoration(
                      hintText: 'enter_point'.tr,
                      hintStyle: context.body.defaultSize,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius8), borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.3))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius8), borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.3))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius8), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(height: Dimensions.padding8),

                  Text('$pointValuePerCurrencyUnit ${'points'.tr} = ${PriceConverter.convertPrice(1)}', style: context.body.small),
                  const SizedBox(height: Dimensions.padding24),

                  loyaltyPointController.isLoading== false?
                  CustomButton(
                    buttonText: "convert_to_currency".tr,
                    assetIcon: Images.convertPoint,
                    radius: Dimensions.radius8,
                    onPressed: (){
                      double inputAmount = double.tryParse(loyaltyPointController.loyaltyPointController.text)??0;
                      double availAblePoint = loyaltyPointController.loyaltyPointModel?.content?.loyaltyPoint??0;
                      double minimumConvertAblePoint = double.tryParse(loyaltyPointController.loyaltyPointModel?.content?.minLoyaltyPointToTransfer??"0")??0;

                      if(loyaltyPointController.loyaltyPointController.text.isEmpty){
                        customSnackBar('enter_point_amount'.tr, showDefaultSnackBar: false);
                      }else if(inputAmount> availAblePoint){
                        customSnackBar('insufficient_point_amount'.tr, showDefaultSnackBar: false);
                      }else if(inputAmount < minimumConvertAblePoint){
                        customSnackBar('${"minimum_convert_able_point".tr} $minimumConvertAblePoint'.tr, showDefaultSnackBar: false);
                      } else{
                        loyaltyPointController.convertLoyaltyPoint();
                      }
                    },
                  ):const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: Dimensions.padding10),
                ]),
              ),
          ]),
        ),
      );
    });
  }
}
