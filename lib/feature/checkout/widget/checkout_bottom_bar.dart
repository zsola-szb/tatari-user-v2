import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutBottomBar extends StatelessWidget {
  final double total;
  final double originalTotal;
  final bool showStrikethrough;
  final bool isLoading;
  final bool canConfirm;
  final String? buttonLabel;
  final VoidCallback onConfirm;

  const CheckoutBottomBar({
    super.key,
    required this.total,
    required this.originalTotal,
    required this.onConfirm,
    this.showStrikethrough = false,
    this.isLoading = false,
    this.canConfirm = true,
    this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || !canConfirm;
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      color: context.customThemeColors.backGroundColor,
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding10,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${'total'.tr} ',
                      style: context.heading.large,
                      children: [
                        TextSpan(text: 'inc_vat_tax'.tr, style: context.body.defaultSize),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (showStrikethrough) ...<Widget>[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    PriceConverter.convertPrice(originalTotal),
                    style: context.body.small.copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: context.customThemeColors.secondaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.padding4),
              ],
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(total),
                  style: context.heading.overLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding10),
          CustomButton(
            buttonText: buttonLabel ?? 'confirm_booking'.tr,
            width: double.infinity,
            height: 50,
            radius: Dimensions.radius12,
            isLoading: isLoading,
            backgroundColor: isDisabled ? primary.withValues(alpha: 0.5) : primary,
            textStyle: context.heading.defaultSize.copyWith(color: Colors.white),
            onPressed: isDisabled ? null : onConfirm,
          ),
        ],
      ),
    );
  }
}
