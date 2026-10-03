import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FilterSortSheet extends StatefulWidget {
  final FilterSortSource source;
  final String titleKey;

  const FilterSortSheet({
    super.key,
    required this.source,
    this.titleKey = 'filter',
  });

  @override
  State<FilterSortSheet> createState() => _FilterSortSheetState();
}

class _FilterSortSheetState extends State<FilterSortSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  bool _isCommitting = false;

  @override
  void initState() {
    super.initState();
    final FilterSortSource source = widget.source;
    _minController = TextEditingController(
      text: (source.filteredMinPrice ?? source.initialMinPrice).toStringAsFixed(
        0,
      ),
    );
    _maxController = TextEditingController(
      text: (source.filteredMaxPrice ?? source.initialMaxPrice).toStringAsFixed(
        0,
      ),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  ({double min, double max})? _readValidatedPriceRange() {
    final double? minPrice = double.tryParse(_minController.text.trim());
    final double? maxPrice = double.tryParse(_maxController.text.trim());

    if (minPrice == null || maxPrice == null) {
      customSnackBar('enter_a_valid_price_range'.tr, showDefaultSnackBar: false);
      return null;
    }
    if (minPrice > maxPrice) {
      customSnackBar('min_price_can_not_be_greater_than_max_price'.tr, showDefaultSnackBar: false);
      return null;
    }

    return (min: minPrice, max: maxPrice);
  }

  void _onPriceSubmitted() {
    final ({double min, double max})? range = _readValidatedPriceRange();
    if (range == null) {
      return;
    }

    widget.source.updateFilterPriceRange(range.min, range.max);
  }

  Future<void> _onApply() async {
    if (_isCommitting) {
      return;
    }

    final ({double min, double max})? range = _readValidatedPriceRange();
    if (range == null) {
      return;
    }
    widget.source.updateFilterPriceRange(range.min, range.max);

    _isCommitting = true;

    Get.back();
    await widget.source.commitFilters();
  }

  Future<void> _onReset() async {
    if (_isCommitting) {
      return;
    }

    final bool hadFilters = widget.source.hasAppliedFilters;

    widget.source.clearFilterSelections(shouldUpdate: !hadFilters);
    _minController.text = widget.source.initialMinPrice.toStringAsFixed(0);
    _maxController.text = widget.source.initialMaxPrice.toStringAsFixed(0);

    if (hadFilters) {
      _isCommitting = true;
      Get.back();
      await widget.source.commitFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterSortSource>(
      init: widget.source,
      global: false,
      autoRemove: false,
      builder: (FilterSortSource source) {
        final double minPrice = source.filteredMinPrice ?? source.initialMinPrice;
        final double maxPrice = source.filteredMaxPrice ?? source.initialMaxPrice;
        final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

        return Material(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: Container(
              width: Dimensions.webMaxWidth,
              height: MediaQuery.sizeOf(context).height - keyboardInset,
              padding: EdgeInsets.only(
                top: Get.statusBarHeight,
                left: Dimensions.padding16,
                right: Dimensions.padding16,
                bottom: Dimensions.padding16,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterSheetHeader(titleKey: widget.titleKey),

                  const SizedBox(height: Dimensions.padding18),

                  Container(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                    height: Dimensions.padding2,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.padding20),

                          FilterSortOptionSection(
                            options: source.sortOptions,
                            selected: source.selectedSortOption,
                            onChanged: source.updateSortOption,
                          ),

                          const FilterSheetSectionDivider(),

                          FilterRatingSection(
                            ratings: source.ratingOptions,
                            selectedRatings: source.selectedRatings,
                            onRatingTap: source.toggleFilterRating,
                          ),

                          const FilterSheetSectionDivider(),

                          FilterCategorySection(
                            categories: source.filterCategories,
                            onCategoryTap: source.toggleFilterCategory,
                          ),

                          const FilterSheetSectionDivider(),

                          FilterPriceRangeSection(
                            minController: _minController,
                            maxController: _maxController,
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                            initialMinPrice: source.initialMinPrice,
                            initialMaxPrice: source.initialMaxPrice,
                            onRangeChanged: source.updateFilterPriceRange,
                            onPriceSubmitted: _onPriceSubmitted,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.padding16),

                  FilterSheetActionBar(onReset: _onReset, onApply: _onApply),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FilterSheetHeader extends StatelessWidget {
  final String titleKey;

  const FilterSheetHeader({super.key, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleKey.tr, style: context.heading.extraLarge),

        InkWell(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.padding4),
            decoration: BoxDecoration(
              color: context.customThemeColors.backGroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: Dimensions.padding18, color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}

class FilterSheetSectionTitle extends StatelessWidget {
  final String titleKey;

  const FilterSheetSectionTitle({super.key, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    return Text(titleKey.tr, style: context.heading.large);
  }
}

class FilterSheetSectionDivider extends StatelessWidget {
  const FilterSheetSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.padding10),
        Divider(
          color: Theme.of(context).hintColor.withValues(alpha: 0.3),
          height: 0.5,
        ),
        const SizedBox(height: Dimensions.padding16),
      ],
    );
  }
}

class FilterSortOptionSection extends StatelessWidget {
  final List<SearchSortOption> options;
  final SearchSortOption? selected;
  final void Function(SearchSortOption option) onChanged;

  const FilterSortOptionSection({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSheetSectionTitle(titleKey: 'sort_by'),

        RadioGroup<SearchSortOption>(
          groupValue: selected,
          onChanged: (SearchSortOption? value) {
            if (value != null) {
              onChanged(value);
            }
          },
          child: Column(
            children: [
              for (final SearchSortOption option in options)
                RadioListTile<SearchSortOption>(
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    option.translationKey.tr,
                    style: context.subHeading.defaultSize,
                  ),
                  value: option,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterRatingSection extends StatelessWidget {
  final List<String> ratings;
  final List<String> selectedRatings;
  final void Function(String rating) onRatingTap;

  const FilterRatingSection({
    super.key,
    required this.ratings,
    required this.selectedRatings,
    required this.onRatingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSheetSectionTitle(titleKey: 'ratings'),
        const SizedBox(height: Dimensions.padding10),

        Column(
          children: [
            for (final String rating in ratings)
              CustomCheckBox(
                title: rating == "5" ? "only_rated_5".tr : "$rating+ ${'rating'.tr}",
                value: selectedRatings.contains(rating),
                onTap: () => onRatingTap(rating),
                leadingIcon: Images.starIconOutlined,
              ),
          ],
        ),
      ],
    );
  }
}

class FilterCategorySection extends StatelessWidget {
  final List<FilterCategoryOption> categories;
  final void Function(String categoryId) onCategoryTap;
  final int visibleCount;

  const FilterCategorySection({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.visibleCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterSheetSectionTitle(titleKey: 'categories'),
        const SizedBox(height: Dimensions.padding10),

        SeeMoreToggleList(
          visibleCount: visibleCount,
          children: [
            for (final FilterCategoryOption category in categories)
              CustomCheckBox(
                title: category.name,
                value: category.isSelected,
                onTap: () => onCategoryTap(category.id),
              ),
          ],
        ),
      ],
    );
  }
}

class FilterPriceRangeSection extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;
  final double minPrice;
  final double maxPrice;
  final double initialMinPrice;
  final double initialMaxPrice;
  final void Function(double minPrice, double maxPrice) onRangeChanged;
  final VoidCallback onPriceSubmitted;

  const FilterPriceRangeSection({
    super.key,
    required this.minController,
    required this.maxController,
    required this.minPrice,
    required this.maxPrice,
    required this.initialMinPrice,
    required this.initialMaxPrice,
    required this.onRangeChanged,
    required this.onPriceSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    /// A single upper bound for both the slider and the clamp — using the raw
    /// max for the clamp throws when a backend ever reports max below min.
    final double rangeMax = initialMaxPrice > initialMinPrice ? initialMaxPrice : initialMinPrice + 1;

    /// The slider asserts on an inverted range, so the end is clamped to the
    /// start rather than to the range floor.
    final double sliderStart = minPrice.clamp(initialMinPrice, rangeMax);
    final double sliderEnd = maxPrice.clamp(sliderStart, rangeMax);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'price_range'.tr} (${PriceConverter.getCurrency()})',
          style: context.heading.large,
        ),
        const SizedBox(height: Dimensions.padding10),

        Row(
          children: [
            Expanded(
              child: FilterPriceInputField(
                controller: minController,
                prefixKey: 'min',
                onSubmitted: onPriceSubmitted,
              ),
            ),
            const SizedBox(width: Dimensions.padding10),

            Text('-', style: context.heading.large),
            const SizedBox(width: Dimensions.padding10),

            Expanded(
              child: FilterPriceInputField(
                controller: maxController,
                prefixKey: 'max',
                onSubmitted: onPriceSubmitted,
              ),
            ),
          ],
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbColor: Theme.of(context).cardColor,
            activeTrackColor: context.customThemeColors.textColor.withValues(
              alpha: 0.75,
            ),
            inactiveTrackColor: context.customThemeColors.secondaryBackGroundColor,
          ),
          child: RangeSlider(
            values: RangeValues(sliderStart, sliderEnd),
            min: initialMinPrice,
            max: rangeMax,
            onChanged: (RangeValues values) {
              minController.text = values.start.toStringAsFixed(0);
              maxController.text = values.end.toStringAsFixed(0);
              onRangeChanged(values.start, values.end);
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              PriceConverter.convertPrice(
                initialMinPrice,
                decimalPointCount: 0,
              ),
              style: context.subHeading.defaultSize,
            ),
            Text(
              PriceConverter.convertPrice(
                initialMaxPrice,
                decimalPointCount: 0,
              ),
              style: context.subHeading.defaultSize,
            ),
          ],
        ),
      ],
    );
  }
}

class FilterPriceInputField extends StatelessWidget {
  final TextEditingController controller;
  final String prefixKey;
  final VoidCallback onSubmitted;

  const FilterPriceInputField({
    super.key,
    required this.controller,
    required this.prefixKey,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customThemeColors.borderColor),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding12,
        vertical: Dimensions.padding12,
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        style: context.heading.defaultSize,
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          prefixText: '${prefixKey.tr}  ',
          prefixStyle: context.body.defaultSize,
        ),
        onSubmitted: (String value) => onSubmitted(),
      ),
    );
  }
}

class FilterSheetActionBar extends StatelessWidget {
  final Future<void> Function() onReset;
  final Future<void> Function() onApply;

  const FilterSheetActionBar({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            buttonText: 'reset'.tr,
            textStyle: context.subHeading.defaultSize.overrideWith(
              fontWeight: AppWeight.strong,
            ),
            backgroundColor: Theme.of(context,).colorScheme.primary.withValues(alpha: 0.1),
            textColor: Theme.of(context,).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
            onPressed: onReset,
          ),
        ),
        const SizedBox(width: Dimensions.padding10),
        Expanded(
          child: CustomButton(
            buttonText: 'apply'.tr,
            textStyle: context.subHeading.defaultSize.overrideWith(
              color: Theme.of(context).cardColor,
              fontWeight: AppWeight.strong,
            ),
            onPressed: onApply,
          ),
        ),
      ],
    );
  }
}
