import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? icon;
  final double iconSize;
  final Icon? iconWidget;
  final String? title;
  final String? description;
  final Color? yesButtonColor;
  final Function()? onYesPressed;
  final String? noButtonText;
  final String? yesButtonText;
  final Color? noTextColor;
  final Color? yesTextColor;
  final Color? noButtonColor;
  final Widget? customButton;
  final Widget? widget;
  final Function () ? onNoPressed;
  final bool isLoading;
  final double? buttonFontSize;
  const ConfirmationDialog({super.key,  this.icon, this.iconSize = 50, this.title,  this.description,  this.onYesPressed, this.onNoPressed, this.yesButtonColor=const Color(0xFFF24646),
    this.isLoading=false, this.iconWidget, this.noTextColor, this.yesTextColor, this.noButtonColor, this.noButtonText, this.yesButtonText, this.customButton, this.widget, this.buttonFontSize});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,  insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
      backgroundColor: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,

      child: SizedBox(width: Dimensions.webMaxWidth / 2.5, child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding20),
        child:  widget ??  Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.padding20),
            child: iconWidget ?? Image.asset(icon!, width: iconSize),
          ),

          title != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
            child: Text(
              title!, textAlign: TextAlign.center,
              style: context.subHeading.defaultSize.overrideWith(
                fontWeight: AppWeight.medium,
                color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.8),
              ),
            ),
          ) : const SizedBox(),

          (description!=null) ? Padding(
            padding: const EdgeInsets.all(Dimensions.padding10),
            child: Text(description!.tr,
              style: context.body.small,
              textAlign: TextAlign.center,
            ),
          ) : const SizedBox(height: Dimensions.padding16,),

          const SizedBox(height: Dimensions.padding20),

          customButton ?? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            const SizedBox(width: Dimensions.padding20),

            Expanded(child: TextButton(
              onPressed: () =>  onNoPressed != null ? onNoPressed!() : Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: noButtonColor ??  Theme.of(context).hintColor.withValues(alpha: 0.3),
                minimumSize: const Size(Dimensions.webMaxWidth, 45),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius6)),
              ),
              child: Text( noButtonText?.tr ?? 'no'.tr, textAlign: TextAlign.center,
                style: context.subHeading.defaultSize.copyWith(
                  fontWeight: AppWeight.medium,
                  color: noTextColor ?? Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: buttonFontSize ?? Dimensions.fontSizeDefault,
                ),
              ),
            )),

            const SizedBox(width: Dimensions.padding20),


            Expanded(
              child:  CustomButton(
                backgroundColor : yesButtonColor,
                textColor: yesTextColor,
                buttonText: yesButtonText?.tr ?? 'yes'.tr,
                onPressed: () =>  onYesPressed != null ? onYesPressed!() : Get.back(),
                radius: Dimensions.radius6, height: 45,
                fontSize: buttonFontSize ?? Dimensions.fontSizeDefault,

              ),
            ),
            const SizedBox(width: Dimensions.padding20),

          ]),

        ]),
      )),
    );
  }
}