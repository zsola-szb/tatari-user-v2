import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class FavoriteItemRemoveDialog extends StatefulWidget {
  final String? serviceId;
  final String? providerId;

  const FavoriteItemRemoveDialog({super.key, this.serviceId, this.providerId});

  @override
  State<FavoriteItemRemoveDialog> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<FavoriteItemRemoveDialog> {

  @override
  Widget build(BuildContext context) {
    return pointerInterceptor();
  }

  Padding pointerInterceptor(){
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Container(
          width: Dimensions.webMaxWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(height: 5, width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(Get.context!).hintColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radius12)
              ),
              margin: const EdgeInsets.symmetric(vertical: Dimensions.padding16 * 1.5),
            ),

            Image.asset(widget.providerId !=null ? Images.favoriteProvider : Images.favoriteService, height: 70, fit: BoxFit.fitHeight,),
            const SizedBox(height: Dimensions.padding20),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16 * 2,),
              child: Text( widget.providerId != null ? "want_to_remove_provider".tr : widget.serviceId !=null ? "want_to_remove_service".tr:"",
                style: context.heading.large,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.padding10),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16 * 2,),
              child: Text( widget.providerId != null ? "provider_remove_message".tr : widget.serviceId !=null ? "service_remove_message".tr :"",
                maxLines: 3,
                style: context.body.defaultSize,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.padding20 * 1.3),

            Padding(
              padding: const EdgeInsets.only(
                  left: Dimensions.padding24,
                  right: Dimensions.padding24
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                  Expanded(child: CustomButton(
                      buttonText: 'cancel'.tr,
                      backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                      onPressed: () => Get.back(),
                      textColor: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8)
                  )),
                  const SizedBox(width: Dimensions.padding16),


                  Expanded(child: CustomButton(
                    buttonText : 'remove'.tr,
                    onPressed: () async {
                      Get.back();
                      Get.dialog(const CustomLoader(), barrierDismissible: false);

                     if( widget.serviceId !=null){
                       await Get.find<MyFavoriteController>().removeFavoriteService(widget.serviceId!);
                     } else if(widget.providerId != null){
                       await Get.find<MyFavoriteController>().removeFavoriteProvider(widget.providerId!);
                     } else{
                       Get.back();
                     }
                      Get.back();
                    },
                    backgroundColor: Theme.of(context).colorScheme.error,

                  )),


                ],),
            ),
            const SizedBox(height: Dimensions.padding20 * 2),

          ])
        ),
    );
  }
}