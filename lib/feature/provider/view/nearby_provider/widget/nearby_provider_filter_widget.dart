import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NearByFilterDialog extends StatefulWidget {
  final bool showCrossButton;
  final LatLng? initialPosition;
  const NearByFilterDialog({
    super.key,
    this.showCrossButton = true,
    this.initialPosition,
  });

  @override
  State<NearByFilterDialog> createState() => _NearByFilterDialogState();
}

class _NearByFilterDialogState extends State<NearByFilterDialog> {
  @override
  void initState() {
    super.initState();
    Get.find<NearbyProviderController>().updatePopMenuStatus(
      true,
      shouldUpdate: false,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.find<NearbyProviderController>().update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.find<NearbyProviderController>().updatePopMenuStatus(false);
      },
      child: GetBuilder<NearbyProviderController>(
        builder: (nearbyProviderController) {
          return Material(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.radius20),
            ),
            child: Container(
              width: Dimensions.webMaxWidth,
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.padding16,
                horizontal: Dimensions.padding16,
              ),

              child: Column(
                children: [
                  if (widget.showCrossButton)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: Dimensions.padding16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: Dimensions.padding20),
                          Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius12),
                              color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                            ),
                          ),

                          InkWell(
                            onTap: () => Get.back(),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'sort_by'.tr,
                              style: context.heading.large.overrideWith(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),

                            const SizedBox(height: Dimensions.padding20),

                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              runSpacing: 10,
                              children: nearbyProviderController.sortBy.map((
                                element,
                              ) {
                                return InkWell(
                                  onTap: () => nearbyProviderController.updateSortBy(element),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.padding20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radius8,
                                      ),
                                      color: element == nearbyProviderController.selectedSortBy ?
                                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) :
                                      null,
                                      border: Border.all(
                                        color: element == nearbyProviderController.selectedSortBy ?
                                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) :
                                        Theme.of(context).hintColor.withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Text(
                                      element == NearbyProviderController.nearestSortBy
                                          ? "${element.tr} (${'nearest'.tr})"
                                          : element.tr,
                                      style: context.subHeading.defaultSize,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: Dimensions.padding20),

                            Divider(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              height: 0.5,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.padding16,
                              ),
                              child: Text(
                                'status'.tr,
                                style: context.heading.large.overrideWith(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.padding10,
                                      ),
                                      child: CustomCheckBox(
                                        title: "available",
                                        value: nearbyProviderController.providerAvailableStatus == 1
                                            ? true
                                            : false,
                                        onTap: () {
                                          nearbyProviderController.updateProviderAvailableStatus();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Dimensions.padding20),
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
                                      child: CustomCheckBox(
                                        title: "unavailable",
                                        value: nearbyProviderController.providerAvailableStatus == 0
                                            ? true
                                            : false,
                                        onTap: () {
                                          nearbyProviderController.updateProviderAvailableStatus();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(flex: 1, child: SizedBox()),
                              ],
                            ),

                            const SizedBox(height: Dimensions.padding20),
                            Divider(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                              height: 0.5,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.padding16,
                              ),
                              child: Text(
                                'ratings'.tr,
                                style: context.heading.large.overrideWith(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 35,
                                  child: RadioGroup<String>(
                                    groupValue:
                                        nearbyProviderController.selectedRating,
                                    onChanged: (val) {
                                      if (val != null) {
                                        nearbyProviderController.updateFilterByRating(val);
                                      }
                                    },
                                    child: RadioListTile(
                                      visualDensity: VisualDensity.compact,
                                      dense: true,
                                      contentPadding: const EdgeInsets.only(
                                        left: Dimensions.padding10,
                                      ),
                                      activeColor: Theme.of(context).colorScheme.primary,
                                      title: Text(
                                        nearbyProviderController.ratingFilter[index] == "5"
                                            ? "only_rated_5".tr
                                            : "${nearbyProviderController.ratingFilter[index]}+ ${'rating'.tr}",
                                        style: context.subHeading.defaultSize,
                                      ),
                                      value: nearbyProviderController.ratingFilter[index],
                                      controlAffinity: ListTileControlAffinity.trailing,
                                    ),
                                  ),
                                );
                              },
                              itemCount: nearbyProviderController.ratingFilter.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                            ),

                            const SizedBox(height: Dimensions.padding10),
                            Divider(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.7),
                              height: 0.5,
                            ),
                            const SizedBox(height: Dimensions.padding10),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.padding10,
                              ),
                              child: Text(
                                'categories'.tr,
                                style: context.heading.large.overrideWith(
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),

                            GetBuilder<CategoryController>(
                              builder: (categoryController) {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10,),
                                        child: CustomCheckBox(
                                          title: categoryController.categoryList?[index].name ?? "",
                                          value: nearbyProviderController.categoryCheckList[index],
                                          onTap: () => nearbyProviderController.toggleFromCampaignChecked(index),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: categoryController.categoryList?.length,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                );
                              },
                            ),

                            const SizedBox(height: Dimensions.padding20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        (nearbyProviderController.isFilteredApplied())
                            ? Expanded(
                                child: CustomButton(
                                  buttonText: 'clear_filter'.tr,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                                  onPressed: () async {
                                    Get.back();
                                    Get.dialog(
                                      const CustomLoader(),
                                      barrierDismissible: false,
                                    );
                                    await nearbyProviderController.getProviderList(
                                      1,
                                      true,
                                      initialPosition: widget.initialPosition,
                                    );
                                    Get.back();
                                  },
                                ),
                              )
                            : const SizedBox(),

                        (nearbyProviderController.isFilteredApplied())
                            ? const SizedBox(width: Dimensions.padding10)
                            : const SizedBox(),

                        Expanded(
                          child: CustomButton(
                            buttonText: 'filter'.tr,
                            onPressed: () async {
                              Get.back();
                              Get.dialog(
                                const CustomLoader(),
                                barrierDismissible: false,
                              );
                              await nearbyProviderController.getProviderList(
                                1,
                                true,
                                applyFilter: true,
                                initialPosition: widget.initialPosition,
                              );
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
