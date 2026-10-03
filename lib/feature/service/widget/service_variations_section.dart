import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceVariationsSection extends StatelessWidget {
  final String serviceId;
  const ServiceVariationsSection({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      final List<CartVariationSelection> variations = cartController.variationSelectionsForService(serviceId);

      if(variations.isEmpty){
        return const SizedBox.shrink();
      }

      return ServiceExpandableCard(
        title: 'service_variation'.tr,
        isExpandable: false,
        children: [
          for (int index = 0; index < variations.length; index++) ...[
            _VariationRow(selection: variations[index], index: index),
          ],
        ],
      );
    });
  }
}

class _VariationRow extends StatelessWidget {
  final CartVariationSelection selection;
  final int index;
  const _VariationRow({required this.selection, required this.index});

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice = (selection.price > (selection.discountedPrice ?? 0));


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selection.variantName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.subHeading.defaultSize.medium,
                ),
                Gaps.verticalGapOf(Dimensions.padding4),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Text(
                        showDiscountedPrice
                            ? PriceConverter.convertPrice(
                                (selection.discountedPrice ?? 0).toDouble(),
                                isShowLongPrice: true,
                              )
                            : PriceConverter.convertPrice(selection.price.toDouble(), isShowLongPrice: true),
                        style: context.heading.defaultSize.strong,
                      ),
                      if (showDiscountedPrice) ...[
                        Gaps.horizontalGapOf(Dimensions.padding6),
                        Text(
                          PriceConverter.convertPrice(selection.price.toDouble(), isShowLongPrice: true),
                          style: context.body.small.copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding10),
          _VariationStepper(selection: selection, index: index),
        ],
      ),
    );
  }
}

class _VariationStepper extends StatelessWidget {
  final CartVariationSelection selection;
  final int index;
  const _VariationStepper({required this.selection, required this.index});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return AutoCollapsingQuantityStepper(
      quantity: selection.quantity,
      onIncrement: () => cartController.changeSelectionQuantity(selection.serviceId, index, true),
      onDecrement: () => cartController.changeSelectionQuantity(selection.serviceId, index, false),
    );
  }
}
