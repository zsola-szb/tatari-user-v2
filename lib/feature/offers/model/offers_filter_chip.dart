import 'package:tatarigigs_user/common/models/search_sort_option.dart';

enum OffersChip { available, nearby, topRated, newest }

extension OffersChipTranslationKey on OffersChip {
  String get translationKey {
    switch(this){
      case OffersChip.available:
        return 'available';
      case OffersChip.nearby:
        return 'nearby';
      case OffersChip.topRated:
        return 'top_rated';
      case OffersChip.newest:
        return 'newest';
    }
  }
}

extension OffersChipApiValue on OffersChip {
  String? get sortByType {
    switch(this){
      case OffersChip.available:
        return 'available';
      case OffersChip.nearby:
        return 'nearby';
      case OffersChip.topRated:
        return 'top_rated';
      case OffersChip.newest:
        return 'newest';
    }
  }

  bool get isSortChip => sortByType != null;

  SearchSortOption? get equivalentSortOption {
    switch(this){
      case OffersChip.nearby:
        return SearchSortOption.nearby;
      case OffersChip.newest:
        return SearchSortOption.newest;
      case OffersChip.available:
      case OffersChip.topRated:
        return null;
    }
  }
}
