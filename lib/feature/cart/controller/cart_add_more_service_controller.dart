import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/helper/debounce_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartAddMoreServiceController extends GetxController implements GetxService {
  static const int pageLimit = 10;

  final SearchRepo searchRepo;

  CartAddMoreServiceController({required this.searchRepo});

  final DebounceHelper _searchDebounce = DebounceHelper(milliseconds: 500);

  int _requestId = 0;

  List<Service> _services = <Service>[];
  List<Service> get services => List<Service>.unmodifiable(_services);

  int _totalSize = 0;
  int get totalSize => _totalSize;

  int _offset = 1;
  int get currentPage => _offset;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool get isEmpty => !_isLoading && _services.isEmpty;

  String _query = '';
  String get query => _query;

  @override
  void onClose() {
    _searchDebounce.cancel();
    super.onClose();
  }

  Future<void> initData() async {
    _searchDebounce.cancel();
    _query = '';
    _services = <Service>[];
    _totalSize = 0;
    _offset = 1;

    await getServiceList(offset: 1);
  }

  Future<void> getServiceList({required int offset}) async {
    final bool isPagination = offset > 1;

    if (!isPagination) {
      _isLoading = true;
      update();
    }

    final int requestId = ++_requestId;

    final Response response = await searchRepo.getSearchData(
      type: SearchResultType.services,
      query: _query.trim(),
      offset: offset,
      limit: pageLimit,
      sortByType: '',
      minPrice: 0,
      maxPrice: 0,
    );

    if (requestId != _requestId) {
      return;
    }

    if (response.statusCode == 200 && response.body is Map<String, dynamic>) {
      final SearchResultModel result = SearchResultModel.fromJson(response.body, type: SearchResultType.services);
      final List<Service> services = result.data?.services ?? <Service>[];

      _totalSize = result.totalSize ?? (isPagination ? _totalSize : services.length);
      _offset = offset;
      _services = isPagination ? <Service>[..._services, ...services] : services;
    } else {
      if (!isPagination) {
        _services = <Service>[];
        _totalSize = 0;
      }
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> loadPage(int offset) => getServiceList(offset: offset);

  Future<void> refreshServices() => getServiceList(offset: 1);

  void onSearchChanged(String value) {
    if (_query == value) {
      return;
    }
    _query = value;
    update();

    _searchDebounce.run(() => getServiceList(offset: 1));
  }

  void submitSearch(String value) {
    _searchDebounce.cancel();
    _query = value;

    getServiceList(offset: 1);
  }

  void clearSearch() {
    _searchDebounce.cancel();
    _query = '';

    getServiceList(offset: 1);
  }
}