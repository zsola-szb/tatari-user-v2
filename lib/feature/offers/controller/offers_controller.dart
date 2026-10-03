import 'package:tatarigigs_user/helper/debounce_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersController extends GetxController with FilterSortSource implements GetxService {

  static const int pageLimit = 10;

  final OffersRepo offersRepo;

  OffersController({required this.offersRepo});

  final DebounceHelper _searchDebounce = DebounceHelper(milliseconds: 500);

  int _requestId = 0;

  List<Service> _offers = <Service>[];
  List<Service> get offers => List<Service>.unmodifiable(_offers);

  int _totalSize = 0;
  int get totalSize => _totalSize;

  int _offset = 1;
  int get currentPage => _offset;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isEmpty => !_isLoading && _offers.isEmpty;

  OffersChip? _selectedChip;
  OffersChip? get selectedChip => _selectedChip;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  String _query = '';
  String get query => _query;

  SearchSortOption? _selectedSortOption;
  @override
  SearchSortOption? get selectedSortOption => _selectedSortOption;

  @override
  List<SearchSortOption> get sortOptions => const <SearchSortOption>[
        SearchSortOption.mostPopular,
        SearchSortOption.newest,
        SearchSortOption.priceLowToHigh,
        SearchSortOption.priceHighToLow,
      ];

  List<String> _selectedRatings = <String>[];
  @override
  List<String> get selectedRatings => _selectedRatings;

  @override
  List<String> get ratingOptions => const <String>['5', '4', '3', '2'];

  List<String> _selectedCategoryIds = <String>[];

  @override
  List<FilterCategoryOption> get filterCategories {
    final List<CategoryModel> categories = Get.find<CategoryController>().categoryList ?? <CategoryModel>[];
    final List<FilterCategoryOption> options = <FilterCategoryOption>[];

    for (final CategoryModel category in categories) {
      final String? id = category.id;
      if(id == null){
        continue;
      }
      options.add(FilterCategoryOption(
        id: id,
        name: category.name ?? '',
        isSelected: _selectedCategoryIds.contains(id),
      ));
    }
    return options;
  }

  bool _hasPriceBounds = false;

  double _initialMinPrice = 0;
  @override
  double get initialMinPrice => _initialMinPrice;

  double _initialMaxPrice = 100;
  @override
  double get initialMaxPrice => _initialMaxPrice;

  double? _filteredMinPrice;
  @override
  double? get filteredMinPrice => _filteredMinPrice;

  double? _filteredMaxPrice;
  @override
  double? get filteredMaxPrice => _filteredMaxPrice;

  String? get _effectiveSortByType => _selectedChip?.sortByType ?? _selectedSortOption?.sortByType;

  int? get _serviceAvailability => _selectedChip == OffersChip.available ? 1 : null;

  @override
  void onInit() {
    super.onInit();
    getOffersList(offset: 1);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    super.onClose();
  }

  Future<void> getOffersList({required int offset}) async {
    final bool isPagination = offset > 1;

    if(!isPagination){
      _searchDebounce.cancel();

      _isLoading = true;
      update();
    }

    final int requestId = ++_requestId;
    final String? sortByType = _effectiveSortByType;
    final AddressModel? nearbyAddress = sortByType == SearchSortOption.nearby.sortByType
        ? Get.find<LocationController>().getUserAddress() : null;

    final Response response = await offersRepo.getOffersList(
      offset: offset,
      limit: pageLimit,
      query: _query.trim(),
      sortByType: sortByType,
      minPrice: _filteredMinPrice,
      maxPrice: _filteredMaxPrice,
      ratings: _selectedRatings,
      categoryIds: _selectedCategoryIds,
      serviceAvailability: _serviceAvailability,
      latitude: double.tryParse(nearbyAddress?.latitude ?? ''),
      longitude: double.tryParse(nearbyAddress?.longitude ?? ''),
    );

    if(requestId != _requestId){
      return;
    }

    if(response.statusCode == 200){
      final ServiceListModel page = ServiceListModel.fromJson(response.body);
      final List<Service> services = page.toServiceList();

      _totalSize = page.totalSize;
      _offset = offset;
      _offers = isPagination ? <Service>[..._offers, ...services] : services;

      _absorbPriceBounds(services);
    }else{
      if(!isPagination){
        _offers = <Service>[];
        _totalSize = 0;
      }
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> refreshOffers() async {
    await getOffersList(offset: 1);
  }

  Future<void> loadPage(int offset) async {
    await getOffersList(offset: offset);
  }

  void onSearchChanged(String value) {
    if(_query == value){
      return;
    }
    _query = value;
    update();

    _searchDebounce.run(() => getOffersList(offset: 1));
  }

  void clearSearch() {
    searchController.clear();
    _query = '';
    update();

    getOffersList(offset: 1);
  }

  void selectChip(OffersChip chip) {
    final bool isDeselecting = _selectedChip == chip;
    _selectedChip = isDeselecting ? null : chip;

    if(chip.isSortChip){
      _selectedSortOption = isDeselecting ? null : chip.equivalentSortOption;
    }

    getOffersList(offset: 1);
  }

  @override
  void updateSortOption(SearchSortOption option, {bool shouldUpdate = true}) {
    _selectedSortOption = option;

    if(_selectedChip?.isSortChip ?? false){
      _selectedChip = null;
    }

    if(shouldUpdate){
      update();
    }
  }

  @override
  void toggleFilterRating(String rating) {
    if(_selectedRatings.contains(rating)){
      _selectedRatings.remove(rating);
    }else{
      _selectedRatings.add(rating);
    }
    update();
  }

  @override
  void toggleFilterCategory(String categoryId) {
    if(_selectedCategoryIds.contains(categoryId)){
      _selectedCategoryIds.remove(categoryId);
    }else{
      _selectedCategoryIds.add(categoryId);
    }
    update();
  }

  @override
  void updateFilterPriceRange(double minPrice, double maxPrice) {
    _filteredMinPrice = minPrice;
    _filteredMaxPrice = maxPrice;
    update();
  }

  @override
  bool get hasAppliedFilters =>
      _selectedChip != null ||
      _selectedSortOption != null ||
      _selectedRatings.isNotEmpty ||
      _selectedCategoryIds.isNotEmpty ||
      _filteredMinPrice != null ||
      _filteredMaxPrice != null;


  @override
  void clearFilterSelections({bool shouldUpdate = true}) {
    _selectedChip = null;
    _selectedSortOption = null;
    _selectedRatings = <String>[];
    _selectedCategoryIds = <String>[];
    _filteredMinPrice = null;
    _filteredMaxPrice = null;

    if(shouldUpdate){
      update();
    }
  }

  @override
  Future<void> commitFilters() async {
    Get.dialog(const CustomLoader(), barrierDismissible: false);

    await getOffersList(offset: 1);

    Get.back();
  }

  void updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}) {
    final int index = _offers.indexWhere((Service service) => service.id == serviceId);
    if(index > -1){
      _offers[index].isFavorite = status;
    }
    if(shouldUpdate){
      update();
    }
  }

  void _absorbPriceBounds(List<Service> services) {
    if(_filteredMinPrice != null || _filteredMaxPrice != null || services.isEmpty){
      return;
    }

    double lowest = _hasPriceBounds ? _initialMinPrice : _priceOf(services.first);
    double highest = _hasPriceBounds ? _initialMaxPrice : lowest;

    for (final Service service in services) {
      final double price = _priceOf(service);
      if(price < lowest){
        lowest = price;
      }
      if(price > highest){
        highest = price;
      }
    }

    _hasPriceBounds = true;
    _initialMinPrice = lowest;
    _initialMaxPrice = highest > lowest ? highest : lowest + 1;
  }

  double _priceOf(Service service) {
    final List<ZoneWiseVariations>? variations = service.variationsAppFormat?.zoneWiseVariations;
    if(variations == null || variations.isEmpty){
      return service.variationsAppFormat?.defaultPrice?.toDouble() ?? 0;
    }

    double lowest = variations.first.price?.toDouble() ?? 0;
    for (final ZoneWiseVariations variation in variations) {
      final double price = variation.price?.toDouble() ?? 0;
      if(price < lowest){
        lowest = price;
      }
    }
    return lowest;
  }
}