import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;

  CartController({required this.cartRepo});

  CartStatus _status = CartStatus.loading;
  CartStatus get status => _status;

  bool get isLoading => _status == CartStatus.loading;

  bool get isUpdating => _status == CartStatus.updating;

  String _updatingServiceId = '';

  bool isCartUpdatingForService(String serviceId) =>
      isUpdating && serviceId.isNotEmpty && _updatingServiceId == serviceId;

  CartContents _cart = const CartContents.empty();
  CartContents get cart => _cart;

  CartTotals _totals = const CartTotals.empty();
  CartTotals get totals => _totals;

  List<CartServiceGroup> get groups => List<CartServiceGroup>.unmodifiable(_cart.groups);

  String _scopeProviderId = '';
  bool get isProviderScoped => _scopeProviderId.isNotEmpty;
  String get scopeProviderId => _scopeProviderId;

  CartContents _providerScopedCart = const CartContents.empty();
  CartTotals _providerScopedTotals = const CartTotals.empty();

  CartContents get visibleCart => isProviderScoped ? _providerScopedCart : _cart;

  CartTotals get visibleTotals => isProviderScoped ? _providerScopedTotals : _totals;

  List<CartServiceGroup> get visibleGroups => List<CartServiceGroup>.unmodifiable(visibleCart.groups);

  int _cartRevision = 0;
  int get cartRevision => _cartRevision;

  void setProviderScope(String providerId, {bool notify = false}) {
    if (_scopeProviderId == providerId) {
      return;
    }
    _scopeProviderId = providerId;
    _providerScopedCart = const CartContents.empty();
    _providerScopedTotals = const CartTotals.empty();
    if (notify) {
      update();
    }
  }

  void clearProviderScope({bool notify = true}) {
    if (_scopeProviderId.isEmpty) {
      return;
    }
    _scopeProviderId = '';
    _providerScopedCart = const CartContents.empty();
    _providerScopedTotals = const CartTotals.empty();
    if (notify) {
      update();
    }
  }

  final Set<String> _expandedServiceIds = <String>{};
  bool isGroupExpanded(String serviceId) => _expandedServiceIds.contains(serviceId);

  bool _isBillingExpanded = false;
  bool get isBillingExpanded => _isBillingExpanded;

  List<ProviderData>? _providerList;
  List<ProviderData>? get providerList => _providerList == null ? null : List<ProviderData>.unmodifiable(_providerList!);

  List<Service>? _suggestedServices;
  List<Service>? get suggestedServices =>
      _suggestedServices == null ? null : List<Service>.unmodifiable(_suggestedServices!);

  int _selectedProviderIndex = -1;
  int get selectedProviderIndex => _selectedProviderIndex;

  Future<void>? _inFlightLoad;

  void _notifyAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  Future<void> initData({String providerId = ''}) async {
    setProviderScope(providerId);

    _status = CartStatus.loading;
    _cart = const CartContents.empty();
    _totals = const CartTotals.empty();
    _providerScopedCart = const CartContents.empty();
    _providerScopedTotals = const CartTotals.empty();
    _expandedServiceIds.clear();
    _isBillingExpanded = false;
    _providerList = null;
    _selectedProviderIndex = -1;
    _suggestedServices = null;
    _notifyAfterFrame();

    await _loadCart();

    _status = CartStatus.idle;
    update();

    if (_cart.isNotEmpty) {
      loadCustomersAlsoTake();
    }
  }

  Future<void> loadCustomersAlsoTake() async {
    final Response response = await cartRepo.getCustomersAlsoTake();

    _suggestedServices = response.statusCode == 200 ? _parseSuggestedServices(response.body) : <Service>[];
    update();
  }

  List<Service> _parseSuggestedServices(dynamic body) {
    if (body is! Map<String, dynamic>) {
      return <Service>[];
    }

    final List<Service> services = ServiceListModel.fromJson(body).toServiceList();
    if (services.isNotEmpty) {
      return services;
    }

    final dynamic content = body['content'];
    if (content is List) {
      return content
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> row) => ServiceItemModel.fromJson(row).toService()).toList();
    }
    return <Service>[];
  }

  Future<void> refreshCart({bool notify = true}) async {
    await _loadCart();
    if (notify) {
      update();
    }
  }

  String? _inFlightScope;

  Future<void> _loadCart() {
    final String scope = _scopeProviderId;
    final Future<void>? inFlight = _inFlightLoad;

    if (inFlight != null && _inFlightScope == scope) {
      return inFlight;
    }

    _inFlightScope = scope;
    return _inFlightLoad = _performLoad(scope).whenComplete(() => _inFlightLoad = null);
  }

  Future<void> _performLoad(String scope) async {

    final List<Response> responses = await Future.wait<Response>(<Future<Response>>[
      if (scope.isNotEmpty) cartRepo.getCartList(providerId: scope)
      else cartRepo.getCartList(),
    ]);

    final Response globalResponse = responses.first;
    if (globalResponse.statusCode != 200 || globalResponse.body is! Map<String, dynamic>) {
      if (globalResponse.statusCode != 200) {
        ApiChecker.checkApi(globalResponse);
      }
      return;
    }

    _cart = CartContents.fromJson(globalResponse.body);
    _totals = _buildTotals(_cart);
    _cartRevision++;

    if (scope.isNotEmpty && scope == _scopeProviderId) {
      final Response scopedResponse = responses.last;
      if (scopedResponse.statusCode == 200 && scopedResponse.body is Map<String, dynamic>) {
        _providerScopedCart = CartContents.fromJson(scopedResponse.body);
        _providerScopedTotals = _buildTotals(_providerScopedCart);
      } else if (scopedResponse.statusCode != 200) {
        ApiChecker.checkApi(scopedResponse);
      }
    }

    _expandedServiceIds.removeWhere(
      (String id) => !visibleCart.groups.any((CartServiceGroup group) => group.serviceId == id),
    );
  }

  CartTotals _buildTotals(CartContents cart) {
    if (cart.isEmpty) {
      return const CartTotals.empty();
    }

    final List<CartItem> items = cart.items;

    final double subTotal = CheckoutHelper.calculateSubTotal(cartList: items);
    final double vat = CheckoutHelper.calculateVat(cartList: items);
    final double discount =
        CheckoutHelper.calculateDiscount(cartList: items, discountType: DiscountType.general) +
        CheckoutHelper.calculateDiscount(cartList: items, discountType: DiscountType.campaign) +
        CheckoutHelper.calculateDiscount(cartList: items, discountType: DiscountType.coupon);

    double grandTotal = CheckoutHelper.calculateGrandTotal(cartList: items, referralDiscount: 0);

    final double proDiscount = cart.proDiscountAmount;
    if (proDiscount > 0 && cart.proBenefitType != 'coupon') {
      grandTotal -= proDiscount;
    }

    return CartTotals(
      subTotal: subTotal,
      discount: discount,
      vat: vat,
      additionalCharge: CheckoutHelper.getAdditionalCharge(),
      proDiscount: proDiscount,
      proBenefitType: cart.proBenefitType,
      grandTotal: grandTotal < 0 ? 0 : grandTotal,
    );
  }

  void toggleGroupExpanded(String serviceId, {bool notify = true}) {
    if (!_expandedServiceIds.remove(serviceId)) {
      _expandedServiceIds.add(serviceId);
    }
    if (notify) {
      update();
    }
  }

  void expandGroup(String serviceId, {bool notify = true}) {
    if (_expandedServiceIds.add(serviceId) && notify) {
      update();
    }
  }

  void toggleBillingExpanded({bool notify = true}) {
    _isBillingExpanded = !_isBillingExpanded;
    if (notify) {
      update();
    }
  }

  static String _responseCode(Response response) {
    final dynamic body = response.body;
    return body is Map ? '${body['response_code']}' : '';
  }

  Future<void> _runCartUpdate(Future<Response> Function() action, {String serviceId = ''}) async {
    if (_status == CartStatus.updating) {
      return;
    }
    _updatingServiceId = serviceId;
    _status = CartStatus.updating;
    update();

    final Response response = await action();
    if (response.statusCode == 200) {
      await _loadCart();
    } else {
      await _handleUpdateFailure(response);
    }

    _updatingServiceId = '';
    _status = CartStatus.idle;
    update();
  }

  Future<void> _handleUpdateFailure(Response response) async {
    if (response.statusCode == 404) {
      customSnackBar('cart_item_no_longer_exists'.tr, type: ToasterMessageType.info);
      await _loadCart();
      return;
    }
    if (response.statusCode == 403 && _responseCode(response) == 'curated_feature_only_403') {
      customSnackBar('provider_selection_is_not_available_here'.tr, type: ToasterMessageType.info);
      return;
    }
    ApiChecker.checkApi(response);
  }

  Future<void> incrementItem(CartItem item) => _runCartUpdate(
      () => cartRepo.updateQuantity(cartId: item.id, quantity: item.quantity + 1),
      serviceId: item.serviceId);

  Future<void> decrementItem(CartItem item) {
    if (item.quantity <= 1) {
      return confirmRemoveItem(item);
    }
    return _runCartUpdate(
        () => cartRepo.updateQuantity(cartId: item.id, quantity: item.quantity - 1),
        serviceId: item.serviceId);
  }

  Future<void> removeItem(CartItem item) =>
      _runCartUpdate(() => cartRepo.removeItem(cartId: item.id), serviceId: item.serviceId);

  Future<void> confirmRemoveItem(CartItem item) async {
    await Get.bottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.cartDeleteVariation,
        description: 'are_you_sure_to_delete_this_service'.tr,
        onYesPressed: () {
          Get.back();
          removeItem(item);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Future<void> clearCart() => _runCartUpdate(
      () => cartRepo.removeAll(providerId: isProviderScoped ? _scopeProviderId : null));

  Future<void> clearProviderCart(String providerId) =>
      _runCartUpdate(() => cartRepo.removeAll(providerId: providerId));

  final Map<String, Service> _variationServiceCache = <String, Service>{};

  Service? cachedVariationService(Service? service) {
    if (service == null) {
      return null;
    }
    if (service.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
      return service;
    }
    final String? slug = service.slug;
    return slug == null || slug.isEmpty ? null : _variationServiceCache[slug];
  }

  Future<Service?> resolveVariationService(Service? service) async {
    if (service == null) {
      return null;
    }
    if (service.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
      return service;
    }

    final String? slug = service.slug;
    if (slug == null || slug.isEmpty) {
      return null;
    }

    final Service? cached = _variationServiceCache[slug];
    if (cached != null) {
      return cached;
    }

    final Response response = await cartRepo.getServiceDetails(slug: slug);
    final dynamic body = response.body;
    if (body is! Map || body['response_code'] != 'default_200' || body['content'] is! Map<String, dynamic>) {
      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
      return null;
    }

    final Service resolved = Service.fromJson(body['content']);
    if (resolved.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false) {
      _variationServiceCache[slug] = resolved;
      return resolved;
    }
    return null;
  }

  Future<void> loadProviders(String subCategoryId) async {
    _providerList = null;
    _selectedProviderIndex = -1;
    _notifyAfterFrame();

    final Response response = await cartRepo.getProvidersBySubCategory(subCategoryId: subCategoryId);

    final List<ProviderData> providers = <ProviderData>[];
    if (response.statusCode == 200 && response.body is Map && response.body['content'] is List) {
      providers.addAll(
        (response.body['content'] as List<dynamic>).whereType<Map<String, dynamic>>().map(ProviderData.fromJson),
      );
    }

    _providerList = providers;
    final String? currentProviderId = _cart.provider?.id;
    _selectedProviderIndex = currentProviderId == null
        ? -1 : providers.indexWhere((ProviderData provider) => provider.id == currentProviderId);
    update();
  }

  void setProviderIndex(int index, {bool notify = true}) {
    _selectedProviderIndex = index;
    if (notify) {
      update();
    }
  }

  Future<void> updateProvider(ProviderData? provider) async {
    if (BusinessModelHelper.isOpenMarket) {
      customSnackBar('provider_selection_is_not_available_here'.tr, type: ToasterMessageType.info);
      return;
    }

    final int previousIndex = _selectedProviderIndex;

    _status = CartStatus.updating;
    update();

    final Response response = await cartRepo.updateProvider(providerId: provider?.id);

    if (response.statusCode == 200) {
      await _loadCart();
      Get.find<ScheduleController>().buildSchedule(scheduleType: ScheduleType.asap);
    } else {
      _selectedProviderIndex = previousIndex;
      await _handleUpdateFailure(response);
    }

    _status = CartStatus.idle;
    update();
  }

  ConfigContent? get _config => Get.find<SplashController>().configModel.content;

  bool get showProviderCard => _config?.directProviderBooking == 1;

  bool get showProBanner => _config?.isProFeatureActive == 1 &&
       Get.find<UserController>().userInfoModel?.subscribedPlan == null;


  bool get hasProviderUnavailability {
    final ProviderData? provider = visibleCart.provider;
    if (provider == null) {
      return false;
    }
    return provider.isAvailable == false || provider.isActive == 0 || provider.nextBookingEligibility == false;
  }

  String? get minimumOrderMessage {
    final double minimum = _config?.minBookingAmount ?? 0;
    if (minimum == 0 || visibleCart.isEmpty || minimum <= visibleTotals.grandTotal) {
      return null;
    }
    return '${'minimum_booking_amount'.tr} ${PriceConverter.convertPrice(minimum)}';
  }

  String? get maximumOrderMessage {
    final double maximum = _config?.maxBookingAmount ?? 0;
    if (maximum == 0 || visibleCart.isEmpty || maximum >= visibleTotals.grandTotal) {
      return null;
    }
    return '${'maximum_order_amount_exceed'.tr} '
        '(${'maximum_order_amount'.tr} ${PriceConverter.convertPrice(maximum)}) ''${'admin_will_verify_this_order'.tr}';
  }

  bool get canCheckout => visibleCart.isNotEmpty && !hasProviderUnavailability && minimumOrderMessage == null;

  String? get checkoutBlockedMessage {
    if (visibleCart.isEmpty) {
      return 'cart_is_empty'.tr;
    }
    if (hasProviderUnavailability) {
      return 'your_selected_provider_is_unavailable_right_now'.tr;
    }
    return minimumOrderMessage;
  }

  List<CartItem> get items => _cart.items;

  bool get isEmpty => _cart.isEmpty;

  bool get isNotEmpty => _cart.isNotEmpty;

  int get itemCount => _cart.items.length;

  double get totalPrice => _totals.grandTotal;

  String get subCategoryId => _cart.subCategoryId;

  String? get couponCode => _cart.couponCode;

  int? get couponRemainingUses => _cart.couponRemainingUses;

  bool get hasProBenefit => _cart.proBenefitType != null;

  double get proDiscountAmount => _cart.proDiscountAmount;

  String? get proBenefitType => _cart.proBenefitType;

  double get appliedProDiscount => _totals.proDiscount;

  ProviderData? _preselectedProvider;

  ProviderData? get selectedProvider => _preselectedProvider ?? _cart.provider;

  void updatePreselectedProvider(ProviderData? provider, {bool shouldUpdate = true}) {
    _preselectedProvider = provider;
    if (shouldUpdate) {
      update();
    }
  }

  bool _walletPaymentStatus = false;
  bool get walletPaymentStatus => _walletPaymentStatus;

  void updateWalletPaymentStatus(bool status, {bool shouldUpdate = true}) {
    _walletPaymentStatus = status;
    if (shouldUpdate) {
      update();
    }
  }

  List<CartItem> itemsForService(String serviceId) => serviceId.isEmpty
      ? const <CartItem>[]
      : _cart.items.where((CartItem item) => item.serviceId == serviceId).toList();

  int quantityOfService(String serviceId) =>
      itemsForService(serviceId).fold<int>(0, (int sum, CartItem item) => sum + item.quantity);

  int quantityOfVariation(String serviceId, String? variantKey) {
    for (final CartItem item in itemsForService(serviceId)) {
      if (item.variantKey == variantKey) {
        return item.quantity;
      }
    }
    return 0;
  }

  String? checkScheduleBookingAvailability() {
    if (_config?.scheduleBooking == 0) {
      return 'schedule_booking_currently_unavailable'.tr;
    }
    if (visibleCart.provider?.scheduleBookingEligibility == false) {
      return 'schedule_booking_currently_unavailable_for_this_provider'.tr;
    }
    return null;
  }

  Future<void> updateItemQuantity(String cartId, int quantity, {String serviceId = ''}) =>
      _runCartUpdate(() => cartRepo.updateQuantity(cartId: cartId, quantity: quantity), serviceId: serviceId);

  Future<void> removeAllItems() => _runCartUpdate(() => cartRepo.removeAll());

  void clearLocalCartData() {
    _cart = const CartContents.empty();
    _totals = const CartTotals.empty();
    _providerScopedCart = const CartContents.empty();
    _providerScopedTotals = const CartTotals.empty();
    _scopeProviderId = '';
    _cartRevision++;
    _variationSelections.clear();
    _updatingServiceId = '';
    _expandedServiceIds.clear();
    _isBillingExpanded = false;
    _providerList = null;
    _selectedProviderIndex = -1;
    _suggestedServices = null;
    _preselectedProvider = null;
    _walletPaymentStatus = false;
    update();
  }

  final Map<String, List<CartVariationSelection>> _variationSelections = <String, List<CartVariationSelection>>{};

  List<CartVariationSelection> _selectionsOf(String serviceId) =>
      _variationSelections[serviceId] ?? const <CartVariationSelection>[];

  List<CartVariationSelection> variationSelectionsForService(String serviceId) =>
      List<CartVariationSelection>.unmodifiable(_selectionsOf(serviceId));

  double selectionTotalForService(String serviceId) => _selectionsOf(serviceId)
      .fold<double>(0, (double sum, CartVariationSelection selection) => sum + selection.subTotal);

  bool hasSelectedQuantityForService(String serviceId) =>
      _selectionsOf(serviceId).any((CartVariationSelection selection) => selection.quantity > 0);

  void prepareVariationSelections(Service service, {bool notify = false}) {
    final String serviceId = service.id ?? '';
    final List<CartVariationSelection> selections = <CartVariationSelection>[];

    for (final Variations variation in service.variations ?? <Variations>[]) {
      final CartItem? existing = itemsForService(serviceId)
          .where((CartItem item) => item.variantKey == variation.variantKey)
          .firstOrNull;

      selections.add(CartVariationSelection(
        serviceId: serviceId,
        categoryId: service.categoryId ?? '',
        subCategoryId: service.subCategoryId ?? '',
        variantKey: variation.variantKey ?? '',
        price: (variation.price ?? 0).toDouble(),
        taxAmount: (service.tax ?? 0).toDouble(),
        service: service,
        cartId: existing?.id,
        quantity: existing?.quantity ?? 0,
        discountedPrice: variation.discountedPrice,
        variantName: variation.variant
      ));
    }

    _variationSelections[serviceId] = selections;
    if (notify) {
      update();
    }
  }

  void changeSelectionQuantity(String serviceId, int index, bool isIncrement, {bool notify = true}) {
    final List<CartVariationSelection> selections = _selectionsOf(serviceId);
    if (index < 0 || index >= selections.length) {
      return;
    }
    final CartVariationSelection selection = selections[index];
    if (isIncrement) {
      selection.quantity += 1;
    } else if (selection.quantity > 0) {
      selection.quantity -= 1;
    }
    if (notify) {
      update();
    }
  }

  void setSelectionQuantity(String serviceId, int index, int quantity, {bool notify = true}) {
    final List<CartVariationSelection> selections = _selectionsOf(serviceId);
    if (index < 0 || index >= selections.length) {
      return;
    }
    selections[index].quantity = quantity < 0 ? 0 : quantity;
    if (notify) {
      update();
    }
  }

  Future<void> addSelectionsToCart({
    required String serviceId,
    bool fromServiceCenterDialog = true,
    String providerId = '',
  }) async {
    if (_status == CartStatus.updating) {
      return;
    }

    final List<CartVariationSelection> selected = _selectionsOf(serviceId)
        .where((CartVariationSelection selection) => selection.quantity > 0 || selection.cartId != null)
        .toList();
    if (selected.isEmpty) {
      return;
    }

    final bool isOpenMarket = BusinessModelHelper.isOpenMarket;
    final String targetProviderId = isOpenMarket ? _resolveTargetProviderId(selected.first) : '';

    final String currentSubCategory = _cart.subCategoryId;
    final bool switchesSubCategory =
        currentSubCategory.isNotEmpty && currentSubCategory != selected.first.subCategoryId;

    if (switchesSubCategory) {
      if (fromServiceCenterDialog) {
        Get.back();
      }
      Get.bottomSheet(
        ConfirmationBottomsheet(
          icon: Images.warning,
          title: 'are_you_sure_to_reset'.tr,
          description: 'you_have_service_from_other_sub_category'.tr,
          onNoPressed: () => Get.back(),
          onYesPressed: () async {
            Get.back();
            Get.dialog(const CustomLoader(), barrierDismissible: false);
            await cartRepo.removeAll(providerId: targetProviderId.isEmpty ? null : targetProviderId);
            final bool pushed = await _sendSelectionsToCart(selected, providerId);
            await refreshCart();
            Get.back();
            if (pushed) {
              customSnackBar('successfully_added_to_cart'.tr, type: ToasterMessageType.success);
            }
          },
        ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
      );
      return;
    }

    _updatingServiceId = serviceId;
    _status = CartStatus.updating;
    update();

    final bool pushed = await _sendSelectionsToCart(selected, providerId);
    await _loadCart();

    _updatingServiceId = '';
    _status = CartStatus.idle;
    update();

    if (fromServiceCenterDialog) {
      Get.back();
      if (pushed) {
        customSnackBar('successfully_added_to_cart'.tr, type: ToasterMessageType.success);
      }
    }
  }

  String _resolveTargetProviderId(CartVariationSelection selection) {
    final String fromService = selection.service.providerId ?? '';
    if (fromService.isNotEmpty) {
      return fromService;
    }

    for (final CartItem item in _cart.items) {
      final String itemProviderId = item.provider?.id ?? '';
      if (item.serviceId == selection.serviceId && itemProviderId.isNotEmpty) {
        return itemProviderId;
      }
    }
    return '';
  }

  Future<bool> _sendSelectionsToCart(List<CartVariationSelection> selections, String providerId) async {
    for (final CartVariationSelection selection in selections) {
      final Response response;
      if (selection.cartId != null) {
        response = selection.quantity > 0
            ? await cartRepo.updateQuantity(cartId: selection.cartId!, quantity: selection.quantity)
            : await cartRepo.removeItem(cartId: selection.cartId!);
      } else if (selection.quantity > 0) {
        response = await cartRepo.addToCart(
          serviceId: selection.serviceId,
          categoryId: selection.categoryId,
          subCategoryId: selection.subCategoryId,
          variantKey: selection.variantKey,
          quantity: selection.quantity,
          providerId: providerId,
        );
      } else {
        continue;
      }

      if (response.statusCode == 200) {
        continue;
      }

      if (response.statusCode == 422 && _responseCode(response) == 'cart_sub_category_conflict_422') {
        customSnackBar('you_have_service_from_other_sub_category'.tr, type: ToasterMessageType.info);
        return false;
      }
      if (response.statusCode == 404) {
        customSnackBar('service_not_available_in_current_location'.tr, type: ToasterMessageType.info);
        return false;
      }
      ApiChecker.checkApi(response);
      return false;
    }
    return true;
  }
}
