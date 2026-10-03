import 'dart:convert';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class PaymentMethodListWidget extends StatefulWidget {
  const PaymentMethodListWidget({super.key}) ;

  @override
  State<PaymentMethodListWidget> createState() => _PaymentMethodListWidgetState();
}

class _PaymentMethodListWidgetState extends State<PaymentMethodListWidget> {

  final TextEditingController inputAmountController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isTextFieldEmpty = true;


  @override
  void initState() {
    super.initState();
    Get.find<WalletController>().isTextFieldEmpty('', isUpdate: false);
    Get.find<WalletController>().changeDigitalPaymentName('', isUpdate: false);
  }


  @override
  Widget build(BuildContext context) {

    bool isRightSide = Get.find<SplashController>().configModel.content?.currencySymbolPosition == 'right';

    List<DigitalPaymentMethod> paymentMethodList = Get.find<SplashController>().configModel.content?.paymentMethodList ?? [];

    if(paymentMethodList.isNotEmpty && paymentMethodList.length ==1){
      Get.find<WalletController>().changeDigitalPaymentName(paymentMethodList[0].gateway??"",isUpdate: false);
    }

    return GetBuilder<WalletController>(builder: (walletController){
      return SizedBox(width: Dimensions.webMaxWidth/2,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.padding10).copyWith(bottom: 0),
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

         Padding(
           padding: const EdgeInsets.all(Dimensions.padding16).copyWith(top: 0),
           child: Column(mainAxisSize: MainAxisSize.min, children: [
             Text('add_fund_to_wallet'.tr, style: context.heading.large),
             const SizedBox(height: Dimensions.padding10),

             Text('add_fund_form_secured_digital_payment_gateways'.tr, style: context.subHeading.small, textAlign: TextAlign.center),
             const SizedBox(height: Dimensions.padding20),

             Container(
               decoration: BoxDecoration(
                 border: Border.all(color: Theme.of(context).colorScheme.primary),
                 borderRadius: BorderRadius.circular(Dimensions.radius12),
               ),
               padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20, vertical: Dimensions.padding10),
               child: Center(
                 child: Row(mainAxisAlignment : MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     const Expanded(child: SizedBox()),
                     if(!isRightSide)
                       Text(PriceConverter.getCurrency(),
                         style:context.heading.overLarge.overrideWith(
                           color: isTextFieldEmpty
                               ? Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5)
                               :Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                         ),
                       ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 4),
                       child: IntrinsicWidth(
                         child: TextField(
                           inputFormatters: [
                             LengthLimitingTextInputFormatter(20),
                           ],
                           keyboardType: TextInputType.number,
                           controller: inputAmountController,
                           focusNode: focusNode,
                           textAlignVertical: TextAlignVertical.center,
                           textAlign: TextAlign.center,
                           maxLines: 1,
                           decoration: InputDecoration(
                             border : InputBorder.none,
                             isCollapsed: true,
                             hintText: "0.0",
                             hintStyle: context.heading.overLarge.overrideWith(
                               color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5),
                             ),
                             contentPadding: const EdgeInsets.only(bottom: 0),
                           ),
                           style: context.heading.overLarge.overrideWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8)),
                           onChanged: (String value){
                             walletController.isTextFieldEmpty(value);
                             setState(() {
                               if(value.isNotEmpty){
                                 isTextFieldEmpty = false;
                               }else{
                                 isTextFieldEmpty = true;
                               }
                             });
                           },
                         ),
                       ),
                     ),
                     if(isRightSide)
                       Text(PriceConverter.getCurrency(),
                         style: context.heading.overLarge.overrideWith(
                           color: isTextFieldEmpty ?
                           Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5) :
                           Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
                         ),
                       ),

                     const Expanded(child: SizedBox()),
                   ],
                 ),
               ),
             ),


             const SizedBox(height: Dimensions.padding20),

             walletController.amountEmpty ? Row(children: [
               Text('payment_method'.tr, style: context.heading.large),
               const SizedBox(width: Dimensions.padding6),

               Expanded(child: Text('faster_and_secure_way_to_pay_bill'.tr, style: context.heading.small.overrideWith(color: Theme.of(context).hintColor))),
             ]) : const SizedBox(),
             const SizedBox(height: Dimensions.padding10),

             walletController.amountEmpty? ConstrainedBox(
               constraints: BoxConstraints(maxHeight: Get.height  * 0.4, minHeight: 100),
               child: paymentMethodList.isNotEmpty ? ListView.builder(
                 itemCount: paymentMethodList.length,
                 shrinkWrap: true,
                 padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
                 itemBuilder: (context, index){
                   bool isSelected =  paymentMethodList.length == 1 || (paymentMethodList[index].gateway == walletController.digitalPaymentName);
                   return InkWell(
                     onTap: (){
                       walletController.changeDigitalPaymentName(paymentMethodList[index].gateway ?? "");
                     },
                     child: Container(
                       decoration: BoxDecoration(
                           color: isSelected ? Colors.blue.withValues(alpha: 0.05) : Colors.transparent,
                           borderRadius: BorderRadius.circular(Dimensions.radius12)
                       ),
                       padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding20),
                       child: Row(children: [
                         Container(
                           height: 20, width: 20,
                           decoration: BoxDecoration(
                               shape: BoxShape.circle, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                               border: Border.all(color: Theme.of(context).disabledColor)
                           ),
                           child: Icon(Icons.check, color: isSelected ? Colors.white70 : Colors.transparent, size: 16),
                         ),
                         const SizedBox(width: Dimensions.padding16),

                         CustomImage(
                           height: Dimensions.padding20, fit: BoxFit.contain,
                           image: paymentMethodList[index].gatewayImageFullPath ??"",
                         ),

                         const SizedBox(width: Dimensions.padding10),

                         Text( paymentMethodList[index].label ?? "",
                           style: context.subHeading.defaultSize.overrideWith(fontWeight: FontWeight.w500),
                         ),
                       ]),
                     ),
                   );
                 },
               ) : Padding(padding: const EdgeInsets.symmetric( vertical : Dimensions.padding20 * 2),
                 child: Text("no_payment_method_available".tr,style: context.subHeading.large.overrideWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.error),
                 ),
               ),
             ) : const SizedBox(),
             const SizedBox(height: Dimensions.padding20),

             !walletController.isLoading ? CustomButton(
               buttonText: 'add_fund'.tr,
               onPressed: (){
                 if(inputAmountController.text.isEmpty){
                   customSnackBar('please_provide_transfer_amount'.tr, showDefaultSnackBar: false, type: ToasterMessageType.info);
                 }else if(walletController.digitalPaymentName == ''){
                   customSnackBar('please_select_payment_method'.tr,  showDefaultSnackBar: false,  type: ToasterMessageType.info);
                 }else{
                   double? amount = double.tryParse(inputAmountController.text.replaceAll(PriceConverter.getCurrency(), ''));

                   if(amount != null && amount > 0){
                     Get.back();
                     _addFundToWallet(walletController.digitalPaymentName ?? "", amount );
                   }else if( amount != null && amount <= 0 ){
                     customSnackBar('amount_must_be_greater_than_zero'.tr,  showDefaultSnackBar: false,  type: ToasterMessageType.info);
                   }
                   else{
                     customSnackBar('please_enter_valid_amount'.tr,  showDefaultSnackBar: false, type: ToasterMessageType.info);
                   }

                 }
               },
             ) : const Center(child: CircularProgressIndicator()),
           ]),
         )

        ]),
      );
    });
  }

  void _addFundToWallet(String paymentGateway , double amount){

    String userId = Get.find<UserController>().userInfoModel?.id ?? "";

    String url = '${AppConstants.baseUrl}/payment?payment_method=$paymentGateway&access_token=${base64Url.encode(utf8.encode(userId))}'
        '&callback=${AppConstants.baseUrl}&amount=$amount&payment_platform=app&is_add_fund=1';

    printLog("url_with_digital_payment_mobile:$url");
    Get.to(()=> GatewayWebviewScreen(url:url, fromPage: "add-fund",));
  }
}
