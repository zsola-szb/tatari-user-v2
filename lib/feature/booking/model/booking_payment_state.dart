import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingPartialPayment {
  final String id;
  final String paidWith;
  final double paidAmount;
  final double dueAmount;

  const BookingPartialPayment({
    this.id = '',
    this.paidWith = '',
    this.paidAmount = 0,
    this.dueAmount = 0,
  });

  factory BookingPartialPayment.fromJson(Map<String, dynamic> json) => BookingPartialPayment(
        id: BookingParse.string(json['id']) ?? '',
        paidWith: BookingParse.string(json['paid_with']) ?? '',
        paidAmount: BookingParse.toDouble(json['paid_amount']),
        dueAmount: BookingParse.toDouble(json['due_amount']),
      );

  bool get isWallet => paidWith == 'wallet';

  bool get isCashAfterService => paidWith == 'cash_after_service';

  bool get isDigital => paidWith == 'digital';

  String labelFor(BookingPaymentMethod method) {
    final String prefix = isCashAfterService
        ? 'paid_amount'.tr : (isDigital && method.isOffline) ? '' : 'paid_by'.tr;

    final String suffix = isDigital
        ? method.apiKey.isEmpty ? 'digital_payment'.tr : method.apiKey.tr
        : isCashAfterService ? '(${'cash_after_service'.tr})' : paidWith.tr;

    return prefix.isEmpty ? suffix : '$prefix $suffix';
  }
}

class BookingOfflinePaymentField {
  final String key;
  final String value;

  const BookingOfflinePaymentField({this.key = '', this.value = ''});

  factory BookingOfflinePaymentField.fromJson(Map<String, dynamic> json) => BookingOfflinePaymentField(
        key: BookingParse.string(json['key']) ?? '',
        value: BookingParse.string(json['value']) ?? '',
      );

  String get label => key.replaceAll('_', ' ').capitalizeFirst ?? key;
}

class BookingPaymentState {
  final BookingPaymentMethod method;
  final String rawMethod;
  final bool isPaid;
  final double displayAmount;
  final List<BookingPartialPayment> partialPayments;
  final List<BookingOfflinePaymentField> offlineFields;
  final BookingOfflinePaymentState offlineState;
  final String? offlinePaymentId;
  final String? deniedNote;
  final String? offlineMethodName;
  final String? transactionId;

  const BookingPaymentState({
    this.method = BookingPaymentMethod.unknown,
    this.rawMethod = '',
    this.isPaid = false,
    this.displayAmount = 0,
    this.partialPayments = const <BookingPartialPayment>[],
    this.offlineFields = const <BookingOfflinePaymentField>[],
    this.offlineState = BookingOfflinePaymentState.notApplicable,
    this.offlinePaymentId,
    this.deniedNote,
    this.offlineMethodName,
    this.transactionId,
  });

  const BookingPaymentState.empty() : this();

  factory BookingPaymentState.fromJson(Map<String, dynamic> json) {
    final String rawMethod = BookingParse.string(json['payment_method']) ?? '';
    final BookingPaymentMethod method = BookingPaymentMethod.fromApi(rawMethod);
    final bool isPaid = BookingParse.toBool(json['is_paid']);
    final double total = BookingParse.toDouble(json['total_booking_amount']);

    final List<BookingPartialPayment> partials = BookingParse.objectList<BookingPartialPayment>(
      json['booking_partial_payments'],
      BookingPartialPayment.fromJson,
    );

    final List<BookingOfflinePaymentField> offlineFields =
        BookingParse.objectList<BookingOfflinePaymentField>(
      json['booking_offline_payment'],
      BookingOfflinePaymentField.fromJson,
    );

    final String? deniedNote = BookingParse.string(json['offline_payment_denied_note']);

    double displayAmount = total;
    for (final BookingPartialPayment payment in partials) {
      if (payment.isWallet) {
        displayAmount = payment.dueAmount;
      }
    }

    return BookingPaymentState(
      method: method,
      rawMethod: rawMethod,
      isPaid: isPaid,
      displayAmount: displayAmount,
      partialPayments: partials,
      offlineFields: offlineFields,
      offlineState: _offlineStateOf(
        method: method,
        isPaid: isPaid,
        hasFields: offlineFields.isNotEmpty,
        deniedNote: deniedNote,
      ),
      offlinePaymentId: BookingParse.string(json['offline_payment_id']),
      deniedNote: deniedNote,
      offlineMethodName: BookingParse.string(json['booking_offline_payment_method']),
      transactionId: BookingParse.string(json['transaction_id']),
    );
  }

  static BookingOfflinePaymentState _offlineStateOf({
    required BookingPaymentMethod method,
    required bool isPaid,
    required bool hasFields,
    required String? deniedNote,
  }) {
    if (!method.isOffline) {
      return BookingOfflinePaymentState.notApplicable;
    }
    if (deniedNote != null && deniedNote.isNotEmpty) {
      return BookingOfflinePaymentState.denied;
    }
    if (isPaid) {
      return BookingOfflinePaymentState.verified;
    }
    return hasFields ? BookingOfflinePaymentState.pendingVerification : BookingOfflinePaymentState.awaitingSubmission;
  }

  bool get isPartialPayment => partialPayments.isNotEmpty;

  String get methodLabelKey => rawMethod.isEmpty ? 'payment_method' : rawMethod;

  bool get hasOfflineFields => offlineFields.isNotEmpty;

  bool get showDeniedNote => offlineState == BookingOfflinePaymentState.denied;

  bool get showTransactionId => method.hasTransactionId && (transactionId ?? '').isNotEmpty;

  bool get showOfflineFieldList => method.isOffline && hasOfflineFields;
}
