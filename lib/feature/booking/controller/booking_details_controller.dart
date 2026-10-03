import 'dart:convert';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class BookingDetailsController extends GetxController implements GetxService {
  final BookingRepo bookingRepo;

  BookingDetailsController({required this.bookingRepo});

  static const Duration _instantBookingWindow = Duration(minutes: 10);

  static const List<String> _alreadyMovedOnCodes = <String>[
    'booking_already_accepted_200',
    'booking_already_ongoing_200',
    'booking_already_completed_200',
  ];

  BookingDetailsStatus _status = BookingDetailsStatus.idle;
  BookingDetailsStatus get status => _status;

  bool get isLoading => _status == BookingDetailsStatus.loading;
  bool get hasBooking => _booking != null;

  bool get isEmpty => _booking?.id.isEmpty ?? true;

  BookingDetailModel? _booking;
  BookingDetailModel? get booking => _booking;

  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  BookingDetailsTab _detailsTab = BookingDetailsTab.details;
  BookingDetailsTab get detailsTab => _detailsTab;

  RepeatBookingTab _repeatTab = RepeatBookingTab.details;
  RepeatBookingTab get repeatTab => _repeatTab;

  final TextEditingController bookingIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  bool _trackAttempted = false;
  bool get trackAttempted => _trackAttempted;

  // What the user is allowed to do with the loaded booking.
  //
  // These gates read the booking together with app state — login and config —
  // so they live here rather than on BookingDetailModel, which stays a plain
  // parsed representation of the API response.

  ConfigContent? get _config => Get.find<SplashController>().configModel.content;

  bool get _isLoggedIn => Get.find<AuthController>().isLoggedIn();

  bool get canCancel {
    final BookingDetailModel? current = _booking;
    return current != null && current.status.isPending && current.status != BookingStatus.unknown;
  }

  bool get canRebook {
    final BookingDetailModel? current = _booking;
    return current != null &&
        Get.find<BookingRebookController>().canRebook(status: current.status, kind: current.kind);
  }

  bool get canReview {
    final BookingDetailModel? current = _booking;
    return current != null && current.status.isCompleted && _isLoggedIn;
  }

  bool get canContact {
    final BookingDetailModel? current = _booking;
    return current != null && current.status.isActive && _isLoggedIn && current.provider != null;
  }

  bool get showOtp {
    final BookingDetailModel? current = _booking;
    return current != null &&
        (_config?.confirmationOtpStatus ?? false) && current.status.isActive && hasOtp;
  }

  bool get canPayIndividually {
    final BookingDetailModel? current = _booking;
    return current != null &&
        current.kind.isRepeatChild && !current.payment.isPaid && current.status.isActive;
  }

  bool get canSwitchToDigital {
    final BookingDetailModel? current = _booking;
    if (current == null || current.kind.isRepeat) {
      return false;
    }
    final BookingPaymentState payment = current.payment;
    return payment.method.isCashAfterService && !payment.isPaid && !current.status.isCanceled &&
        _config?.isCodToDigitalPaymentActive == 1;
  }

  bool get canManageOfflinePayment {
    final BookingPaymentState? payment = _booking?.payment;
    return payment != null && payment.method.isOffline && !payment.isPaid && payment.hasOfflineFields;
  }

  bool get mustCompleteOfflinePayment {
    final BookingDetailModel? current = _booking;
    return current != null && current.payment.method.isOffline &&
        !current.payment.hasOfflineFields && !current.status.isCanceled;
  }

  // How the loaded booking reads on screen: the shape of its schedule, where
  // the service happens, and which sections have anything to show.

  BookingScheduleKind get scheduleKind {
    final BookingDetailModel? current = _booking;
    if (current == null) {
      return BookingScheduleKind.scheduled;
    }
    if (current.kind.isRepeat) {
      return BookingScheduleKind.repeat;
    }
    final DateTime? placed = current.placedAt;
    final DateTime? scheduled = current.scheduledAt;
    if (placed == null || scheduled == null) {
      return BookingScheduleKind.scheduled;
    }
    final Duration gap = scheduled.difference(placed);
    return gap <= _instantBookingWindow ? BookingScheduleKind.instant : BookingScheduleKind.scheduled;
  }

  String get bookingTypeDetailKey {
    final BookingDetailModel? current = _booking;
    return current != null && current.kind.isRepeat ? current.repeat.typeLabelKey : scheduleKind.labelKey;
  }

  BookingRepeatChild? get nextRepeatService {
    final BookingDetailModel? current = _booking;
    return current == null || current.status.isPending ? null : current.repeat.nextService;
  }

  List<BookingRepeatChild> get upcomingRepeatServices =>
      _booking?.repeat.upcomingExcluding(nextRepeatService) ?? const <BookingRepeatChild>[];

  ServiceLocationType get serviceLocation =>
      _booking?.rawServiceLocation == ServiceLocationType.provider.name
          ? ServiceLocationType.provider : ServiceLocationType.customer;

  bool get isAtProviderLocation => serviceLocation == ServiceLocationType.provider;

  bool get isProviderLocationPending => isAtProviderLocation && _booking?.provider == null;

  String? get serviceLocationAddress =>
      isAtProviderLocation ? _booking?.provider?.companyAddress : _booking?.serviceAddress?.address;

  bool get canOpenDirections => isAtProviderLocation && (_booking?.provider?.hasCoordinates ?? false);

  bool get hasOtp => (_booking?.otp ?? '').replaceAll('null', '').trim().isNotEmpty;

  bool get hasEvidencePhotos => _booking?.evidencePhotos.isNotEmpty ?? false;

  bool get hasServiceman {
    final BookingServicemanModel? serviceman = _booking?.serviceman;
    return serviceman != null && serviceman.hasName;
  }

  bool get hasEditHistory => _booking?.editHistory.isNotEmpty ?? false;

  // How each service line of the loaded booking prices out.

  int totalQuantityOf(BookingServiceItemModel service) => service.variations
      .fold(0, (int sum, BookingServiceVariation v) => sum + (v.quantity <= 0 ? 1 : v.quantity));

  int variationCountOf(BookingServiceItemModel service) => service.variations.length;

  bool hasVariations(BookingServiceItemModel service) => service.variations.isNotEmpty;

  double lineTotalOf(BookingServiceItemModel service) =>
      service.variations.fold(0, (double sum, BookingServiceVariation v) => sum + v.lineTotal);

  double discountedLineTotalOf(BookingServiceItemModel service) => service.variations
      .fold(0, (double sum, BookingServiceVariation v) => sum + v.discountedLineTotal);

  bool hasDiscount(BookingServiceItemModel service) =>
      lineTotalOf(service) > discountedLineTotalOf(service);

  // Which rows the billing summary shows, and how the grand total is laid out.
  // The regular booking reads `billing`; a repeat booking reads `repeatBilling`,
  // hence the `repeat` prefix on its own set.

  BookingBillingTotals get _billing => _booking?.billing ?? const BookingBillingTotals.empty();

  RepeatBookingBillingTotals get _repeatBilling =>
      _booking?.repeatBilling ?? const RepeatBookingBillingTotals.empty();

  bool get isPartialPayment => _billing.partialPayments.isNotEmpty;

  BookingTotalLayout get billingLayout {
    if (isPartialPayment) {
      return BookingTotalLayout.partialPayments;
    }
    if (_billing.method.isWallet) {
      return BookingTotalLayout.walletPaid;
    }
    if (_billing.additionalCharge == 0 || _billing.method.isCashAfterService) {
      return BookingTotalLayout.simple;
    }
    return BookingTotalLayout.withDueAmount;
  }

  bool get showReferralDiscount => _billing.referralDiscount > 0;

  bool get showExtraFee => _billing.extraFee > 0;

  bool get showProDiscountRow => _billing.proBenefitType == 'discount' && _billing.proDiscount > 0;

  bool get isProCouponBenefit => _billing.proBenefitType == 'coupon' && _billing.proDiscount > 0;

  bool get isProServiceFeeBenefit => _billing.proBenefitType == 'service_fee' && _billing.proDiscount > 0;

  double get extraFeeBeforeProDiscount => _billing.extraFee + _billing.proDiscount;

  bool get showRefund =>
      _billing.additionalCharge < 0 && (!_billing.method.isCashAfterService || isPartialPayment);

  bool get showOutstandingRow {
    switch (billingLayout) {
      case BookingTotalLayout.withDueAmount:
      case BookingTotalLayout.walletPaid:
        return _billing.additionalCharge > 0;
      case BookingTotalLayout.partialPayments:
        return _billing.partialPayments.length == 1 && _billing.dueAmount > 0;
      case BookingTotalLayout.simple:
        return false;
    }
  }

  double get outstandingAmount => billingLayout == BookingTotalLayout.partialPayments
      ? _billing.dueAmount : _billing.additionalCharge;

  String get outstandingLabelKey => _billing.isBeforeSettlement ? 'due_amount' : 'paid_amount';

  String get walletHeadlineKey => _billing.additionalCharge <= 0
      ? 'total_order_amount_has_been_paid_by_customer' : 'has_been_paid_by_customer';

  double get repeatDueAmount =>
      _repeatBilling.grandTotal - _repeatBilling.paidAmount - _repeatBilling.canceledAmount;

  bool get showRepeatReferralDiscount => _repeatBilling.referralDiscount > 0;

  bool get showRepeatExtraFee => _repeatBilling.extraFee > 0;

  bool get showRepeatPaidRow => _repeatBilling.paidAmount > 0;

  bool get showRepeatCanceledRow => _repeatBilling.canceledAmount > 0;

  bool get showRepeatDueRow => _repeatBilling.paidAmount > 0 && repeatDueAmount > 0;

  Future<void> initData({
    String? bookingId,
    String? subBookingId,
    String? phone,
    String? token,
  }) async {
    _booking = null;
    _detailsTab = BookingDetailsTab.details;
    _repeatTab = RepeatBookingTab.details;
    _status = BookingDetailsStatus.loading;
    _notify();

    final String? transactionId = _transactionIdOf(token);
    if (transactionId != null) {
      await _loadFromPaymentToken(transactionId);
      return;
    }

    final String? readableId = BookingParse.string(bookingId);
    final String? occurrenceId = BookingParse.string(subBookingId);

    if (phone != null && phone.isNotEmpty && readableId != null) {
      await loadTrackedBooking(readableId: readableId, phone: phone);
      return;
    }
    if (occurrenceId != null) {
      await loadBooking(bookingId: occurrenceId, isRepeatChild: true);
      return;
    }
    if (readableId != null) {
      await loadBooking(bookingId: readableId);
      return;
    }

    _status = BookingDetailsStatus.error;
    _notify();
  }

  Future<void> loadBooking({
    required String bookingId,
    bool isRepeatChild = false,
    bool showLoader = true,
  }) async {
    if (showLoader) {
      _status = BookingDetailsStatus.loading;
      _notify();
    }

    final Response response = isRepeatChild
        ? await bookingRepo.getSubBookingDetails(subBookingId: bookingId) : await bookingRepo.getBookingDetails(bookingId: bookingId);

    _applyBookingResponse(response, isRepeatChild: isRepeatChild);
  }

  void restoreBooking(BookingDetailModel booking) {
    _booking = booking;
    _status = BookingDetailsStatus.ready;
    _notify();
  }

  Future<void> reloadBooking({bool showLoader = false}) async {
    final BookingDetailModel? current = _booking;
    if (current == null || current.id.isEmpty) {
      return;
    }
    await loadBooking(
      bookingId: current.id,
      isRepeatChild: current.kind.isRepeatChild,
      showLoader: showLoader,
    );
  }

  Future<void> _loadFromPaymentToken(String transactionId) async {
    final Response response = await bookingRepo.getDigitalPaymentResponse(transactionId: transactionId);
    final Map<String, dynamic>? content =
        response.body is Map ? BookingParse.object((response.body as Map)['content']) : null;

    final String? repeatId = BookingParse.string(content?['booking_repeat_id']);
    if (repeatId != null) {
      await loadBooking(bookingId: repeatId, isRepeatChild: true);
      return;
    }

    final String? bookingId = BookingParse.string(content?['booking_id']);
    if (bookingId != null) {
      await loadBooking(bookingId: bookingId);
      return;
    }

    _status = BookingDetailsStatus.error;
    _notify();
  }

  String? _transactionIdOf(String? token) {
    final String? raw = BookingParse.string(token);
    if (raw == null) {
      return null;
    }
    try {
      final String decoded = utf8.decode(base64Url.decode(raw));
      final String reference = StringParser.parseString(decoded, 'transaction_reference');
      return reference.isEmpty ? null : reference;
    } catch (_) {
      return null;
    }
  }

  void _applyBookingResponse(Response response, {required bool isRepeatChild}) {
    if (response.statusCode == 200 && response.body is Map) {
      final Map<String, dynamic>? content = BookingParse.object((response.body as Map)['content']);
      if (content != null) {
        _booking = BookingDetailModel.fromJson(content, isRepeatChild: isRepeatChild);
        _status = BookingDetailsStatus.ready;
        _notify();
        return;
      }
    }
    _status = BookingDetailsStatus.error;
    _notify();
    ApiChecker.checkApi(response);
  }

  void selectDetailsTab(BookingDetailsTab tab, {bool notify = true}) {
    if (_detailsTab == tab) {
      return;
    }
    _detailsTab = tab;
    if (notify) {
      _notify();
    }
  }

  void selectRepeatTab(RepeatBookingTab tab, {bool notify = true}) {
    if (_repeatTab == tab) {
      return;
    }
    _repeatTab = tab;
    if (notify) {
      _notify();
    }
  }

  Future<void> cancelBooking() async {
    final BookingDetailModel? current = _booking;
    if (current == null || _isCancelling) {
      return;
    }

    _isCancelling = true;
    _notify();

    final bool isChild = current.kind.isRepeatChild;
    final Response response = isChild
        ? await bookingRepo.cancelSubBooking(subBookingId: current.id) : await bookingRepo.cancelBooking(bookingId: current.id);

    _isCancelling = false;

    final dynamic body = response.body;
    final String responseCode = body is Map ? '${body['response_code']}' : '';

    if (response.statusCode == 200 && (isChild || responseCode == 'status_update_success_200')) {
      customSnackBar('booking_cancelled_successfully'.tr, type: ToasterMessageType.success);
      await reloadBooking();
      _refreshBookingList();
      return;
    }

    if (response.statusCode == 200 && _alreadyMovedOnCodes.contains(responseCode)) {
      customSnackBar(body is Map ? '${body['message']}' : '');
      await reloadBooking();
      return;
    }

    _notify();
    ApiChecker.checkApi(response);
  }

  /// Cancels a booking by id without needing it loaded first — used by the
  /// `booking_ignored` push, which only carries a booking id.
  Future<void> cancelBookingById({required String bookingId}) async {
    if (bookingId.isEmpty || _isCancelling) {
      return;
    }

    _isCancelling = true;
    _notify();

    final Response response = await bookingRepo.cancelBooking(bookingId: bookingId);
    _isCancelling = false;
    _notify();

    final dynamic body = response.body;
    final String responseCode = body is Map ? '${body['response_code']}' : '';
    final bool isLoaded = _booking?.id == bookingId;

    if (response.statusCode == 200 && responseCode == 'status_update_success_200') {
      customSnackBar('booking_cancelled_successfully'.tr, type: ToasterMessageType.success);
      if (isLoaded) {
        await reloadBooking();
      }
      _refreshBookingList();
      return;
    }

    if (response.statusCode == 200 && _alreadyMovedOnCodes.contains(responseCode)) {
      customSnackBar(body is Map ? '${body['message']}' : '');
      if (isLoaded) {
        await reloadBooking();
      }
      return;
    }

    ApiChecker.checkApi(response);
  }

  Future<void> cancelRepeatChild({required String childId}) async {
    final BookingDetailModel? parent = _booking;
    if (parent == null || _isCancelling) {
      return;
    }

    _isCancelling = true;
    _notify();

    final Response response = await bookingRepo.cancelSubBooking(subBookingId: childId);
    _isCancelling = false;

    if (response.statusCode == 200) {
      customSnackBar('booking_cancelled_successfully'.tr, type: ToasterMessageType.success);
      await loadBooking(bookingId: parent.id, showLoader: false);
      _refreshBookingList();
      return;
    }

    _notify();
    ApiChecker.checkApi(response);
  }

  void _refreshBookingList() {
    if (Get.isRegistered<BookingListController>()) {
      Get.find<BookingListController>().refreshCurrentTab();
    }
  }

  Future<bool> loadTrackedBooking({required String readableId, required String phone}) async {
    _isTracking = true;
    _trackAttempted = true;
    _status = BookingDetailsStatus.loading;
    _notify();

    final Response response = await bookingRepo.trackBooking(readableId: readableId, phone: phone);
    _isTracking = false;

    if (response.statusCode == 200 && response.body is Map) {
      final Map<String, dynamic>? content = BookingParse.object((response.body as Map)['data']);
      if (content != null) {
        _booking = BookingDetailModel.fromJson(content);
        _status = BookingDetailsStatus.ready;
        _notify();
        return true;
      }
    }

    _booking = null;
    _status = BookingDetailsStatus.error;
    _notify();
    return false;
  }

  void resetTracking({bool notify = true}) {
    bookingIdController.clear();
    phoneController.clear();
    _booking = null;
    _trackAttempted = false;
    _status = BookingDetailsStatus.idle;
    if (notify) {
      _notify();
    }
  }

  Future<void> switchToCashAfterService() async {
    final BookingDetailModel? current = _booking;
    if (current == null || _isProcessing) {
      return;
    }

    _isProcessing = true;
    _notify();

    final Response response = await bookingRepo.switchPaymentMethod(
      bookingId: current.id,
      paymentMethod: BookingPaymentMethod.cashAfterService.apiKey,
    );

    _isProcessing = false;

    if (response.statusCode == 200) {
      await reloadBooking();
      customSnackBar('your_payment_confirm_successfully'.tr,
          type: ToasterMessageType.success, showDefaultSnackBar: false);
    } else {
      _notify();
      ApiChecker.checkApi(response, showDefaultToaster: false);
    }
  }

  Future<bool> submitOfflinePaymentData({
    required String offlinePaymentId,
    required Map<String, String> fields,
  }) async {
    final BookingDetailModel? current = _booking;
    if (current == null) {
      return false;
    }

    _isProcessing = true;
    _notify();

    // `customer_information` is a base64url-encoded JSON *array* of field maps —
    // the shape both the legacy and redesigned checkout flows post to this same
    // endpoint. A bare JSON object is not parsed server-side.
    final String encodedFields =
        base64Url.encode(utf8.encode(jsonEncode(<Map<String, String>>[fields])));

    final Response response = await bookingRepo.submitOfflinePaymentData(
      bookingId: current.id,
      offlinePaymentId: offlinePaymentId,
      offlinePaymentInfo: encodedFields,
      isPartialPayment: current.payment.isPartialPayment ? 1 : 0,
    );

    _isProcessing = false;

    if (response.statusCode == 200) {
      customSnackBar('now_wait_for_your_payment_to_be_verified'.tr,
          toasterTitle: 'your_payment_confirm_successfully'.tr, type: ToasterMessageType.success);
      await reloadBooking();
      return true;
    }

    _notify();
    ApiChecker.checkApi(response);
    return false;
  }

  String buildPaymentUrl({required String gateway}) {
    final BookingDetailModel current = _booking!;
    final String userId = Get.find<UserController>().userInfoModel?.id ?? Get.find<SplashController>().getGuestId();
    final String accessToken = base64Url.encode(utf8.encode(userId));

    if (current.kind.isRepeatChild) {
      return '${AppConstants.baseUrl}/payment?payment_method=$gateway&access_token=$accessToken'
          '&callback=${AppConstants.baseUrl}&payment_platform=app&is_repeat_single_booking=1'
          '&booking_repeat_id=${current.id}&booking_id=${current.parentBookingId}';
    }

    final String conversionFlag = current.payment.method.isOffline
        ? 'switch_offline_to_digital=1'
        : 'switch_cod_to_digital=1';

    return '${AppConstants.baseUrl}/payment?payment_method=$gateway&access_token=$accessToken'
        '&booking_id=${current.id}&$conversionFlag'
        '&callback=${AppConstants.baseUrl}&payment_platform=app'
        '&is_partial=${current.payment.isPartialPayment ? 1 : 0}';
  }

  Future<void> downloadInvoice() async {
    final BookingDetailModel? current = _booking;
    if (current == null) {
      return;
    }
    final Uri uri = Uri.parse(_invoiceUrlFor(current));
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      customSnackBar('something_went_wrong'.tr);
    }
  }

  String _invoiceUrlFor(BookingDetailModel booking) {
    final String path = booking.kind.isRepeatChild ? AppConstants.singleRepeatBookingInvoiceUrl
        : booking.kind.isRepeatParent ? AppConstants.repeatBookingInvoiceUrl : AppConstants.regularBookingInvoiceUrl;
    final String languageCode = Get.find<LocalizationController>().locale.languageCode;
    return '${AppConstants.baseUrl}$path${booking.id}/$languageCode';
  }

  Future<void> copyBookingId() async {
    final BookingDetailModel? current = _booking;
    if (current == null) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: current.readableId));
    customSnackBar('copied'.tr, type: ToasterMessageType.success, showDefaultSnackBar: false);
  }

  String get dismissedIncompleteBookingId => bookingRepo.getLastIncompleteOfflineBookingId();

  Future<void> markIncompleteBookingDismissed(String bookingId) =>
      bookingRepo.setLastIncompleteOfflineBookingId(bookingId);

  void _notify() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => update());
      return;
    }
    update();
  }

  @override
  void onClose() {
    bookingIdController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
