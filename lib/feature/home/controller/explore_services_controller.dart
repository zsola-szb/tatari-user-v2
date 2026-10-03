import 'package:tatarigigs_user/common/models/api_response_model.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ExploreServicesController extends GetxController implements GetxService {
  final ServiceRepo serviceRepo;
  ExploreServicesController({required this.serviceRepo});

  static const int pageSize = 10;

  String? _selectedCategoryId;
  String? _selectedCategorySlug;
  List<Service>? _categoryServiceList;
  ServiceListModel? _categoryServicePage;

  int _requestId = 0;

  String? get selectedCategoryId => _selectedCategoryId;
  bool get isAllSelected => _selectedCategorySlug == null;

  ServiceController get _serviceController => Get.find<ServiceController>();

  List<Service>? get serviceList => isAllSelected ? _serviceController.allService : _categoryServiceList;
  int? get totalSize => isAllSelected ? _serviceController.allServicePage?.totalSize : _categoryServicePage?.totalSize;
  int? get currentPage => isAllSelected ? _serviceController.allServicePage?.offset : _categoryServicePage?.offset;

  void selectCategory(CategoryModel? category) {
    if (_selectedCategoryId == category?.id) {
      return;
    }
    _selectedCategoryId = category?.id;
    _selectedCategorySlug = category?.slug;
    _categoryServiceList = null;
    _categoryServicePage = null;
    _requestId++;
    update();

    if (!isAllSelected) {
      getCategoryWiseServiceList(offset: 1);
    }
  }

  Future<void> loadMore(int offset) async {
    if (isAllSelected) {
      await _serviceController.getAllServiceList(offset, false);
    } else {
      await getCategoryWiseServiceList(offset: offset);
    }
  }

  Future<void> refreshSelectedCategory() async {
    if (isAllSelected) {
      return;
    }
    _categoryServiceList = null;
    _categoryServicePage = null;
    update();
    await getCategoryWiseServiceList(offset: 1);
  }

  Future<void> getCategoryWiseServiceList({required int offset}) async {
    final String? categorySlug = _selectedCategorySlug;
    if (categorySlug == null) {
      return;
    }

    final int requestId = ++_requestId;
    final ApiResponseModel response = await serviceRepo.getCategoryWiseServiceList(
      source: DataSourceEnum.client,
      categorySlug: categorySlug,
      offset: offset,
      limit: pageSize,
    );

    if (requestId != _requestId) {
      return;
    }

    if (response.response.statusCode == 200) {
      final ServiceListModel page = ServiceListModel.fromJson(response.response.body);
      _categoryServicePage = page;
      final List<Service> services = offset == 1 ? <Service>[] : List<Service>.from(_categoryServiceList ?? <Service>[]);
      services.addAll(page.toServiceList());
      _categoryServiceList = services;
    } else {
      _categoryServiceList = <Service>[];
      ApiChecker.checkApi(response.response);
    }
    update();
  }
}
