library;

enum BookingStatus {
  pending,
  accepted,
  ongoing,
  completed,
  canceled,
  unknown;

  static BookingStatus fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'accepted':
        return BookingStatus.accepted;
      case 'ongoing':
        return BookingStatus.ongoing;
      case 'completed':
        return BookingStatus.completed;
      case 'canceled':
      case 'cancelled':
        return BookingStatus.canceled;
      default:
        return BookingStatus.unknown;
    }
  }

  String get apiKey => this == BookingStatus.unknown ? '' : name;

  String get labelKey => apiKey;

  bool get isPending => this == BookingStatus.pending;

  bool get isCompleted => this == BookingStatus.completed;

  bool get isCanceled => this == BookingStatus.canceled;

  bool get isActive => this == BookingStatus.accepted || this == BookingStatus.ongoing;

  bool get isTerminal => this == BookingStatus.completed || this == BookingStatus.canceled;

  bool get isBeforeSettlement =>
      this == BookingStatus.pending || this == BookingStatus.accepted || this == BookingStatus.ongoing;
}

enum BookingListTab {
  all,
  pending,
  accepted,
  ongoing,
  completed,
  canceled;

  String get apiKey => name;

  String get labelKey => this == BookingListTab.all ? 'all' : name;

  static BookingListTab fromApi(String? value) {
    for (final BookingListTab tab in BookingListTab.values) {
      if (tab.name == value?.trim().toLowerCase()) {
        return tab;
      }
    }
    return BookingListTab.all;
  }
}

enum BookingKind {
  regular,

  repeatParent,

  repeatChild,

  customize;

  static BookingKind fromFlags({
    required bool isRepeat,
    required bool isCustomize,
    required bool isRepeatChild,
  }) {
    if (isRepeatChild) {
      return BookingKind.repeatChild;
    }
    if (isRepeat) {
      return BookingKind.repeatParent;
    }
    return isCustomize ? BookingKind.customize : BookingKind.regular;
  }

  bool get isRepeat => this == BookingKind.repeatParent || this == BookingKind.repeatChild;

  bool get isRepeatChild => this == BookingKind.repeatChild;

  bool get isRepeatParent => this == BookingKind.repeatParent;

  bool get isCustomize => this == BookingKind.customize;
}

enum BookingScheduleKind {
  instant,
  scheduled,
  repeat;

  String get labelKey {
    switch (this) {
      case BookingScheduleKind.instant:
        return 'instant_booking';
      case BookingScheduleKind.scheduled:
        return 'schedule_booking';
      case BookingScheduleKind.repeat:
        return 'repeat_booking';
    }
  }
}

enum BookingPaymentMethod {
  cashAfterService,
  walletPayment,
  offlinePayment,
  digital,
  unknown;

  static BookingPaymentMethod fromApi(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'cash_after_service':
        return BookingPaymentMethod.cashAfterService;
      case 'wallet_payment':
        return BookingPaymentMethod.walletPayment;
      case 'offline_payment':
        return BookingPaymentMethod.offlinePayment;
      case null:
      case '':
        return BookingPaymentMethod.unknown;
      default:
        return BookingPaymentMethod.digital;
    }
  }

  String get apiKey {
    switch (this) {
      case BookingPaymentMethod.cashAfterService:
        return 'cash_after_service';
      case BookingPaymentMethod.walletPayment:
        return 'wallet_payment';
      case BookingPaymentMethod.offlinePayment:
        return 'offline_payment';
      case BookingPaymentMethod.digital:
      case BookingPaymentMethod.unknown:
        return '';
    }
  }

  bool get isCashAfterService => this == BookingPaymentMethod.cashAfterService;

  bool get isWallet => this == BookingPaymentMethod.walletPayment;

  bool get isOffline => this == BookingPaymentMethod.offlinePayment;

  bool get hasTransactionId => this == BookingPaymentMethod.digital;
}

enum BookingOfflinePaymentState {
  notApplicable,

  awaitingSubmission,

  pendingVerification,

  denied,

  verified;

  bool get isOffline => this != BookingOfflinePaymentState.notApplicable;
}

enum BookingTotalLayout {simple, withDueAmount, walletPaid, partialPayments}

enum BookingListStatus {loading, ready, paginating, empty, error}

enum BookingDetailsStatus { idle, loading, ready, error }

enum BookingDetailsTab {
  details,
  status;

  String get labelKey => this == BookingDetailsTab.details ? 'booking_details' : 'status';
}

enum RepeatBookingTab {
  details,
  serviceLog;

  String get labelKey => this == RepeatBookingTab.details ? 'booking_details' : 'service_log';
}

enum RepeatServiceGroup {
  nextService,
  upcoming,
  alreadyProvided;

  String get titleKey {
    switch (this) {
      case RepeatServiceGroup.nextService:
        return 'next_service';
      case RepeatServiceGroup.upcoming:
        return 'upcoming_services';
      case RepeatServiceGroup.alreadyProvided:
        return 'already_provided';
    }
  }
}

enum RebookDecision {proceed, providerUnavailable, servicesChanged, failed}
