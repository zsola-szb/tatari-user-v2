enum SearchSortOption { mostPopular, nearby, newest, priceLowToHigh, priceHighToLow }

extension SearchSortOptionTranslationKey on SearchSortOption {
  String get translationKey {
    switch(this){
      case SearchSortOption.mostPopular:
        return 'most_popular';
      case SearchSortOption.nearby:
        return 'nearby';
      case SearchSortOption.newest:
        return 'newest';
      case SearchSortOption.priceLowToHigh:
        return 'low_to_high';
      case SearchSortOption.priceHighToLow:
        return 'high_to_low';
    }
  }
}

extension SearchSortOptionApiValue on SearchSortOption {
  String get sortByType {
    switch(this){
      case SearchSortOption.mostPopular:
        return 'popular';
      case SearchSortOption.nearby:
        return 'nearby';
      case SearchSortOption.newest:
        return 'newest';
      case SearchSortOption.priceLowToHigh:
        return 'low_to_high';
      case SearchSortOption.priceHighToLow:
        return 'high_to_low';
    }
  }
}
