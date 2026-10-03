import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AllCartController extends GetxController implements GetxService {
  static const int pageLimit = 10;

  final CartRepo cartRepo;

  AllCartController({required this.cartRepo});

  AllCartStatus _status = AllCartStatus.loading;
  AllCartStatus get status => _status;

  bool get isLoading => _status == AllCartStatus.loading;
  bool get isEmpty => _status == AllCartStatus.empty;

  List<CartProviderGroup> _groups = <CartProviderGroup>[];
  List<CartProviderGroup> get groups => List<CartProviderGroup>.unmodifiable(_groups);

  int _totalSize = 0;
  int get totalSize => _totalSize;

  int _offset = 1;
  int get currentPage => _offset;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  int _requestId = 0;

  int _seenCartRevision = -1;

  CartController get _cartController => Get.find<CartController>();

  bool get _isStale => _seenCartRevision != _cartController.cartRevision;

  Future<void> initData() => loadIfStale();

  Future<void> loadIfStale() async {
    if (!_isStale && _status != AllCartStatus.error) {
      return;
    }
    await loadGroups(offset: 1, silent: _groups.isNotEmpty);
  }

  Future<void> loadGroups({
    required int offset,
    bool isPagination = false,
    bool silent = false,
  }) async {
    if (_cartController.cartRevision > 0 && _cartController.cart.isEmpty) {
      _groups = <CartProviderGroup>[];
      _totalSize = 0;
      _offset = 1;
      _status = AllCartStatus.empty;
      _seenCartRevision = _cartController.cartRevision;
      update();
      return;
    }

    if (!isPagination && !silent) {
      _status = AllCartStatus.loading;
      update();
    }

    final int requestId = ++_requestId;
    final int revisionAtRequest = _cartController.cartRevision;

    final Response response = await cartRepo.getCartProviders(limit: pageLimit, offset: offset);

    if (requestId != _requestId) {
      return;
    }

    if (response.statusCode == 200 && response.body is Map<String, dynamic>) {
      final CartProviderPage page = CartProviderPage.fromJson(response.body);

      _totalSize = page.totalSize;
      _offset = offset;
      _groups = isPagination ? <CartProviderGroup>[..._groups, ...page.groups] : page.groups;
      _status = _groups.isEmpty ? AllCartStatus.empty : AllCartStatus.ready;
      _seenCartRevision = revisionAtRequest;
    } else {
      if (!isPagination) {
        _groups = <CartProviderGroup>[];
        _totalSize = 0;
      }
      _status = _groups.isEmpty ? AllCartStatus.error : AllCartStatus.ready;
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> loadPage(int offset) => loadGroups(offset: offset, isPagination: true);

  Future<void> refreshGroups() => loadGroups(offset: 1);

  Future<void> deleteGroup(String providerId) async {
    if (_isUpdating || providerId.isEmpty) {
      return;
    }
    _isUpdating = true;
    update();

    await _cartController.clearProviderCart(providerId);
    await loadGroups(offset: 1, silent: true);

    _isUpdating = false;
    update();
  }

  Future<void> clearAll() async {
    if (_isUpdating) {
      return;
    }
    _isUpdating = true;
    update();

    await _cartController.removeAllItems();
    await loadGroups(offset: 1, silent: true);

    _isUpdating = false;
    update();
  }
}