import 'package:tatarigigs_user/feature/search/model/filter_model.dart';
import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/feature/search/model/search_suggestion_model.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


enum AllFilterType {sortOption, price, rating, category, query}

class AllSearchController extends GetxController with FilterSortSource implements GetxService {
  final SearchRepo searchRepo;
  AllSearchController({required this.searchRepo});

  bool _isSearchComplete = false;
  bool get isSearchComplete => _isSearchComplete;

  bool _isActiveSuffixIcon = false;
  bool get isActiveSuffixIcon => _isActiveSuffixIcon;

  bool _isSortedApplied = false;
  bool get isSortedApplied => _isSortedApplied;

  bool _showAllServices = false;
  bool get showAllServices => _showAllServices;

  bool _showAllProviders = false;
  bool get showAllProviders => _showAllProviders;

  bool get isViewAllOpen => _showAllServices || _showAllProviders;

  static const int viewAllPageSize = 10;

  List<Service>? _viewAllServiceList;
  List<Service>? get viewAllServiceList => _viewAllServiceList;

  int _viewAllServiceOffset = 1;
  int get viewAllServiceOffset => _viewAllServiceOffset;

  int _viewAllServiceTotalSize = 0;
  int get viewAllServiceTotalSize => _viewAllServiceTotalSize;

  List<Providers>? _viewAllProviderList;
  List<Providers>? get viewAllProviderList => _viewAllProviderList;

  int _viewAllProviderOffset = 1;
  int get viewAllProviderOffset => _viewAllProviderOffset;

  int _viewAllProviderTotalSize = 0;
  int get viewAllProviderTotalSize => _viewAllProviderTotalSize;

  bool get hasMoreServices => _searchResultModel?.hasMoreServices ?? false;
  bool get hasMoreProviders => _searchResultModel?.hasMoreProviders ?? false;

  int get resultTotalSize {
    if(_showAllServices){
      return _viewAllServiceList == null ? _searchTotalSize : _viewAllServiceTotalSize;
    }
    if(_showAllProviders){
      return _viewAllProviderList == null ? _searchTotalSize : _viewAllProviderTotalSize;
    }
    return _searchTotalSize;
  }

  int get _searchTotalSize => _searchResultModel?.totalSize ?? 0;

  bool get hasEmptyResult {
    if(_showAllServices){
      return _viewAllServiceList?.isEmpty ?? false;
    }
    if(_showAllProviders){
      return _viewAllProviderList?.isEmpty ?? false;
    }

    final Data? data = _searchResultModel?.data;

    return data != null
        && (data.services ?? <Service>[]).isEmpty
        && (data.providers ?? <Providers>[]).isEmpty
        && (data.categories ?? <CategoriesList>[]).isEmpty;
  }

  List<Service>? _searchServiceList;
  List<Service>? get searchServiceList => _searchServiceList;

  SearchSuggestionModel? _searchSuggestionModel;
  SearchSuggestionModel? get searchSuggestionModel => _searchSuggestionModel;

  List<SearchSuggestion> _searchSuggestionList = [];
  List<SearchSuggestion> get searchSuggestionList => _searchSuggestionList;

  List<SearchSuggestion>? _historyList;
  List<SearchSuggestion>? get historyList => _historyList;

  final List<String> _ratingFilter = ['5','4', '3', '2','1'];
  List<String>  get ratingFilter => _ratingFilter;

  SearchSortOption? _selectedSortOption;
  @override
  SearchSortOption? get selectedSortOption => _selectedSortOption;

  String _selectedSortByType = 'default';
  String get selectedSortByType => _selectedSortByType;

  bool get isNearbySortSelected => _selectedSortByType == SearchSortOption.nearby.sortByType;

  List<String> _selectedRatings = <String>[];
  @override
  List<String> get selectedRatings => _selectedRatings;

  @override
  List<String> get ratingOptions => _ratingFilter;

  double _initialMinPrice = 0;
  @override
  double get initialMinPrice=> _initialMinPrice;

  double _initialMaxPrice = 100;
  @override
  double get initialMaxPrice=> _initialMaxPrice;

  double? _filteredMinPrice ;
  @override
  double? get filteredMinPrice => _filteredMinPrice;

