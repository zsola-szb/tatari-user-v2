import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class FavoriteServiceItemView extends StatelessWidget {
  final Service? service;
  final int index;

  const FavoriteServiceItemView({super.key, this.service, required this.index}) ;

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice = false;
    showDiscountedPrice = ((service?.lowestPrice ?? 0) > (service?.discountedLowestPrice ?? 0));

    return Padding(padding: const  EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding2),
      child: Slidable(
        key: ValueKey(index),
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: null,
          extentRatio: 0.2,
          children: [
            CustomSlidableAction(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
              flex: 1,
              onPressed: (context) async {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (context) => FavoriteItemRemoveDialog(
                    serviceId: service?.id,
                  ),
                  backgroundColor: Colors.transparent,
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius6),
                  bottomRight:  Radius.circular(Dimensions.radius6)),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.padding8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(Dimensions.padding10),
                ),
                child: const Icon(Icons.delete_forever_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          padding: const EdgeInsets.all(Dimensions.padding12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(
                  service?.name ?? "",
                  style: context.heading.large.overrideWith(fontWeight: FontWeight.w500),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.padding4),

                Row(children: [
                  Image(image: AssetImage(Images.starIcon), height: 14, width: 14),
                  Gaps.horizontalGapOf(4),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      service?.avgRating?.toStringAsFixed(1) ?? '0.0',
                      style: context.subHeading.small,
                    ),
                  ),
                  Gaps.horizontalGapOf(4),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text("(${service?.ratingCount ?? 0}+)", style: context.body.small),
                  ),
                ]),
                const SizedBox(height: Dimensions.padding6),

                Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      PriceConverter.convertPrice(
                        showDiscountedPrice ? service?.discountedLowestPrice ?? 0 : service?.lowestPrice ?? 0,
                        // discount: showDiscountedPrice ? discountAmount?.toDouble() : null,
                        // discountType: showDiscountedPrice ? discountAmountType : null,
                      ),
                      style: context.heading.large,
                    ),
                  ),

                  if(showDiscountedPrice) ...[
                    Gaps.horizontalGapOf(6),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice(service?.lowestPrice ?? 0),
                        style: context.body.defaultSize.copyWith(decoration: TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ]),

                if(showDiscountedPrice) ...[
                  const SizedBox(height: Dimensions.padding6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding8, vertical: Dimensions.padding2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                      border: Border.all(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3)),
                    ),
                    child: Text(service?.maximumDiscount ?? '', style: context.body.small.overrideWith(color: Theme.of(context).colorScheme.error)),
                  ),
                ],
              ]),


            ),
            const SizedBox(width: Dimensions.padding12),

            SizedBox(
              width: 100, height: 100,
              child: Stack(clipBehavior: Clip.none, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius8),
                  child: CustomImage(
                    image: '${service?.thumbnailFullPath}',
                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                  ),
                ),

                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                    child: FavoriteIconWidget(
                      value: 1,
                      serviceId: service?.id,
                      showDialog: true,
                      size: 28,
                      iconSize: 14,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 8, right: 8,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radius8),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        builder: (context) => ServiceCenterDialog(service: service),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Container(
                      width: 30, height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius8),
                        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                      ),
                      child: Icon(Icons.add,
                        color: context.customThemeColors.textColor,
                        size: Dimensions.padding20,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
