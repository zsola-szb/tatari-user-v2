import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CampaignDetailsController extends GetxController implements GetxService {
  final CampaignDetailsRepo campaignDetailsRepo;
  CampaignDetailsController({required this.campaignDetailsRepo});

  static const int servicePageSize = 10;

  static const int categoryPageSize = 100;

  CampaignData? _campaign;
  CampaignData? get campaign => _campaign;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Service> _serviceList = <Service>[];
  List<Service> get serviceList => List<Service>.unmodifiable(_serviceList);

  int _serviceTotalSize = 0;
  int get serviceTotalSize => _serviceTotalSize;

  int _serviceOffset = 1;
  int get serviceOffset => _serviceOffset;

  List<CampaignCategory> _categoryList = <CampaignCategory>[];
  List<CampaignCategory> get categoryList => List<CampaignCategory>.unmodifiable(_categoryList);

  int? _categoryTotalSize;
  int? get categoryTotalSize => _categoryTotalSize;

  final Map<String, List<Service>> _categoryServices = <String, List<Service>>{};
  final Set<String> _expandedCategoryIds = <String>{};
  final Set<String> _loadingCategoryIds = <String>{};

  bool isCategoryExpanded(String categoryId) => _expandedCategoryIds.contains(categoryId);
  bool isCategoryLoading(String categoryId) => _loadingCategoryIds.contains(categoryId);
  List<Service>? servicesOf(String categoryId) => _categoryServices[categoryId];

  Future<void> initCampaign(CampaignData campaign) async {
    _campaign = campaign;
    _isLoading = true;
    _serviceList = <Service>[];
    _serviceTotalSize = 0;
    _serviceOffset = 1;
    _categoryList = <CampaignCategory>[];
    _categoryTotalSize = null;
    _categoryServices.clear();
    _expandedCategoryIds.clear();
    _loadingCategoryIds.clear();
    update();

    if(campaign.isCategoryAndMixedWise){
      await getCampaignCategories();
    }else{
      await getSelectedServices(offset: 1);
    }
  }

  Future<void> getSelectedServices({required int offset}) async {
    final String? campaignId = _campaign?.id;
    if(campaignId == null){
      return;
    }

    final bool isPagination = offset > 1;
    if(!isPagination){
      _isLoading = true;
      update();
    }

    final Response response = await campaignDetailsRepo.getSelectedServices(
      campaignId, offset: offset, limit: servicePageSize,
    );

    if(response.statusCode == 200){
      final ServiceListModel page = ServiceListModel.fromJson(response.body);
      final List<Service> services = page.toServiceList();

      _serviceTotalSize = page.totalSize;
      _serviceOffset = offset;
      _serviceList = isPagination ? <Service>[..._serviceList, ...services] : services;
    }else{
      if(!isPagination){
        _serviceList = <Service>[];
        _serviceTotalSize = 0;
      }
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> getCampaignCategories() async {
    final String? campaignId = _campaign?.id;
    if(campaignId == null){
      return;
    }

    _isLoading = true;
    update();

    final Response response = await campaignDetailsRepo.getCategories(campaignId, offset: 1, limit: categoryPageSize);

    if(response.statusCode == 200){
      final CampaignCategoryListModel page = CampaignCategoryListModel.fromJson(response.body);
      _categoryList = page.categories;
      _categoryTotalSize = page.totalSize;
    }else{
      _categoryList = <CampaignCategory>[];
      _categoryTotalSize = 0;
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

    if(_categoryList.isNotEmpty){
      await toggleCategory(_categoryList.first);
    }
  }

  Future<void> toggleCategory(CampaignCategory category) async {
    final String? categoryId = category.id;
    if(categoryId == null){
      return;
    }

    if(_expandedCategoryIds.contains(categoryId)){
      _expandedCategoryIds.remove(categoryId);
      update();
      return;
    }

    _expandedCategoryIds.add(categoryId);
    update();

    if(_categoryServices.containsKey(categoryId) || _loadingCategoryIds.contains(categoryId)){
      return;
    }

    await getCategoryServices(category);
  }

  Future<void> getCategoryServices(CampaignCategory category) async {
    final String? campaignId = _campaign?.id;
    final String? categoryId = category.id;
    if(campaignId == null || categoryId == null){
      return;
    }

    _loadingCategoryIds.add(categoryId);
    update();

    final Response response = await campaignDetailsRepo.getCategoryServices(
      campaignId, categoryId,
      offset: 1,
      limit: category.totalServices > 0 ? category.totalServices : categoryPageSize,
    );

    if(response.statusCode == 200){
      _categoryServices[categoryId] = ServiceListModel.fromJson(response.body).toServiceList();
    }else{
      _categoryServices[categoryId] = <Service>[];
      ApiChecker.checkApi(response);
    }

    _loadingCategoryIds.remove(categoryId);
    update();
  }

  Future<void> refreshCampaign() async {
    final CampaignData? campaign = _campaign;
    if(campaign == null){
      return;
    }
    await initCampaign(campaign);
  }

  Future<void> loadMoreServices(int offset) async {
    await getSelectedServices(offset: offset);
  }
}