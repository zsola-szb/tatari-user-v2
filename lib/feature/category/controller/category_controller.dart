import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/helper/data_sync_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Service>? _searchProductList = [];
  List<CategoryModel>? _campaignBasedCategoryList ;

  bool _isLoading = false;
  int? _pageSize;
  bool? _isSearching = false;
  final String _type = 'all';
  final String _searchText = '';

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get campaignBasedCategoryList => _campaignBasedCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Service>? get searchServiceList => _searchProductList;
  bool get isLoading => _isLoading;
  int? get pageSize => _pageSize;
  bool? get isSearching => _isSearching;
  String? get type => _type;
  String? get searchText => _searchText;

  static const int _searchHintNameLimit = 8;

  List<String> get searchHintNames => (_categoryList ?? const <CategoryModel>[])
      .map((category) => category.name ?? '').where((name) => name.trim().isNotEmpty).take(_searchHintNameLimit).toList();


  Future<void> getCategoryList(bool reload ) async {

    if(_categoryList == null || reload){
      DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=> categoryRepo.getCategoryList<CacheResponseData>( source: DataSourceEnum.local),
        fetchFromClient: ()=> categoryRepo.getCategoryList(source: DataSourceEnum.client),
        onResponse: (data, source) {

          _categoryList = PaginatedEnvelope.rowsOf(data)
              .map((Map<String, dynamic> category) => CategoryModel.fromJson(category)).toList();
          Get.find<AllSearchController>().insertCategoryCheckedList();
          update();
        },
      );
    }
  }


  Future<void> getSubCategoryList(String categorySlug, {bool shouldUpdate = true}) async {
    _subCategoryList = null;
    if(shouldUpdate){
      update();
    }
    Response response = await categoryRepo.getSubCategoryList(categorySlug);
    if (response.statusCode == 200 && response.body['response_code'] == 'default_200') {
      _subCategoryList = PaginatedEnvelope.rowsOf(response.body)
          .map((Map<String, dynamic> category) => CategoryModel.fromJson(category))
          .where((CategoryModel category) => category.isActive ?? false).toList();
    } else {
      _subCategoryList= [];
    }
    update();
  }



  void toggleSearch() {
    _isSearching = !_isSearching!;
    _searchProductList = [];
    update();
  }
  void showBottomLoader() {
    _isLoading = true;
    update();
  }

}