  double? _filteredMaxPrice;
  @override
  double ? get filteredMaxPrice => _filteredMaxPrice;

  List<bool> _categoryCheckList =[];
  List<bool> get categoryCheckList => _categoryCheckList;

  List<String> _selectedCategoryId =[];
  List<String> get selectedCategoryId => _selectedCategoryId;

  List<FilterModel> sortedByList = [];
  List<FilterModel> filteredByList = [];

  SearchResultModel? _searchResultModel;
  SearchResultModel? get searchResultModel => _searchResultModel;

  final TextEditingController searchController = TextEditingController();

  /// Query the visible results were fetched with — reused by both View All requests.
  String _lastQuery = '';
  String get lastQuery => _lastQuery;


  @override
  void onInit() {
    super.onInit();
    getHistoryList();
    searchController.text = '';
  }



  Future<void> navigateToSearchResultScreen()async{

    if(Get.isDialogOpen! && Navigator.canPop(Get.context!)){
      Get.back();
    }
    if(searchController.value.text.trim().isNotEmpty){
      if(Get.currentRoute.contains('/search?query=')){
        Get.offNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }else{
        Get.toNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }
    }
  }

  /// View All swaps the result screen over to a single paginated list fetched from the
  /// matching endpoint with the query and filters the visible results were built from.
  Future<void> showViewAllServices() async {
    _showAllServices = true;
    _showAllProviders = false;

    await loadViewAllServices(offset: 1);
  }

  Future<void> showViewAllProviders() async {
    _showAllProviders = true;
    _showAllServices = false;

    await loadViewAllProviders(offset: 1);
  }

  SearchResultType get selectedResultTab {
    if(_showAllServices){
      return SearchResultType.services;
    }
    if(_showAllProviders){
      return SearchResultType.providers;
    }
    return SearchResultType.all;
  }

  Future<void> selectResultTab(SearchResultType tab) async {
    if(tab == selectedResultTab){
      return;
    }

    switch(tab){
      case SearchResultType.all:
        closeViewAll();
        return;
      case SearchResultType.services:
        await showViewAllServices();
        return;
      case SearchResultType.providers:
        await showViewAllProviders();
        return;
    }
  }

  Future<void> loadViewAllServices({required int offset, bool isPagination = false}) async {
    if(!isPagination){
      _viewAllServiceList = null;
    }
    _viewAllServiceOffset = offset;
    update();

    final SearchResultModel? result = await _fetchSearchResult(SearchResultType.services, offset: offset);
    final List<Service> services = result?.data?.services ?? <Service>[];

    _viewAllServiceTotalSize = result?.totalSize ?? (isPagination ? _viewAllServiceTotalSize : services.length);
    _viewAllServiceList = isPagination ? <Service>[...?_viewAllServiceList, ...services] : services;
    update();
  }

  Future<void> loadViewAllProviders({required int offset, bool isPagination = false}) async {
    if(!isPagination){
      _viewAllProviderList = null;
    }
    _viewAllProviderOffset = offset;
    update();

    final SearchResultModel? result = await _fetchSearchResult(SearchResultType.providers, offset: offset);
    final List<Providers> providers = result?.data?.providers ?? <Providers>[];

    _viewAllProviderTotalSize = result?.totalSize ?? (isPagination ? _viewAllProviderTotalSize : providers.length);
    _viewAllProviderList = isPagination ? <Providers>[...?_viewAllProviderList, ...providers] : providers;
    update();
  }

  void closeViewAll({bool shouldUpdate = true}){
    _showAllServices = false;
    _showAllProviders = false;
    _viewAllServiceList = null;
    _viewAllProviderList = null;
    _viewAllServiceOffset = 1;
    _viewAllProviderOffset = 1;
    _viewAllServiceTotalSize = 0;
    _viewAllProviderTotalSize = 0;

    if(shouldUpdate){
      update();
    }
  }

