import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/helper/debounce_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderServiceSearchController extends GetxController implements GetxService {
  final ProviderBookingRepo providerBookingRepo;
  ProviderServiceSearchController({required this.providerBookingRepo});

  static const int debounceMilliseconds = 500;
  static const int pageSize = 10;

  final DebounceHelper _debounce = DebounceHelper(milliseconds: debounceMilliseconds);

  String _query = '';
  String get query => _query;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<Service>? _serviceList;
  List<Service>? get serviceList => _serviceList;

  int _offset = 1;
  int get offset => _offset;

  int _totalSize = 0;
  int get totalSize => _totalSize;

  int _latestRequestId = 0;

  void onQueryChanged(String providerId, String text) {
    final String query = text.trim();

    if (query.isEmpty) {
      clear();
      return;
    }

    _query = query;
    _isSearching = true;
    _serviceList = null;
    update();

    _debounce.run(() => searchServices(providerId: providerId, query: query));
  }

  Future<void> searchServices({required String providerId, required String query, int offset = 1, bool isPagination = false}) async {
    if (query.isEmpty) {
      return;
    }
    _debounce.cancel();

    _query = query;
    _offset = offset;

    if (!isPagination) {
      _serviceList = null;
      _totalSize = 0;
      _isSearching = true;
      update();
    }

    final int requestId = ++_latestRequestId;
    final Response response = await providerBookingRepo.searchProviderServices(
      providerId: providerId, query: query, limit: pageSize, offset: offset,
    );

    if (requestId != _latestRequestId) {
      return;
    }

    if (response.statusCode == 200) {
      final SearchResultModel result = SearchResultModel.fromJson(response.body, type: SearchResultType.services);
      final List<Service> services = result.data?.services ?? <Service>[];

      _serviceList = isPagination ? <Service>[...?_serviceList, ...services] : services;
      _totalSize = result.totalSize ?? _serviceList!.length;
    } else {
      _serviceList = isPagination ? _serviceList : <Service>[];
      ApiChecker.checkApi(response);
    }

    _isSearching = false;
    update();
  }

  void updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}) {
    final int index = _serviceList?.indexWhere((Service service) => service.id == serviceId) ?? -1;
    if (index > -1) {
      _serviceList?[index].isFavorite = status;
    }

    if (shouldUpdate) {
      update();
    }
  }

  void clear({bool shouldUpdate = true}) {
    _debounce.cancel();
    _latestRequestId++;

    _query = '';
    _serviceList = null;
    _isSearching = false;
    _offset = 1;
    _totalSize = 0;

    if (shouldUpdate) {
      update();
    }
  }
}
