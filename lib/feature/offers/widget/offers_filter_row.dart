import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersFilterRow extends StatelessWidget {
  const OffersFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OffersController>(builder: (OffersController offersController){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8).copyWith(bottom: Dimensions.padding16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: Dimensions.padding16),
          OffersFilterButton(offersController: offersController),
          const SizedBox(width: Dimensions.padding8),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: Dimensions.padding16),
              child: Row(children: [
                for (final OffersChip chip in OffersChip.values) ...[
                  if(chip != OffersChip.values.first) const SizedBox(width: Dimensions.padding8),
                  OfferSelectableChip(
                    label: chip.translationKey.tr,
                    isSelected: offersController.selectedChip == chip,
                    onTap: () => offersController.selectChip(chip),
                  ),
                ],
              ]),
            ),
          ),
        ]),
      );
    });
  }
}

class OfferSelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OfferSelectableChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius20),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: isSelected ? null : Border.all(color: context.customThemeColors.secondaryBackGroundColor, width: 1),
        ),
        child: Text(label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: context.heading.large.medium
              .overrideWith(color: isSelected ? Colors.white : context.customThemeColors.textColor),
        ),
      ),
    );
  }
}

class OffersFilterButton extends StatelessWidget {
  final OffersController offersController;

  const OffersFilterButton({super.key, required this.offersController});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius20,
      onTap: () {
        showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) => FilterSortSheet(source: offersController),
        );
      },
      child: Container(
        height: Dimensions.searchbarSize,
        width: Dimensions.searchbarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: context.customThemeColors.secondaryBackGroundColor, width: 1),
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          Image.asset(
            Images.filter,
            width: 20, height: 20,
            color: Theme.of(context).primaryColor),

          if(offersController.hasAppliedFilters)
            Positioned(
              top: -2, right: -2,
              child: Container(
                height: 8, width: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}