  Future<SearchResultModel?> _fetchSearchResult(SearchResultType type, {String? query, int offset = 1}) async {
    final AddressModel? nearbyAddress = isNearbySortSelected ? Get.find<LocationController>().getUserAddress() : null;

    final Response response = await searchRepo.getSearchData(
      type: type, query: query ?? _lastQuery, offset: offset,
      limit: type == SearchResultType.all ? null : viewAllPageSize,
      sortByType: _selectedSortByType != "default" ? _selectedSortByType : "",
      latitude: double.tryParse(nearbyAddress?.latitude ?? ''), longitude: double.tryParse(nearbyAddress?.longitude ?? ''),
      minPrice: _filteredMinPrice, maxPrice: _filteredMaxPrice, ratings: _selectedRatings, categoryIdes: _selectedCategoryId,
    );

    if (response.statusCode == 200) {
      return SearchResultModel.fromJson(response.body, type: type);
    }

    ApiChecker.checkApi(response);
    return null;
  }

  Future<void> clearSearchController({bool shouldUpdate = true})async{
    searchController.clear();
    _isSearchComplete = false;
    _isActiveSuffixIcon = false;
    _searchSuggestionList = [];
    _searchSuggestionModel = null;

    if(shouldUpdate){
      update();
    }
  }

  Future<void> populatedSearchController(String queryText, {bool shouldUpdate = true})async{

    if(queryText.isNotEmpty){
      searchController.text = queryText;
      _isActiveSuffixIcon = true;

      if(shouldUpdate){
        update();
      }
    }
  }


  Future<void> searchData({required String query, required offset, bool shouldUpdate = true, bool reload = true}) async {
   final String searchQuery = query.trim();

   addSearchHistory(SearchSuggestion(name: searchQuery), shouldUpdate: false);

   if(reload){
     _searchResultModel = null;
   }

   _lastQuery = searchQuery;
   closeViewAll(shouldUpdate: false);

   if(shouldUpdate) {
     update();
   }

    final SearchResultModel? result = await _fetchSearchResult(SearchResultType.all, query: searchQuery);
    if (result != null) {

      _searchResultModel = result;

      _initialMinPrice = _searchResultModel?.initialMinPrice ?? 0;
      _initialMaxPrice =  _searchResultModel?.initialMaxPrice ?? 100;

    }

   updatedIsSortedAppliedStatus(shouldUpdate: false);
   updatedIsFilteredAppliedStatus(shouldUpdate: false);

    _isSearchComplete = true;
    update();
  }

  Future<void> refreshSearchInitContent() async {
    getHistoryList();
    update();

    await Future.wait(<Future<void>>[
      Get.find<ServiceController>().getRecommendedSearchList(reload: true),
      Get.find<CategoryController>().getCategoryList(true),
      Get.find<ServiceController>().getPopularServiceList(1, true),
    ]);
  }

