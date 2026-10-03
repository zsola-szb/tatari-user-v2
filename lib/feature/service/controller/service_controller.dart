
import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/common/models/api_response_model.dart';
import 'package:tatarigigs_user/feature/service/model/recommendation_search_model.dart';
import 'package:tatarigigs_user/helper/data_sync_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class ServiceController extends GetxController implements GetxService {
  final ServiceRepo serviceRepo;
  ServiceController({required this.serviceRepo});

  static const int featuredCategoryServiceLimit = 6;


  bool _isLoading = false;
  List<int>? _variationIndex;

  final int _cartIndex = -1;


  ServiceListModel? _allServicePage;
  ServiceContent? _popularBasedServiceContent;
  ServiceContent? _recommendedServiceContent;
  ServiceContent? _trendingServiceContent;
  ServiceContent? _recentlyViewServiceContent;
  ServiceContent? _subcategoryBasedServiceContent;
  FeatheredCategoryContent? _featheredCategoryContent;



  ServiceListModel? get allServicePage => _allServicePage;
  ServiceContent? get popularBasedServiceContent => _popularBasedServiceContent;
  ServiceContent? get recommendedBasedServiceContent => _recommendedServiceContent;
  ServiceContent? get trendingServiceContent => _trendingServiceContent;
  ServiceContent? get recentlyViewServiceContent => _recentlyViewServiceContent;
  ServiceContent? get subcategoryBasedServiceContent => _subcategoryBasedServiceContent;
  FeatheredCategoryContent? get featheredCategoryContent => _featheredCategoryContent;

  List<Service>? _popularServiceList;
  List<Service>? _trendingServiceList;
  List<Service>? _recentlyViewServiceList;
  List<Service>? _recommendedServiceList;
  List<RecommendedSearch>? _recommendedSearchList;
  List<Service>? _subCategoryBasedServiceList;
  List<Service>? _campaignBasedServiceList;
  List<Service>? _allService;
  List<CategoryData>? _categoryList;


  List<Service>? get allService => _allService ;
  List<Service>? get popularServiceList => _popularServiceList;
  List<Service>? get trendingServiceList => _trendingServiceList;
  List<Service>? get recentlyViewServiceList => _recentlyViewServiceList;
  List<Service>? get recommendedServiceList => _recommendedServiceList;
  List<Service>? get subCategoryBasedServiceList => _subCategoryBasedServiceList;
  List<Service>? get campaignBasedServiceList => _campaignBasedServiceList;
  List<RecommendedSearch>? get recommendedSearchList => _recommendedSearchList;
  List<CategoryData>? get categoryList => _categoryList ;


  bool get isLoading => _isLoading;
  List<int>? get variationIndex => _variationIndex;

  int get cartIndex => _cartIndex;

  String? _fromPage;
  String? get fromPage => _fromPage!;

  final List<double> _lowestPriceList = [];
  List<double> get lowestPriceList => _lowestPriceList;

  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.find<AuthController>().isLoggedIn()) {
     await Get.find<UserController>().getUserInfo();
    }

    await Get.find<CartController>().refreshCart();
  }



  Future<void> getAllServiceList(int offset, bool reload) async {

    if(offset != 1 || _allService == null || reload){
      if(offset == 1){
        DataSyncHelper.fetchAndSyncData(
          fetchFromLocal: ()=>  serviceRepo.getAllServiceList<CacheResponseData>( source: DataSourceEnum.local),
          fetchFromClient: ()=>  serviceRepo.getAllServiceList(source: DataSourceEnum.client),
          onResponse: (data, source) {
            final ServiceListModel page = ServiceListModel.fromJson(data);
            _allServicePage = page;
            _allService = <Service>[...page.toServiceList()];
            update();
          },
        );
      }else{

        ApiResponseModel response = await serviceRepo.getAllServiceList(offset : offset, source: DataSourceEnum.client);
        if (response.response.statusCode == 200) {
          if(reload){
            _allService = [];
          }
          final ServiceListModel page = ServiceListModel.fromJson(response.response.body);
          _allServicePage = page;
          if(_allService != null && offset != 1 ){
            _allService!.addAll(page.toServiceList());
          }

        } else {
          ApiChecker.checkApi(response.response);
        }
        update();
      }
    }
  }


  Future<void> getPopularServiceList(int offset, bool reload) async {

    if(offset != 1 || _popularServiceList == null || reload ){

      if(offset ==1){

        DataSyncHelper.fetchAndSyncData(
          fetchFromLocal: ()=> serviceRepo.getPopularServiceList<CacheResponseData>( source: DataSourceEnum.local),
          fetchFromClient: ()=> serviceRepo.getPopularServiceList(source: DataSourceEnum.client),
          onResponse: (data, source) {
            _popularBasedServiceContent = ServiceModel.fromJson(data).content;
            _popularServiceList = [];
            _popularServiceList!.addAll(_popularBasedServiceContent!.serviceList!);

            update();
          },
        );

      }else{

        ApiResponseModel response = await serviceRepo.getPopularServiceList(offset: offset, source: DataSourceEnum.client);
        if (response.response.statusCode == 200) {
          _popularBasedServiceContent = ServiceModel.fromJson(response.response?.body).content;

          if(_popularServiceList != null && offset != 1){
            _popularServiceList!.addAll(_popularBasedServiceContent?.serviceList ?? []);
          }
        } else {
          ApiChecker.checkApi(response.response);
        }
        update();
      }

    }
  }


  Future<void> getTrendingServiceList(int offset, bool reload) async {
    if(offset != 1 || _trendingServiceList == null || reload ){

      if(offset == 1){

        DataSyncHelper.fetchAndSyncData(
          fetchFromLocal: ()=> serviceRepo.getTrendingServiceList<CacheResponseData>( source: DataSourceEnum.local),
          fetchFromClient: ()=> serviceRepo.getTrendingServiceList(source: DataSourceEnum.client),
          onResponse: (data, source) {
            _trendingServiceContent = ServiceModel.fromJson(data).content;
            _trendingServiceList = [];
            _trendingServiceList!.addAll(_trendingServiceContent!.serviceList!);

            update();
          },
        );

      }else{
        ApiResponseModel response = await serviceRepo.getTrendingServiceList(offset: offset, source: DataSourceEnum.client);
        if (response.response.statusCode == 200) {
          if(reload){
            _trendingServiceList = [];
          }
          _trendingServiceContent = ServiceModel.fromJson(response.response.body).content;
          if(_trendingServiceList != null && offset != 1){
            _trendingServiceList!.addAll(_trendingServiceContent!.serviceList!);
          }
        } else {
          ApiChecker.checkApi(response.response);
        }
        update();
      }

    }
  }



  Future<void> getRecommendedServiceList(int offset, bool reload ) async {
   if(offset != 1 || _recommendedServiceList == null || reload){

     if(offset == 1){
       DataSyncHelper.fetchAndSyncData(
         fetchFromLocal: ()=> serviceRepo.getRecommendedServiceList<CacheResponseData>( source: DataSourceEnum.local),
         fetchFromClient: ()=> serviceRepo.getRecommendedServiceList(source: DataSourceEnum.client),
         onResponse: (data, source) {
           _recommendedServiceContent = ServiceModel.fromJson(data).content;
           _recommendedServiceList = [];
           _recommendedServiceList!.addAll( _recommendedServiceContent!.serviceList!);
           update();
         },
       );
     }else{
       ApiResponseModel response =  await serviceRepo.getRecommendedServiceList(offset: offset, source: DataSourceEnum.client);
       if (response.response.statusCode == 200) {
         if(reload){
           _recommendedServiceList = [];
         }
         _recommendedServiceContent = ServiceModel.fromJson(response.response.body).content;
         if(_recommendedServiceList != null && offset != 1){
           _recommendedServiceList!.addAll( _recommendedServiceContent!.serviceList!);
         }
       } else {
         ApiChecker.checkApi(response.response);
       }
       update();
     }
   }
  }


  Future<void> getRecentlyViewedServiceList(int offset, bool reload) async {
    if(offset != 1 || _recentlyViewServiceList == null || reload ){

      if(offset == 1){
        DataSyncHelper.fetchAndSyncData(
          fetchFromLocal: ()=> serviceRepo.getRecentlyViewedServiceList<CacheResponseData>( source: DataSourceEnum.local),
          fetchFromClient: ()=> serviceRepo.getRecentlyViewedServiceList(source: DataSourceEnum.client),
          onResponse: (data, source) {
            _recentlyViewServiceContent = ServiceModel.fromJson(data).content;
            _recentlyViewServiceList = [];
            _recentlyViewServiceList!.addAll(_recentlyViewServiceContent!.serviceList!);
            update();
          },
        );
      }else{
        ApiResponseModel response = await serviceRepo.getRecentlyViewedServiceList(offset: offset, source: DataSourceEnum.client);
        if (response.response.statusCode == 200) {
          if(reload){
            _recentlyViewServiceList = [];
          }
          _recentlyViewServiceContent = ServiceModel.fromJson(response.response.body).content;
          if(_recentlyViewServiceList != null && offset != 1){
            _recentlyViewServiceList!.addAll(_recentlyViewServiceContent!.serviceList!);
          }
        }
        update();
      }

    }
  }



  /// The featured-category endpoint only returns the categories themselves — the services of
  /// each one are fetched on demand by slug, and kept here so switching tabs back and forth
  /// (or refreshing the category list) doesn't re-hit the network.
  final Map<String, List<Service>> _featuredCategoryServices = <String, List<Service>>{};
  final Map<String, int> _fetchedFeaturedCategoryLimits = <String, int>{};
  final Set<String> _loadingFeaturedCategorySlugs = <String>{};

  List<Service>? featuredCategoryServices(String? categorySlug) =>
      categorySlug == null ? const <Service>[] : _featuredCategoryServices[categorySlug];

  bool isFeaturedCategoryServiceLoading(String? categorySlug) =>
      categorySlug != null && _loadingFeaturedCategorySlugs.contains(categorySlug);

  Future<void> getFeatherCategoryList( bool reload) async {

    if(_featheredCategoryContent == null || reload){

      if(reload){
        _categoryList =[];
        _featheredCategoryContent = null;
        _featuredCategoryServices.clear();
        _fetchedFeaturedCategoryLimits.clear();
        _loadingFeaturedCategorySlugs.clear();
      }

      DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=> serviceRepo.getFeatheredCategoryServiceList<CacheResponseData>( source: DataSourceEnum.local),
        fetchFromClient: ()=> serviceRepo.getFeatheredCategoryServiceList(source: DataSourceEnum.client),
        onResponse: (data, source) {
          _featheredCategoryContent = FeatheredCategoryModel.fromJson(data).content;

          _categoryList = <CategoryData>[];
          _featheredCategoryContent?.categoryList?.forEach((CategoryData category) {
            /// Keep a category when it has services, or when the backend didn't say how many it has.
            if((category.totalServices ?? 1) > 0){
              category.servicesByCategory = _featuredCategoryServices[category.slug] ?? category.servicesByCategory;
              _categoryList!.add(category);
            }
          });
          update();
        },
      );
    }
  }

  Future<void> getFeaturedCategoryServiceList(String? categorySlug, {int limit = featuredCategoryServiceLimit, bool reload = false}) async {
    if(categorySlug == null || categorySlug.isEmpty || _loadingFeaturedCategorySlugs.contains(categorySlug)){
      return;
    }
    /// Already have at least as many services as the caller asked for.
    if(!reload && (_fetchedFeaturedCategoryLimits[categorySlug] ?? 0) >= limit){
      return;
    }

    _loadingFeaturedCategorySlugs.add(categorySlug);
    update();

    final ApiResponseModel response = await serviceRepo.getCategoryWiseServiceList(
      source: DataSourceEnum.client,
      categorySlug: categorySlug,
      offset: 1,
      limit: limit,
    );

    _loadingFeaturedCategorySlugs.remove(categorySlug);

    List<Service> services = <Service>[];
    if(response.response.statusCode == 200){
      services = ServiceListModel.fromJson(response.response.body).toServiceList();
      _fetchedFeaturedCategoryLimits[categorySlug] = limit;
    }else{
      ApiChecker.checkApi(response.response);
    }

    _featuredCategoryServices[categorySlug] = services;
    for(final CategoryData category in _categoryList ?? <CategoryData>[]){
      if(category.slug == categorySlug){
        category.servicesByCategory = services;
      }
    }
    update();
  }


  Future<void> getSubCategoryBasedServiceList(String subCategoryID, {bool isShouldUpdate = true, bool showShimmerAlways = false, int offset = 1}) async {
    if(subCategoryID !=""){

      Response response = await serviceRepo.getServiceListBasedOnSubCategory(subCategoryID: subCategoryID,offset: offset);
      if (response.statusCode == 200) {
        _subcategoryBasedServiceContent = ServiceModel.fromJson(response.body).content;
        if(offset !=1 && _subCategoryBasedServiceList !=null ){
          _subCategoryBasedServiceList!.addAll(_subcategoryBasedServiceContent?.serviceList ?? []);
        }else{
          _subCategoryBasedServiceList = [];
          _subCategoryBasedServiceList!.addAll(_subcategoryBasedServiceContent?.serviceList ?? []);
        }
      } else {
        ApiChecker.checkApi(response);
      }

      if(isShouldUpdate){
        update();
      }

    }else{
      _subCategoryBasedServiceList = [];
    }
  }

  static const int subCategoryTabPageSize = 10;

  final Map<String, List<Service>> _subCategoryTabServiceListMap = {};
  final Map<String, ServiceContent> _subCategoryTabServiceContentMap = {};

  List<Service>? subCategoryTabServiceList(String subCategorySlug) => _subCategoryTabServiceListMap[subCategorySlug];
  ServiceContent? subCategoryTabServiceContent(String subCategorySlug) => _subCategoryTabServiceContentMap[subCategorySlug];

  bool isSubCategoryTabFullyLoaded(String subCategorySlug) {
    final content = _subCategoryTabServiceContentMap[subCategorySlug];
    if(content?.currentPage == null || content?.lastPage == null){
      return false;
    }
    return content!.currentPage! >= content.lastPage!;
  }

  Future<void> getSubCategoryTabServiceList(String subCategorySlug, {required int offset}) async {
    if(subCategorySlug.isEmpty){
      _subCategoryTabServiceContentMap[subCategorySlug] = ServiceContent(currentPage: 1, lastPage: 1, total: 0, serviceList: []);
      _subCategoryTabServiceListMap[subCategorySlug] = [];
      update();
      return;
    }
    Response response = await serviceRepo.getServiceListBasedOnSubCategory(subCategoryID: subCategorySlug, offset: offset, limit: subCategoryTabPageSize);
    if (response.statusCode == 200) {
      final content = ServiceModel.fromJson(response.body).content;
      _subCategoryTabServiceContentMap[subCategorySlug] = content ?? ServiceContent();
      final existing = offset == 1 ? <Service>[] : List<Service>.from(_subCategoryTabServiceListMap[subCategorySlug] ?? []);
      existing.addAll(content?.serviceList ?? []);
      _subCategoryTabServiceListMap[subCategorySlug] = existing;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> getRecommendedSearchList({bool reload = false}) async {

    if(_recommendedSearchList == null || reload){
      if(reload){
        _recommendedSearchList = null;
        update();
      }
      Response response = await serviceRepo.getRecommendedSearchList();
      if (response.statusCode == 200) {
        final dynamic list = response.body is Map ? (response.body['data'] ?? response.body['content']) : null;
        if(list is List){
          _recommendedSearchList = list.whereType<Map<String, dynamic>>()
              .map((Map<String, dynamic> element) => RecommendedSearch.fromJson(element)).toList();
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }

  }

  int _apiHitCount = 0;

  Future<int?> updateIsFavoriteStatus({required String serviceId, required int currentStatus}) async {
    _apiHitCount++;

    Response response = await serviceRepo.updateIsFavoriteStatus(serviceId: serviceId);
    _apiHitCount--;
    int? updatedStatus;
    int status;
    if(response.statusCode == 200 && (response.body['response_code'] == "service_favorite_store_200" || response.body['response_code'] == "service_remove_favorite_200")){
      if(response.body['content']['status'] !=null){
        status  = response.body['content']['status'];
        updatedStatus = status;

        customSnackBar(status == 1 ? 'service_added_as_favorite_successfully'.tr : 'service_removed_as_favorite_successfully'.tr,type: status == 1 ? ToasterMessageType.success : ToasterMessageType.error);
        updateIsFavoriteValue(status, serviceId);
      }
    }
    if(_apiHitCount == 0){
      update();
    }

    return updatedStatus;
  }

  void updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}){
    if(_allService !=null){
      int? index = _allService?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _allService![index].isFavorite = status;
      }
    }

    if(_popularServiceList !=null){
      int? index = _popularServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _popularServiceList![index].isFavorite = status;
      }
    }

    if(_trendingServiceList !=null) {
      int? index = _trendingServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _trendingServiceList![index].isFavorite = status;
      }
    }

    if(_recentlyViewServiceList !=null){
      int? index = _recentlyViewServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _recentlyViewServiceList![index].isFavorite = status;
      }
    }

    if(_recommendedServiceList !=null){
      int? index = _recommendedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _recommendedServiceList![index].isFavorite = status ;
      }
    }

    if(_subCategoryBasedServiceList !=null){
      int? index = _subCategoryBasedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _subCategoryBasedServiceList![index].isFavorite = status ;
      }
    }

    if(_campaignBasedServiceList !=null){
      int? index = _subCategoryBasedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _subCategoryBasedServiceList![index].isFavorite = status ;
      }
    }

    _subCategoryTabServiceListMap.forEach((slug, list) {
      int index = list.indexWhere((element) => element.id == serviceId);
      if(index > -1){
        list[index].isFavorite = status;
      }
    });

    for(int categoryIndex = 0; categoryIndex < (_categoryList?.length ?? 0) ; categoryIndex ++){
      int? serviceIndex = _categoryList![categoryIndex].servicesByCategory?.indexWhere((element) => element.id ==serviceId);

      if(serviceIndex !=null && serviceIndex>-1){
        _categoryList![categoryIndex].servicesByCategory?[serviceIndex].isFavorite = status;
      }
    }

    Get.find<AllSearchController>().updateIsFavoriteValue(status, serviceId, shouldUpdate: shouldUpdate);
    Get.find<ProviderBookingController>().updateServiceIsFavoriteValue(status, serviceId, shouldUpdate: shouldUpdate);
    Get.find<ProviderServiceSearchController>().updateIsFavoriteValue(status, serviceId, shouldUpdate: shouldUpdate);
    Get.find<OffersController>().updateIsFavoriteValue(status, serviceId, shouldUpdate: shouldUpdate);

    if(shouldUpdate){
      update();
    }
  }


   void cleanSubCategory(){
    _subCategoryBasedServiceList = null;
    update();
  }


  Future<void> getEmptyCampaignService()async {
    _campaignBasedServiceList = null;
  }


}
