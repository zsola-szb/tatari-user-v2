import 'package:tatarigigs_user/common/models/search_sort_option.dart';
import 'package:get/get.dart';

class FilterCategoryOption {
  final String id;
  final String name;
  final bool isSelected;

  const FilterCategoryOption({required this.id, required this.name, required this.isSelected});
}

mixin FilterSortSource on GetxController {


  List<SearchSortOption> get sortOptions => SearchSortOption.values;

  SearchSortOption? get selectedSortOption;

  void updateSortOption(SearchSortOption option, {bool shouldUpdate = true});

  List<String> get ratingOptions;

  List<String> get selectedRatings;

  void toggleFilterRating(String rating);

  List<FilterCategoryOption> get filterCategories;

  void toggleFilterCategory(String categoryId);

  double get initialMinPrice;
  double get initialMaxPrice;
  double? get filteredMinPrice;
  double? get filteredMaxPrice;

  void updateFilterPriceRange(double minPrice, double maxPrice);

  bool get hasAppliedFilters;

  void clearFilterSelections({bool shouldUpdate = true});

  Future<void> commitFilters();
}
