import 'package:tatarigigs_user/feature/booking/widget/common/booking_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_status_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

enum _OccurrenceAction { details, invoice, cancel }

class ServiceLogSection extends StatelessWidget {
  final RepeatServiceGroup group;
  final List<BookingRepeatChild> children;
  final VoidCallback onReload;

  const ServiceLogSection({
    super.key,
    required this.group,
    required this.children,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return BookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${group.titleKey.tr} (${children.length})',
            style: context.heading.large,
          ),
          const SizedBox(height: Dimensions.padding8),
          ...List<Widget>.generate(children.length * 2 - 1, (int index) {
            if (index.isOdd) {
              return Divider(height: Dimensions.padding20, color: Theme.of(context).hintColor.withValues(alpha: 0.20));
            }
            return _OccurrenceRow(
              child: children[index ~/ 2],
              isNextService: group == RepeatServiceGroup.nextService,
              onReload: onReload,
            );
          }),
        ],
      ),
    );
  }
}

class _OccurrenceRow extends StatelessWidget {
  final BookingRepeatChild child;
  final bool isNextService;
  final VoidCallback onReload;

  const _OccurrenceRow({
    required this.child,
    required this.isNextService,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'ID #${child.readableId}',
                      style: context.heading.defaultSize,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding8),
                  BookingStatusWidget(status: child.rawStatus),
                ],
              ),
              const SizedBox(height: Dimensions.padding4),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  child.scheduledAt == null ? '-' : DateConverter.dateMonthYearTime(child.scheduledAt),
                  style: context.body.small,
                ),
              ),
            ],
          ),
        ),
        _OccurrenceMenu(child: child, isNextService: isNextService, onReload: onReload),
      ],
    );
  }
}

class _OccurrenceMenu extends StatelessWidget {
  final BookingRepeatChild child;
  final bool isNextService;
  final VoidCallback onReload;

  const _OccurrenceMenu({
    required this.child,
    required this.isNextService,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final List<_OccurrenceAction> actions = _actionsFor(child.status);
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<_OccurrenceAction>(
      position: PopupMenuPosition.under,
      elevation: 8,
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
      ),
      onSelected: (_OccurrenceAction action) => _run(context, action),
      itemBuilder: (BuildContext context) => actions
          .map((_OccurrenceAction action) => PopupMenuItem<_OccurrenceAction>(
                value: action,
                height: 42,
                child: Row(
                  children: <Widget>[
                    Icon(_iconOf(action), size: 16, color: context.customThemeColors.secondaryTextColor),
                    const SizedBox(width: Dimensions.padding10),
                    Text(_labelKeyOf(action).tr, style: context.body.small.overrideWith(color: context.customThemeColors.textColor)),
                  ],
                ),
              ))
          .toList(growable: false),
      child: Icon(Icons.more_vert_rounded, color: context.customThemeColors.secondaryTextColor),
    );
  }

  List<_OccurrenceAction> _actionsFor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return <_OccurrenceAction>[_OccurrenceAction.invoice];
      case BookingStatus.accepted:
        return <_OccurrenceAction>[
          if (isNextService) _OccurrenceAction.details,
          _OccurrenceAction.invoice,
          if (!isNextService) _OccurrenceAction.cancel,
        ];
      case BookingStatus.ongoing:
      case BookingStatus.completed:
      case BookingStatus.canceled:
        return <_OccurrenceAction>[_OccurrenceAction.details, _OccurrenceAction.invoice];
      case BookingStatus.unknown:
        return <_OccurrenceAction>[];
    }
  }

  IconData _iconOf(_OccurrenceAction action) {
    switch (action) {
      case _OccurrenceAction.details:
        return Icons.remove_red_eye_outlined;
      case _OccurrenceAction.invoice:
        return Icons.file_download_outlined;
      case _OccurrenceAction.cancel:
        return Icons.cancel_outlined;
    }
  }

  String _labelKeyOf(_OccurrenceAction action) {
    switch (action) {
      case _OccurrenceAction.details:
        return 'booking_details';
      case _OccurrenceAction.invoice:
        return 'download_invoice';
      case _OccurrenceAction.cancel:
        return 'cancel';
    }
  }

  Future<void> _run(BuildContext context, _OccurrenceAction action) async {
    switch (action) {
      case _OccurrenceAction.details:
        await Get.toNamed<void>(RouteHelper.getBookingDetailsRoute(subBookingId: child.id));
        onReload();
        break;

      case _OccurrenceAction.invoice:
        final String languageCode = Get.find<LocalizationController>().locale.languageCode;
        final Uri uri = Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.singleRepeatBookingInvoiceUrl}${child.id}/$languageCode',
        );
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          customSnackBar('something_went_wrong'.tr);
        }
        break;

      case _OccurrenceAction.cancel:
        _confirmCancel(context);
        break;
    }
  }

  void _confirmCancel(BuildContext context) {
    showBookingBottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.warning,
        title: 'are_you_sure_to_cancel_your_order'.tr,
        description: 'your_order_will_be_cancel'.tr,
        noButtonText: 'yes_cancel'.tr,
        noButtonColor: Theme.of(context).colorScheme.primary,
        noTextColor: Colors.white,
        yesButtonText: 'not_now'.tr,
        yesButtonColor: Theme.of(context).colorScheme.error,
        yesTextColor: Colors.white,
        onYesPressed: () => Get.back<void>(),
        onNoPressed: () {
          Get.back<void>();
          Get.find<BookingDetailsController>().cancelRepeatChild(childId: child.id);
        },
      ),
    );
  }
}
