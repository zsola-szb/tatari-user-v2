import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingRebookController extends GetxController implements GetxService {
  final BookingRepo bookingRepo;

  BookingRebookController({required this.bookingRepo});

  EasyRebookPage? _easyRebookPage;
  EasyRebookPage? get easyRebookPage => _easyRebookPage;

  List<EasyRebookItem> get rebookableBookings => List<EasyRebookItem>.unmodifiable(_easyRebookPage?.bookings ?? const <EasyRebookItem>[]);

  EasyRebookPage? _providerRebookPage;
  String _providerRebookId = '';
  EasyRebookPage? get providerRebookPage => _providerRebookPage;

  List<EasyRebookItem> get providerRebookableBookings => List<EasyRebookItem>.unmodifiable(_providerRebookPage?.bookings ?? const <EasyRebookItem>[]);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _activeIndex = -1;
  int get activeIndex => _activeIndex;

  BookingAvailabilityModel _availability = const BookingAvailabilityModel();
  BookingAvailabilityModel get availability => _availability;


  bool get hasPriceChange =>
      _availability.services.any((RebookServiceAvailability service) => service.isPriceChanged);

  bool get hasUnavailableService =>
      _availability.services.any((RebookServiceAvailability service) => !service.isAvailable);

  bool get isEverythingUnavailable => _availability.services.isNotEmpty &&
      _availability.services.every((RebookServiceAvailability service) => !service.isAvailable);

  RebookDecision get decision {
    if (!_availability.isSuccess) {
      return RebookDecision.failed;
    }
    if (!_availability.isProviderAvailable) {
      return RebookDecision.providerUnavailable;
    }
    if (hasUnavailableService || hasPriceChange) {
      return RebookDecision.servicesChanged;
    }
    return RebookDecision.proceed;
  }

  bool canRebook({required BookingStatus status, required BookingKind kind}) =>
      status.isCompleted && !kind.isCustomize &&
      (Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false);

  void setActiveIndex(int index, {bool notify = true}) {
    _activeIndex = index;
    if (notify) {
      update();
    }
  }

  Future<void> loadRebookableBookings({int offset = 1, bool reload = false}) async {
    if (reload) {
      _easyRebookPage = null;
      update();
    }

    _easyRebookPage = await _fetchRebookPage(offset: offset);
    update();
  }

  Future<void> loadProviderRebookableBookings({required String providerId, int offset = 1}) async {
    if (_providerRebookId != providerId) {
      _providerRebookPage = null;
      _providerRebookId = providerId;
      update();
    }

    _providerRebookPage = await _fetchRebookPage(offset: offset, providerId: providerId);
    update();
  }

  Future<EasyRebookPage> _fetchRebookPage({required int offset, String? providerId}) async {
    final Response response = await bookingRepo.getEasyRebookingList(offset: offset, providerId: providerId);
    if (response.statusCode == 200 && response.body is Map) {
      return EasyRebookPage.fromJson(Map<String, dynamic>.from(response.body as Map));
    }

    ApiChecker.checkApi(response);
    return const EasyRebookPage.empty();
  }

  Future<BookingAvailabilityModel> checkAvailability({required String bookingId}) async {
    _isLoading = true;
    update();

    final Response response = await bookingRepo.checkRebookAvailability(bookingId: bookingId);
    _availability = BookingAvailabilityModel.fromResponse(response);

    _isLoading = false;
    update();

    if (!_availability.isSuccess) {
      ApiChecker.checkApi(response);
    }
    return _availability;
  }

  Future<bool> addToCart({required String bookingId}) async {
    _isLoading = true;
    update();

    final Response response = await bookingRepo.addRebookToCart(bookingId: bookingId);

    _isLoading = false;
    _activeIndex = -1;
    update();

    if (response.statusCode == 200) {
      Get.find<CartController>().refreshCart();
      customSnackBar(
        response.body is Map ? '${(response.body as Map)['message']}' : 'added_to_cart'.tr,
        type: ToasterMessageType.success,
      );
      return true;
    }

    ApiChecker.checkApi(response);
    return false;
  }

  bool cartConflictsWith(String subCategoryId) {
    final List<CartItem> cart = Get.find<CartController>().items;
    return cart.isNotEmpty && cart.first.subCategoryId != subCategoryId;
  }

  Future<void> clearCart() async => Get.find<CartController>().removeAllItems();
}
