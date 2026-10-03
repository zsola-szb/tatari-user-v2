import 'dart:convert';
import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController implements GetxService {
  final CheckoutRepo checkoutRepo;

  CheckoutController({required this.checkoutRepo});


  CheckoutFlow _flow = CheckoutFlow.cart;
  CheckoutFlow get flow => _flow;

  bool get isBidFlow => _flow == CheckoutFlow.bid;

  String _postId = '';
  String get postId => _postId;

  String _providerId = '';
  String get providerId => _providerId;

  String _bidId = '';
  String get bidId => _bidId;

  double _bidAmount = 0;
  double get bidAmount => _bidAmount;

  BidPostDetailsContent? _postDetails;
  BidPostDetailsContent? get postDetails => _postDetails;

  double _bidReferralDiscount = 0;


  ServiceLocationType _locationType = ServiceLocationType.customer;
  ServiceLocationType get locationType => _locationType;

  AddressModel? _serviceAddress;
  AddressModel? get serviceAddress => _serviceAddress;

  ProviderData? get bookingProvider {
    if (isBidFlow) {
      return null;
    }
    final List<CartItem> cart = Get.find<CartController>().items;
    return cart.isEmpty ? null : cart.first.provider;
  }

  bool get allowChooseServiceLocation {
    if (isBidFlow) {
      return false;
    }
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    if (config?.serviceAtProviderLocation != 1) {
      return false;
    }
    final ProviderData? provider = bookingProvider;
    if (provider == null) {
      return true;
    }
    return (provider.serviceLocations?.length ?? 0) > 1;
  }


  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool _isCreateAccount = false;
  bool get isCreateAccount => _isCreateAccount;

  bool get isLoggedIn => Get.find<AuthController>().isLoggedIn();

  bool get canCreateGuestAccount =>
      !isLoggedIn && Get.find<SplashController>().configModel.content?.createGuestUserAccount == 1;

  void toggleCreateAccount({bool? value, bool notify = true}) {
    _isCreateAccount = value ?? !_isCreateAccount;
    if (!_isCreateAccount) {
      passwordController.clear();
      confirmPasswordController.clear();
    }
    if (notify) {
      update();
    }
  }




  CheckoutPaymentMethod _paymentMethod = CheckoutPaymentMethod.none;
  CheckoutPaymentMethod get paymentMethod => _paymentMethod;

  DigitalPaymentMethod? _selectedDigitalMethod;
  DigitalPaymentMethod? get selectedDigitalMethod => _selectedDigitalMethod;

  CheckoutOfflineMethodModel? _selectedOfflineMethod;
  CheckoutOfflineMethodModel? get selectedOfflineMethod => _selectedOfflineMethod;

  List<DigitalPaymentMethod> _digitalMethodList = <DigitalPaymentMethod>[];
  List<DigitalPaymentMethod> get digitalMethodList => List<DigitalPaymentMethod>.unmodifiable(_digitalMethodList);

  List<CheckoutPaymentOption> _otherMethodList = <CheckoutPaymentOption>[];
  List<CheckoutPaymentOption> get otherMethodList => List<CheckoutPaymentOption>.unmodifiable(_otherMethodList);

  List<CheckoutOfflineMethodModel> _offlineMethodList = <CheckoutOfflineMethodModel>[];
  List<CheckoutOfflineMethodModel> get offlineMethodList => List<CheckoutOfflineMethodModel>.unmodifiable(_offlineMethodList);

  bool get hasAnyPaymentMethod => _otherMethodList.isNotEmpty || _digitalMethodList.isNotEmpty;

  bool _isWalletApplied = false;
  bool get isWalletApplied => _isWalletApplied;

  void toggleWallet({bool? value, bool notify = true}) {
    _isWalletApplied = value ?? !_isWalletApplied;
    if (_isWalletApplied) {
      _paymentMethod = CheckoutPaymentMethod.wallet;
      _selectedDigitalMethod = null;
      _selectedOfflineMethod = null;
    } else if (_paymentMethod == CheckoutPaymentMethod.wallet) {
      _paymentMethod = CheckoutPaymentMethod.none;
    }
    buildPaymentMethodList();
    recalculateTotals(notify: false);
    if (notify) {
      update();
    }
  }

  void selectPaymentMethod({
    CheckoutPaymentMethod? method,
    DigitalPaymentMethod? digitalMethod,
    CheckoutOfflineMethodModel? offlineMethod,
    bool notify = true,
  }) {
    if (offlineMethod != null) {
      _selectedOfflineMethod = offlineMethod;
      _selectedDigitalMethod = null;
      _paymentMethod = CheckoutPaymentMethod.offline;
    } else if (digitalMethod != null) {
      _selectedDigitalMethod = digitalMethod;
      _selectedOfflineMethod = null;
      _paymentMethod = CheckoutPaymentMethod.digital;
    } else if (method != null) {
      _paymentMethod = method;
      if (method != CheckoutPaymentMethod.digital) {
        _selectedDigitalMethod = null;
      }
      if (method != CheckoutPaymentMethod.offline) {
        _selectedOfflineMethod = null;
      }
      if (method == CheckoutPaymentMethod.wallet) {
        _isWalletApplied = true;
      }
    }

    recalculateTotals(notify: false);
    if (notify) {
      update();
    }
  }

  void selectOfflinePayment({bool notify = true}) {
    final CheckoutOfflineMethodModel? method = _selectedOfflineMethod ??
        (_offlineMethodList.isEmpty ? null : _offlineMethodList.first);

    if (method == null) {
      selectPaymentMethod(method: CheckoutPaymentMethod.offline, notify: notify);
      return;
    }
    selectPaymentMethod(offlineMethod: method, notify: notify);
  }

  void buildPaymentMethodList({bool notify = false}) {
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    _digitalMethodList = <DigitalPaymentMethod>[];
    _otherMethodList = <CheckoutPaymentOption>[];

    if (config == null) {
      if (notify) {
        update();
      }
      return;
    }

    final bool walletAvailable = config.walletStatus == 1 && isLoggedIn && CheckoutHelper.currentWalletBalance > 0;

    final CheckoutPaymentOption walletOption = CheckoutPaymentOption(
      titleKey: 'pay_via_wallet',
      assetName: Images.walletMenu,
      method: CheckoutPaymentMethod.wallet,
    );
    final CheckoutPaymentOption cashOption = CheckoutPaymentOption(
      titleKey: 'pay_after_service',
      assetName: Images.cod,
      method: CheckoutPaymentMethod.cashAfterService,
    );

    final bool partialActive = _isWalletApplied && isPartialPayment && config.partialPayment == 1;

    if (partialActive && config.partialPaymentCombinator != 'all') {
      switch (config.partialPaymentCombinator) {
        case 'digital_payment':
          if (walletAvailable) {
            _otherMethodList = <CheckoutPaymentOption>[walletOption];
          }
          if (config.digitalPayment == 1) {
            _digitalMethodList.addAll(config.paymentMethodList ?? <DigitalPaymentMethod>[]);
          }
          break;
        case 'cash_after_service':
          _otherMethodList = <CheckoutPaymentOption>[
            if (walletAvailable) walletOption,
            if (config.cashAfterService == 1) cashOption,
          ];
          break;
        case 'offline_payment':
          if (walletAvailable) {
            _otherMethodList = <CheckoutPaymentOption>[walletOption];
          }
          if (config.offlinePayment == 1) {
            _digitalMethodList.add(DigitalPaymentMethod(gateway: 'offline', gatewayImage: ''));
          }
          break;
      }
    } else {
      _otherMethodList = <CheckoutPaymentOption>[
        if (walletAvailable) walletOption,
        if (config.cashAfterService == 1) cashOption,
      ];
      if (config.digitalPayment == 1) {
        _digitalMethodList.addAll(config.paymentMethodList ?? <DigitalPaymentMethod>[]);
      }
      if (config.offlinePayment == 1) {
        _digitalMethodList.add(DigitalPaymentMethod(gateway: 'offline', gatewayImage: ''));
      }
    }

    if (notify) {
      update();
    }
  }

  bool get _isCashAfterServiceAvailable =>
      _otherMethodList.any((CheckoutPaymentOption option) => option.method == CheckoutPaymentMethod.cashAfterService);

  void autoSelectPaymentMethod({bool notify = false}) {
    if (_paymentMethod != CheckoutPaymentMethod.none) {
      return;
    }

    if (!isBidFlow && !isRepeatBooking && _isCashAfterServiceAvailable) {
      _paymentMethod = CheckoutPaymentMethod.cashAfterService;
    } else if (_otherMethodList.length == 1 && _digitalMethodList.isEmpty) {
      _paymentMethod = _otherMethodList.first.method;
    } else if (_otherMethodList.isEmpty && _digitalMethodList.length == 1) {
      final DigitalPaymentMethod only = _digitalMethodList.first;
      if (only.gateway == 'offline') {
        _paymentMethod = CheckoutPaymentMethod.offline;
        _selectedOfflineMethod =
            _offlineMethodList.isEmpty ? null : _offlineMethodList.first;
      } else {
        _paymentMethod = CheckoutPaymentMethod.digital;
        _selectedDigitalMethod = only;
      }
    }

    if (notify) {
      update();
    }
  }

  bool _isOfflineLoading = false;
  bool get isOfflineLoading => _isOfflineLoading;

  Future<void> loadOfflineMethodList({bool reload = true, bool notify = true}) async {
    if (_offlineMethodList.isNotEmpty && !reload) {
      return;
    }
    _isOfflineLoading = true;

    final Response response = await checkoutRepo.getOfflinePaymentMethodList();
    final dynamic body = response.body;
    if (response.statusCode == 200 && body is Map) {
      final dynamic data = body['content']?['data'];
      if (data is List) {
        _offlineMethodList = data.whereType<Map<String, dynamic>>().map(CheckoutOfflineMethodModel.fromJson).toList();
      }
    }

    _isOfflineLoading = false;
    if (notify) {
      update();
    }
  }


  CheckoutTotals _totals = const CheckoutTotals.empty();
  CheckoutTotals get totals => _totals;

  bool _showSingleBookingView = false;
  bool get showSingleBookingView => _showSingleBookingView;

  CheckoutTotals get displayTotals => _showSingleBookingView && _totals.occurrenceCount > 1 ? _totals.dividedBy(_totals.occurrenceCount) : _totals;

  void toggleBookingView() {
    _showSingleBookingView = !_showSingleBookingView;
    update();
  }

  void recalculateTotals({bool notify = true}) {
    _totals = isBidFlow ? _buildBidTotals() : _buildCartTotals();
    if (notify) {
      update();
    }
  }

  CheckoutTotals _buildCartTotals() {
    final CartController cart = Get.find<CartController>();
    final CheckoutScheduleController schedule = Get.find<CheckoutScheduleController>();

    final List<CartItem> cartList = cart.items;
    if (cartList.isEmpty) {
      return const CheckoutTotals.empty();
    }

    final int daysCount = schedule.occurrenceCount < 1 ? 1 : schedule.occurrenceCount;
    final int couponDays = CheckoutHelper.getNumberOfDaysForApplicableCoupon(pickedScheduleDays: daysCount) ?? 1;

    final double subTotal =
        CheckoutHelper.calculateSubTotal(cartList: cartList, daysCount: daysCount);
    final double discount = CheckoutHelper.calculateDiscount(
      cartList: cartList,
      discountType: DiscountType.general,
      daysCount: daysCount,
    );
    final double campaignDiscount = CheckoutHelper.calculateDiscount(
      cartList: cartList,
      discountType: DiscountType.campaign,
      daysCount: daysCount,
    );
    final double couponDiscount = CheckoutHelper.calculateDiscount(
      cartList: cartList,
      discountType: DiscountType.coupon,
      daysCount: couponDays,
    );
    // v2's cart list no longer returns `referral_amount`.
    const double referralDiscount = 0;
    final double vat = CheckoutHelper.calculateVat(cartList: cartList, daysCount: daysCount);
    final double additionalCharge = CheckoutHelper.getAdditionalCharge();

    double grandTotal = CheckoutHelper.calculateGrandTotal(
      cartList: cartList,
      referralDiscount: referralDiscount,
      daysCount: daysCount,
      applicableCouponCount: couponDays,
    );


    double proDiscount = 0;
    final double proUnit = cart.proDiscountAmount;
    final String? proBenefitType = cart.proBenefitType;
    if (proUnit > 0) {
      if (proBenefitType == 'discount') {
        proDiscount = proUnit * daysCount;
        grandTotal -= proDiscount;
      } else if (proBenefitType == 'coupon') {
        proDiscount = proUnit * couponDays;
      } else {
        proDiscount = proUnit;
        grandTotal -= proDiscount;
      }
    }

    if (grandTotal < 0) {
      grandTotal = 0;
    }

    final double walletPaid = _isWalletApplied
        ? CheckoutHelper.calculatePaidAmount(
            walletBalance: CheckoutHelper.currentWalletBalance, bookingAmount: grandTotal) : 0;

    return CheckoutTotals(
      subTotal: subTotal,
      discount: discount,
      campaignDiscount: campaignDiscount,
      couponDiscount: couponDiscount,
      referralDiscount: referralDiscount,
      proDiscount: proDiscount,
      proBenefitType: proBenefitType,
      vat: vat,
      additionalCharge: additionalCharge,
      grandTotal: grandTotal,
      walletPaid: walletPaid,
      occurrenceCount: daysCount,
    );
  }

  CheckoutTotals _buildBidTotals() {
    final double vat = _postDetails?.taxAmount ?? 0;
    final double additionalCharge = CheckoutHelper.getAdditionalCharge();

    double grandTotal = _bidAmount + vat + additionalCharge - _bidReferralDiscount;
    if (grandTotal < 0) {
      grandTotal = 0;
    }

    final double walletPaid = _isWalletApplied
        ? CheckoutHelper.calculatePaidAmount(walletBalance: CheckoutHelper.currentWalletBalance, bookingAmount: grandTotal) : 0;

    return CheckoutTotals(
      subTotal: _bidAmount,
      referralDiscount: _bidReferralDiscount,
      vat: vat,
      additionalCharge: additionalCharge,
      grandTotal: grandTotal,
      walletPaid: walletPaid,
    );
  }

  AddressModel? get resolvedAddress {
    final LocationController location = Get.find<LocationController>();
    return CheckoutHelper.selectedAddressModel(
      selectedAddress: _serviceAddress ?? location.selectedAddress,
      pickedAddress: location.getUserAddress(),
      selectedLocationType: _locationType,
    );
  }

  bool get hasValidServiceLocation {
    final AddressModel? address = resolvedAddress;
    if (address == null) {
      return false;
    }
    final String? latitude = address.latitude;
    final String? longitude = address.longitude;
    return double.tryParse(latitude ?? '') != null && double.tryParse(longitude ?? '') != null;
  }

  bool get hasValidProviderLocation {
    final Coordinates? coordinates = bookingProvider?.coordinates;
    return coordinates != null;
  }

  String get contactName => ContactInfoHelper.resolveName(
        fallbackName: isBidFlow ? _postDetails?.contactPersonName : null,
      );

  String get contactPhone => ContactInfoHelper.resolvePhone(
        fallbackPhone: isBidFlow ? _postDetails?.contactPersonNumber : null,
      );

  bool get hasContactInfo => contactName.isNotEmpty && contactPhone.isNotEmpty;

  bool get isRepeatBooking => !Get.find<CheckoutScheduleController>().isSingleBooking;

  bool get isPartialPayment => CheckoutHelper.checkPartialPayment(
        walletBalance: CheckoutHelper.currentWalletBalance,
        bookingAmount: _totals.grandTotal,
      );

  bool get hasIncompletePartialSelection => _isWalletApplied &&
      isPartialPayment && (_paymentMethod == CheckoutPaymentMethod.none || _paymentMethod == CheckoutPaymentMethod.wallet);

  String? get scheduleAvailabilityError {
    if (Get.find<CheckoutScheduleController>().isInstantBooking) {
      return null;
    }
    return Get.find<CartController>().checkScheduleBookingAvailability();
  }

  bool get hasProviderUnavailability => !isBidFlow && Get.find<CartController>().hasProviderUnavailability;

  bool get isInstantBookingAllowed => Get.find<SplashController>().configModel.content?.instantBooking == 1;

  bool get isScheduleBookingAllowed => Get.find<CartController>().checkScheduleBookingAvailability() == null;

  bool get isRepeatBookingAllowed => !isBidFlow && isLoggedIn && Get.find<SplashController>().configModel.content?.repeatBooking == 1;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPageLoading = true;
  bool get isPageLoading => _isPageLoading;

  String _bookingReadableId = '';
  String get bookingReadableId => _bookingReadableId;

  void _notifyAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) => update());
  }

  void setBookingReadableId(String value, {bool notify = true}) {
    _bookingReadableId = value;
    if (notify) {
      update();
    }
  }

  String? _proDiscountAmount;
  String? get proDiscountAmount => _proDiscountAmount;

  VoidCallback? _cartListenerDisposer;

  @override
  void onInit() {
    super.onInit();
    _cartListenerDisposer = Get.find<CartController>().addListener(_onCartChanged);
  }

  void _onCartChanged() {
    if (_isPageLoading) {
      return;
    }
    recalculateTotals(notify: false);
    _notifyAfterFrame();
  }

  Future<void> initData({
    required CheckoutFlow flow,
    String postId = '',
    String providerId = '',
    String bidId = '',
    double bidAmount = 0,
    DateTime? initialScheduleAt,
    AddressModel? initialAddress,
  }) async {
    _flow = flow;
    _postId = postId;
    _providerId = providerId;
    _bidId = bidId;
    _bidAmount = bidAmount;
    _postDetails = null;
    _bidReferralDiscount = 0;

    _locationType = ServiceLocationType.customer;
    _serviceAddress = initialAddress;

    _isCreateAccount = false;
    passwordController.clear();
    confirmPasswordController.clear();

    _paymentMethod = CheckoutPaymentMethod.none;
    _selectedDigitalMethod = null;
    _selectedOfflineMethod = null;
    _isWalletApplied = false;
    _digitalMethodList = <DigitalPaymentMethod>[];
    _otherMethodList = <CheckoutPaymentOption>[];
    _offlineMethodList = <CheckoutOfflineMethodModel>[];

    _totals = const CheckoutTotals.empty();
    _showSingleBookingView = false;
    _bookingReadableId = '';
    _proDiscountAmount = null;
    _isLoading = false;
    _isPageLoading = true;

     disposeOfflineInputControllers();
     Get.find<LocationController>().resetGuestContactInfo();
     Get.find<CheckoutScheduleController>().initData(initialScheduleAt: initialScheduleAt, notify: false);

    Get.find<CartController>().updateWalletPaymentStatus(false, shouldUpdate: false);

    _notifyAfterFrame();

    await Future.wait<void>(<Future<void>>[
      if (flow == CheckoutFlow.cart)
        Get.find<CartController>().refreshCart(),
      if (flow == CheckoutFlow.bid) _loadPostDetails(),
      loadOfflineMethodList(notify: false),
      if (isLoggedIn) Get.find<CouponController>().getCouponList(),
      if (isLoggedIn) Get.find<UserController>().getUserInfo(reload: false),
    ]);

    if (isLoggedIn &&
        Get.find<SplashController>().configModel.content?.isProFeatureActive == 1) {
      final SubscriptionController subscription = Get.find<SubscriptionController>();
      subscription.getSubscriptionList();
      subscription.getSubscriptionTerms();
    }

    _seedServiceAddress();
    buildPaymentMethodList();
    autoSelectPaymentMethod();
    recalculateTotals(notify: false);

    _isPageLoading = false;
    update();
  }

  void _seedServiceAddress() {
    if (_serviceAddress != null) {
      return;
    }
    final LocationController location = Get.find<LocationController>();
    _serviceAddress = CheckoutHelper.selectedAddressModel(
      selectedAddress: location.selectedAddress,
      pickedAddress: location.getUserAddress(),
      selectedLocationType: _locationType,
    );
  }

  Future<void> _loadPostDetails() async {
    final Response response = await checkoutRepo.getPostDetails(
      postId: _postId,
      bidId: _bidId,
    );
    final dynamic body = response.body;
    if (body is! Map || body['response_code'] != 'default_200') {
      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
      return;
    }

    final dynamic data = body['data'];
    if (data is! Map<String, dynamic>) {
      return;
    }

    _postDetails = BidPostDetailsContent.fromJson(data);
    _bidReferralDiscount = _postDetails?.referralAmount ?? 0;

    final double? confirmedBidAmount = _postDetails?.bidAmount;
    if (confirmedBidAmount != null) {
      _bidAmount = confirmedBidAmount;
    }

    final String? bookingSchedule = _postDetails?.bookingSchedule;
    if (bookingSchedule != null && bookingSchedule.isNotEmpty) {
      Get.find<CheckoutScheduleController>().setSingleSchedule(
        DateConverter.dateTimeStringToDate(bookingSchedule),
        notify: false,
      );
    }
  }

  void setLocationType(ServiceLocationType type, {bool notify = true}) {
    _locationType = type;
    if (notify) {
      update();
    }
  }

  void setServiceAddress(AddressModel? address, {bool notify = true}) {
    _serviceAddress = address;
    if (notify) {
      update();
    }
  }

  void syncAddressFromLocationController({bool notify = true}) {
    final LocationController location = Get.find<LocationController>();
    _serviceAddress = CheckoutHelper.selectedAddressModel(
      selectedAddress: location.selectedAddress,
      pickedAddress: location.getUserAddress(),
      selectedLocationType: _locationType,
    );
    recalculateTotals(notify: false);
    if (notify) {
      update();
    }
  }

  Future<void> submitBooking({VoidCallback? onPaymentMethodMissing}) async {
    if (_isLoading) {
      return;
    }
    final String? error = await validateBeforeSubmit();
    if (error != null) {
      if (onPaymentMethodMissing != null && error == paymentSelectionError) {
        onPaymentMethodMissing();
      } else {
        customSnackBar(error, type: ToasterMessageType.info);
      }
      return;
    }

    final AddressModel? resolvedServiceAddress = resolvedAddress;
    if (_locationType == ServiceLocationType.customer && resolvedServiceAddress == null) {
      customSnackBar('add_address_first'.tr, type: ToasterMessageType.info);
      return;
    }
    final AddressModel address = resolvedServiceAddress ?? AddressModel();

    if (_paymentMethod == CheckoutPaymentMethod.digital && !isRepeatBooking) {
      startDigitalPayment(address);
      return;
    }

    _isLoading = true;
    update();

    saveProDiscountAmount();
    final BookingPlaceResult result = isBidFlow ? await _placeBidBooking(address) : await _placeCartBooking(address);

    _isLoading = false;
    update();

    if (result.isSuccess) {
      await _settleAfterPlacement(result, address);
    } else {
      customSnackBar(result.message);
    }
  }

  Future<String?> validateBeforeSubmit() async {
    if (!isBidFlow && Get.find<CartController>().isEmpty) {
      return 'your_cart_is_empty'.tr;
    }
    if (hasProviderUnavailability) {
      return 'your_selected_provider_is_unavailable_right_now'.tr;
    }

    final String? scheduleError = scheduleAvailabilityError;
    if (scheduleError != null) {
      return scheduleError;
    }

    if (_locationType == ServiceLocationType.customer && !hasValidServiceLocation) {
      return 'add_address_first'.tr;
    }

    if (!hasContactInfo) {
      return isLoggedIn
          ? 'please_enter_phone_number'.tr
          : 'please_input_contact_person_name_and_phone_number'.tr;
    }

    if (_isCreateAccount) {
      if (passwordController.text.isEmpty) {
        return 'please_input_new_account_password'.tr;
      }
      if (confirmPasswordController.text.isEmpty) {
        return 'please_input_confirm_password'.tr;
      }
      if (passwordController.text != confirmPasswordController.text) {
        return 'confirm_password_does_not_matched'.tr;
      }
      if (canCreateGuestAccount) {
        switch (await checkExistingUser(phone: contactPhone)) {
          case ExistingUserStatus.taken:
            return 'phone_already_taken'.tr;
          case ExistingUserStatus.unknown:
            return 'something_went_wrong'.tr;
          case ExistingUserStatus.available:
            break;
        }
      }
    }

    final CheckoutScheduleController schedule = Get.find<CheckoutScheduleController>();
    if (isRepeatBooking) {
      final String? scheduleSelectionError = schedule.validateSelection();
      if (scheduleSelectionError != null) {
        return scheduleSelectionError.tr;
      }
    } else {
      if (!isInstantBookingAllowed && schedule.singleScheduleAt == null) {
        return 'select_your_preferable_booking_time'.tr;
      }
      final ConfigContent? config = Get.find<SplashController>().configModel.content;
      if (config?.scheduleBookingTimeRestriction == 1) {
        final String? restriction = schedule.checkLeadTimeRestriction(config?.advanceBooking);
        if (restriction != null) {
          return restriction;
        }
      }
    }

    final String? paymentError = paymentSelectionError;
    if (paymentError != null) {
      return paymentError;
    }

    return null;
  }

  String? get paymentSelectionError {
    if (isRepeatBooking) {
      return null;
    }
    if (_paymentMethod == CheckoutPaymentMethod.none) {
      return 'select_payment_method'.tr;
    }
    if (hasIncompletePartialSelection) {
      return 'select_another_payment_method_to_pay_remaining_bill'.tr;
    }
    if (_paymentMethod == CheckoutPaymentMethod.offline && _selectedOfflineMethod == null) {
      return 'provide_offline_payment_info'.tr;
    }
    if (_paymentMethod == CheckoutPaymentMethod.digital &&
        (_selectedDigitalMethod == null || _selectedDigitalMethod?.gateway == 'offline')) {
      return 'select_any_payment_method'.tr;
    }
    return null;
  }

  String _resolvePaymentMethodKey() =>
      isRepeatBooking ? 'cash_after_service' : _paymentMethod.apiKey;

  int get _isPartialFlag => (_isWalletApplied && isPartialPayment) ? 1 : 0;

  String _addressIdOf(AddressModel address) {
    final String? id = address.id;
    return (id == null || id == 'null') ? '' : id;
  }

  String get _zoneId => Get.find<LocationController>().getUserAddress()?.zoneId ?? '';

  SignUpBody? _newUserInfoFor(AddressModel address) => CheckoutHelper.getNewUserInfo(
        address: address,
        password: passwordController.text,
        isCheckedCreateAccount: _isCreateAccount);

  Future<BookingPlaceResult> _placeCartBooking(AddressModel address) async {
    final CheckoutScheduleController schedule = Get.find<CheckoutScheduleController>();
    final CartController cart = Get.find<CartController>();

    final Response response = await checkoutRepo.placeBookingRequest(
      paymentMethod: _resolvePaymentMethodKey(),
      zoneId: _zoneId,
      serviceAddress: address,
      serviceAddressId: _addressIdOf(address),
      schedule: schedule.scheduleTimeString,
      isPartial: _isPartialFlag,
      serviceLocation: _locationType.name,
      serviceType: schedule.serviceType.name,
      bookingType: schedule.repeatType.name,
      dates: isRepeatBooking ? schedule.buildRepeatDatesPayload() : null,
      newUserInfo: _newUserInfoFor(address),
      contactPersonName: contactName,
      contactPersonNumber: contactPhone,
      cartProviderId: cart.isProviderScoped ? cart.scopeProviderId : null,
    );

    return BookingPlaceResult.fromResponse(
      response,
      successCodes: <String>['booking_place_success_200'],
    );
  }

  Future<BookingPlaceResult> _placeBidBooking(AddressModel address) async {
    final CheckoutScheduleController schedule = Get.find<CheckoutScheduleController>();
    if (_paymentMethod == CheckoutPaymentMethod.cashAfterService) {
      final Response response = await checkoutRepo.acceptBid(
        postId: _postId,
        providerId: _providerId,
        isPartial: _isPartialFlag,
        serviceAddress: address,
        serviceAddressId: _addressIdOf(address),
        contactPersonName: contactName,
        contactPersonNumber: contactPhone,
      );
      return BookingPlaceResult.fromResponse(
        response,
        successCodes: <String>['default_update_200'],
      );
    }

    final Response response = await checkoutRepo.placeBidBookingRequest(
      paymentMethod: _resolvePaymentMethodKey(),
      zoneId: _zoneId,
      serviceAddress: address,
      serviceAddressId: _addressIdOf(address),
      schedule: schedule.scheduleTimeString,
      isPartial: _isPartialFlag,
      postId: _postId,
      providerId: _providerId,
      offlinePaymentId: _selectedOfflineMethod?.id,
      contactPersonName: contactName,
      contactPersonNumber: contactPhone,
    );
    return BookingPlaceResult.fromResponse(
      response,
      successCodes: <String>['booking_place_success_200'],
    );
  }

  Future<void> _settleAfterPlacement(
    BookingPlaceResult result,
    AddressModel address,
  ) async {
    _bookingReadableId = result.readableId ?? '';
    loadProDiscountAmount();

    if (!isBidFlow) {
      Get.find<CartController>().initData();
    }

    // A wallet payment has just changed the balance and the cart no longer
    // carries it, so refetch the profile that now owns it.
    if (isLoggedIn) {
      Get.find<UserController>().getUserInfo(reload: false);
    }

    if (_paymentMethod == CheckoutPaymentMethod.offline && !isRepeatBooking) {
      customSnackBar(
        'now_pay_you_bill_using_the_payment_method'.tr,
        toasterTitle: 'your_booking_has_been_placed_successfully'.tr,
        type: ToasterMessageType.success,
        duration: 4,
      );
      Get.offAllNamed(
        RouteHelper.getOfflinePaymentRoute(
          bookingId: result.bookingId ?? '',
          readableId: result.readableId,
          amount: _totals.dueAmount,
          isPartialPayment: _isPartialFlag,
          createdAccount: _isCreateAccount,
          newUserInfo: _newUserInfoFor(address),
        ),
      );
      return;
    }

    final String? token = result.token;
    if (token != null && token.isNotEmpty) {
      handleGuestAccountToken(token: token, userInfo: _newUserInfoFor(address));
    }

    Get.offNamed(
      RouteHelper.getBookingSuccessRoute(
        readableId: _bookingReadableId,
        createdAccount: _isCreateAccount,
      ),
    );
  }

  void startDigitalPayment(AddressModel address) {
    final CheckoutScheduleController schedule = Get.find<CheckoutScheduleController>();
    final String userId = Get.find<UserController>().userInfoModel?.id ??
        Get.find<SplashController>().getGuestId();
    final String encodedAddress = base64Encode(utf8.encode(jsonEncode(address.toJson())));
    final SignUpBody? newUserInfo = _newUserInfoFor(address);

    final StringBuffer url = StringBuffer('${AppConstants.baseUrl}/payment')
      ..write('?payment_method=${_selectedDigitalMethod?.gateway}')
      ..write('&access_token=${base64Url.encode(utf8.encode(userId))}')
      ..write('&zone_id=$_zoneId')
      ..write('&service_schedule=${schedule.scheduleTimeString}')
      ..write('&service_address_id=${_addressIdOf(address)}')
      ..write('&contact_person_name=${Uri.encodeComponent(contactName)}')
      ..write('&contact_person_number=${Uri.encodeComponent(contactPhone)}')
      ..write('&callback=${AppConstants.baseUrl}')
      ..write('&service_address=$encodedAddress')
      ..write('&cart_provider_id=${Get.find<CartController>().scopeProviderId}')
      ..write('&is_partial=$_isPartialFlag')
      ..write('&payment_platform=app');

    if (isBidFlow) {
      url
        ..write('&service_location=customer')
        ..write('&post_id=$_postId')
        ..write('&provider_id=$_providerId');
    } else {
      url
        ..write('&service_location=${_locationType.name}')
        ..write(
          '&new_user_info=${base64Encode(utf8.encode(jsonEncode(newUserInfo?.toJson())))}',
        );
    }

    printLog('checkout digital payment url: $url');
    Get.toNamed(
      RouteHelper.getPaymentWebviewRoute(
        url: url.toString(),
        amount: _totals.dueAmount,
        createdAccount: _isCreateAccount,
      ),
    );
  }

  void handleGuestAccountToken({required String token, SignUpBody? userInfo}) {
    final ConfigContent? config = Get.find<SplashController>().configModel.content;
    if (config?.phoneVerification == 1) {
      pendingVerificationUser = userInfo;
      return;
    }
    Get.find<AuthController>().saveUserToken(token: token);
    Get.find<UserController>().getUserInfo();
  }

  SignUpBody? pendingVerificationUser;

  Future<ExistingUserStatus> checkExistingUser({required String phone}) async {
    final Response response = await checkoutRepo.checkExistingUser(phone: phone);
    final dynamic body = response.body;

    if (response.statusCode == 400 &&
        body is Map &&
        body['response_code'] == 'user_exist_400') {
      return ExistingUserStatus.taken;
    }
    if (response.statusCode == 200) {
      return ExistingUserStatus.available;
    }
    return ExistingUserStatus.unknown;
  }

  static String encodeToken(String payload) => base64Url.encode(utf8.encode(payload));

  static String? decodeToken(String token) {
    final List<String> candidates = <String>[
      token,
      token.replaceAll('-', '+').replaceAll('_', '/'),
      token.replaceAll('+', '-').replaceAll('/', '_'),
    ];
    for (final String candidate in candidates) {
      try {
        return utf8.decode(base64.decode(base64.normalize(candidate)));
      } catch (_) {
      }
    }
    return null;
  }

  Future<CheckoutPaymentResponseModel?> getDigitalPaymentResponse({String? transactionId}) async {
    final Response response =
        await checkoutRepo.getDigitalPaymentResponse(transactionId: transactionId);
    final dynamic body = response.body;
    if (response.statusCode == 200 && body is Map<String, dynamic>) {
      return CheckoutPaymentResponseModel.fromJson(body);
    }
    return null;
  }

  void saveProDiscountAmount() {
    _proDiscountAmount = _totals.proDiscount.toString();
    checkoutRepo.saveProDiscountAmount(_proDiscountAmount ?? '0');
  }

  void loadProDiscountAmount() {
    _proDiscountAmount = checkoutRepo.getProDiscountAmount();
  }

  final GlobalKey<FormState> offlineFormKey = GlobalKey<FormState>();

  List<TextEditingController> _offlineInputControllers = <TextEditingController>[];
  List<TextEditingController> get offlineInputControllers => List<TextEditingController>.unmodifiable(_offlineInputControllers);

  void buildOfflineInputControllers({bool notify = false}) {
    disposeOfflineInputControllers();
    final List<CheckoutOfflineCustomerInformation> fields =
        _selectedOfflineMethod?.customerInformation ?? <CheckoutOfflineCustomerInformation>[];
    _offlineInputControllers =
        List<TextEditingController>.generate(fields.length, (_) => TextEditingController());
    if (notify) {
      update();
    }
  }

  void disposeOfflineInputControllers() {
    for (final TextEditingController controller in _offlineInputControllers) {
      controller.dispose();
    }
    _offlineInputControllers = <TextEditingController>[];
  }

  Map<String, String> collectOfflineInputValues() {
    final Map<String, String> values = <String, String>{};
    final List<CheckoutOfflineCustomerInformation> fields =
        _selectedOfflineMethod?.customerInformation ?? <CheckoutOfflineCustomerInformation>[];
    for (int index = 0; index < fields.length && index < _offlineInputControllers.length; index++) {
      final String? fieldName = fields[index].fieldName;
      if (fieldName != null) {
        values[fieldName] = _offlineInputControllers[index].text;
      }
    }
    return values;
  }

  Future<bool> submitOfflinePaymentData({
    required String bookingId,
    required int isPartialPayment,
  }) async {
    final CheckoutOfflineMethodModel? method = _selectedOfflineMethod;
    final String? methodId = method?.id;
    if (methodId == null) {
      customSnackBar('provide_offline_payment_info'.tr, type: ToasterMessageType.info);
      return false;
    }
    if (bookingId.isEmpty) {
      customSnackBar('something_went_wrong'.tr, type: ToasterMessageType.info);
      return false;
    }

    _isLoading = true;
    update();

    final String encodedInfo = base64Url.encode(
      utf8.encode(jsonEncode(<Map<String, String>>[collectOfflineInputValues()])),
    );

    final Response response = await checkoutRepo.submitOfflinePaymentData(
      bookingId: bookingId,
      offlinePaymentId: methodId,
      offlinePaymentInfo: encodedInfo,
      isPartialPayment: isPartialPayment,
    );

    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      customSnackBar('now_wait_for_your_payment_to_be_verified'.tr, toasterTitle: 'your_payment_confirm_successfully'.tr, type: ToasterMessageType.success);
      return true;
    }

    ApiChecker.checkApi(response);
    return false;
  }

  Future<Response> checkPriceAreUpdated(String providerId) async {
    _isLoading = true;
    update();

    final Response response = await checkoutRepo.checkPriceAreUpdated(providerId);

    _isLoading = false;
    update();

    return response;
  }



  @override
  void onClose() {
    _cartListenerDisposer?.call();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    disposeOfflineInputControllers();
    super.onClose();
  }
}