  Future<void> getSearchSuggestion(String query, {bool shouldUpdate = true,}) async {

    Response response = await searchRepo.getSearchSuggestion(query: searchController.text);
    if (response.statusCode == 200) {
      _searchSuggestionModel = SearchSuggestionModel.fromJson(response.body);
      _searchSuggestionList = _searchSuggestionModel?.searchSuggestionContent ?? [];
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }



  void updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}){
    if(_searchServiceList !=null){
      int? index = _searchServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _searchServiceList![index].isFavorite = status;
      }
    }
    if(shouldUpdate){
      update();
    }
  }

  void updateProviderIsFavoriteValue(int status, String providerId, {bool shouldUpdate = false}){
    final List<Providers> providers = <Providers>[
      ...?_searchResultModel?.data?.providers,
      ...?_viewAllProviderList,
    ];

    for (final Providers provider in providers) {
      if(provider.id == providerId){
        provider.isFavorite = status;
      }
    }

    if(shouldUpdate){
      update();
    }
  }


  void showSuffixIcon(BuildContext context,String text){
    if(text.isNotEmpty){
      _isActiveSuffixIcon = true;
    }else if(text.isEmpty){
      _isActiveSuffixIcon = false;
      _searchSuggestionList = [];
      _searchSuggestionModel = null;
    }
    update();
  }


  void getHistoryList() {
    _historyList = searchRepo.getSearchHistory();
  }

  /// Keeps the most recent entry of a suggestion first, matching an existing entry
  /// on its type and name so a service, a category, a provider and a plain query
  /// with the same text each stay in the list on their own.
  void addSearchHistory(SearchSuggestion suggestion, {bool shouldUpdate = true}) {
    final String name = suggestion.name?.trim() ?? '';
    if(name.isEmpty){
      return;
    }

    final List<SearchSuggestion> histories = _historyList ??= <SearchSuggestion>[];

    histories.removeWhere((SearchSuggestion history) =>
        history.type == suggestion.type && (history.name ?? '').toLowerCase() == name.toLowerCase());
    histories.insert(0, suggestion);

    searchRepo.saveSearchHistory(histories);

    if(shouldUpdate){
      update();
    }
  }

  void removeHistory({int? index}) {
    final List<SearchSuggestion> histories = _historyList ??= <SearchSuggestion>[];

    if(index != null && index < histories.length){
      histories.removeAt(index);
    }else if(index == null){
      histories.clear();
    }
    searchRepo.saveSearchHistory(histories);
    update();
  }

  /// Shared by the realtime suggestion list and recent search: the tapped entry is
  /// kept in history and opened on its own details page, falling back to a plain
  /// query search when the suggestion carries no slug/id to route with.
  void openSuggestion(SearchSuggestion suggestion) {
    final String name = suggestion.name ?? '';

    addSearchHistory(suggestion, shouldUpdate: false);
    populatedSearchController(name, shouldUpdate: false);
    update();

    Get.toNamed(detailsRouteFor(suggestion) ?? RouteHelper.getSearchResultRoute(queryText: name));
  }

  String? detailsRouteFor(SearchSuggestion suggestion) {
    final String? slug = suggestion.slug;
    final String? id = suggestion.id;

    switch(suggestion.type){
      case SearchSuggestionType.service:
        return (slug == null || slug.isEmpty) ? null : RouteHelper.getServiceRoute(slug, fromPage: 'search_page');
      case SearchSuggestionType.category:
        return (slug == null || slug.isEmpty) ? null : RouteHelper.getCategoryProductRoute(slug, suggestion.name ?? '');
      case SearchSuggestionType.provider:
        return (id == null || id.isEmpty) ? null : RouteHelper.getProviderDetails(id);
      case SearchSuggestionType.others:
        return null;
    }
  }


  void removeService(String queryText) async {
    if(queryText.isEmpty){
      _searchServiceList = [];
      _isSearchComplete = false;
    }
  }

  @override
  void updateSortOption(SearchSortOption option, {bool shouldUpdate = true}){
    _selectedSortOption = option;
    _selectedSortByType = option.sortByType;

    if(shouldUpdate){
      update();
    }
  }

  void updateSortByType(String? value, {bool shouldUpdate = true}){
    if(value != null && value !=""){
      _selectedSortByType = value;

      if(shouldUpdate){
        update();
      }
    }else{
      _selectedSortByType = "default";
    }

  }

  @override
  void updateFilterPriceRange(double minPrice, double maxPrice){
    _filteredMinPrice = minPrice;
    _filteredMaxPrice = maxPrice;
    update();
  }

  @override
  void toggleFilterRating(String rating){
    if(_selectedRatings.contains(rating)){
      _selectedRatings.remove(rating);
    }else{
      _selectedRatings.add(rating);
    }
    update();
  }

  void insertCategoryCheckedList(){
   Get.find<CategoryController>().categoryList?.forEach((element) {
     categoryCheckList.add(false);
   });
  }

  void clearSortByValues({bool shouldUpdate = true}){
    _selectedSortByType = "default";
    _selectedSortOption = null;
    _isSortedApplied = false;

    if(shouldUpdate){
      update();
    }
  }

  void clearFilterDataValues ({bool shouldUpdate = true}){
    _selectedCategoryId=[];
    _categoryCheckList = [];

    _filteredMinPrice = null;
    _filteredMaxPrice = null;
    _selectedRatings = <String>[];

    resetCategoryCheckedList(shouldUpdate: false);

    if(shouldUpdate){
      update();
    }

  }

  void resetCategoryCheckedList({bool shouldUpdate = true}){
    Get.find<CategoryController>().categoryList?.forEach((element) {
      _categoryCheckList.add(false);
    });

    if(shouldUpdate){
      update();
    }
  }

  /// [_categoryCheckList] is a parallel list to [CategoryController.categoryList]
  /// that is appended to rather than assigned, so the two can fall out of step.
  /// Reads are bounds-guarded and writes are keyed by category id, which keeps
  /// the sheet safe regardless of what state the parallel list is in.
  @override
  List<FilterCategoryOption> get filterCategories {
    final List<CategoryModel> categories = Get.find<CategoryController>().categoryList ?? <CategoryModel>[];
    final List<FilterCategoryOption> options = <FilterCategoryOption>[];

    for (int index = 0; index < categories.length; index++) {
      final String? id = categories[index].id;
      if(id == null){
        continue;
      }
      options.add(FilterCategoryOption(
        id: id,
        name: categories[index].name ?? '',
        isSelected: index < _categoryCheckList.length && _categoryCheckList[index],
      ));
    }
    return options;
  }

  @override
  void toggleFilterCategory(String categoryId) {
    final List<CategoryModel> categories = Get.find<CategoryController>().categoryList ?? <CategoryModel>[];
    final int index = categories.indexWhere((CategoryModel category) => category.id == categoryId);

    if(index < 0 || index >= _categoryCheckList.length){
      return;
    }

    _categoryCheckList[index] = !_categoryCheckList[index];

    if(_categoryCheckList[index]){
      if(!_selectedCategoryId.contains(categoryId)){
        _selectedCategoryId.add(categoryId);
      }
    }else{
      _selectedCategoryId.remove(categoryId);
    }
    update();
  }

  @override
  bool get hasAppliedFilters => sortedByList.isNotEmpty || filteredByList.isNotEmpty;

  @override
  void clearFilterSelections({bool shouldUpdate = true}){
    clearSortByValues(shouldUpdate: false);
    clearFilterDataValues(shouldUpdate: shouldUpdate);
  }

  Future<void> refreshSearchResult() async {
    if(_showAllServices){
      await loadViewAllServices(offset: 1);
    }else if(_showAllProviders){
      await loadViewAllProviders(offset: 1);
    }else{
      await searchData(query: searchController.text, offset: 1, shouldUpdate: false);
    }
  }

  @override
  Future<void> commitFilters() async {
    Get.dialog(const CustomLoader(), barrierDismissible: false);

    await refreshSearchResult();

    Get.back();
  }

  void removeSortedItem({ AllFilterType? removeItem, bool shouldUpdate = true}){

    if(removeItem == AllFilterType.sortOption){
      _selectedSortByType = "default";
      _selectedSortOption = null;
    }
    else if (removeItem == AllFilterType.query){
      searchController.text = "";
      _isActiveSuffixIcon = false;
    }
    updatedIsSortedAppliedStatus(shouldUpdate: false);

    if(shouldUpdate){
      update();
    }

  }

  void updatedIsSortedAppliedStatus({bool shouldUpdate = true}){
    sortedByList = [];

    if(_selectedSortOption != null){
      sortedByList.add(FilterModel(title: _selectedSortOption!.translationKey, type: AllFilterType.sortOption));
    }
    if(searchController.text.isNotEmpty){
      sortedByList.add(FilterModel(title: searchController.text, type: AllFilterType.query));
    }

   if(shouldUpdate){
     update();
   }
  }

  void updatedIsFilteredAppliedStatus({bool shouldUpdate = true}){

    filteredByList = [];

    if((_filteredMinPrice != null && _filteredMinPrice != _initialMinPrice) || (_filteredMaxPrice != null && _filteredMaxPrice != _initialMaxPrice)){

      filteredByList.add(FilterModel(title: "price", type: AllFilterType.price));
    }
    if(_selectedRatings.isNotEmpty){
      filteredByList.add(FilterModel(title: "rating", type: AllFilterType.rating));
    }

    if(_selectedCategoryId.isNotEmpty){
      for (var element in _selectedCategoryId) {
        filteredByList.add(FilterModel(title: "category", type: AllFilterType.category));

        if (kDebugMode) {
          print(element);
        }
      }
    }


    if(shouldUpdate){
      update();
    }
  }

  void clearAllFilterValue({bool shouldUpdate = false}){
    _searchServiceList = null;
    clearSortByValues(shouldUpdate: shouldUpdate);
    clearFilterDataValues(shouldUpdate: shouldUpdate);
  }

}
