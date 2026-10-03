import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_inset_panel.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_summary_row.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatEditHistorySheet extends StatelessWidget {
  final List<RepeatBookingEditEntry> entries;

  const RepeatEditHistorySheet({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('edit_history_log'.tr, style: context.heading.extraLarge),
          const SizedBox(height: Dimensions.padding16),
          if (entries.isEmpty)
            Text('no_data_found'.tr, style: context.body.defaultSize)
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.6),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: entries.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: Dimensions.padding12),
                itemBuilder: (BuildContext context, int index) =>
                    _EditEntryCard(entry: entries[index]),
              ),
            ),
          const SizedBox(height: Dimensions.padding16),
        ],
      ),
    );
  }
}

class _EditEntryCard extends StatelessWidget {
  final RepeatBookingEditEntry entry;

  const _EditEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return BookingInsetPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${'booking_id'.tr} # ${entry.readableId}',
                  style: context.heading.defaultSize,
                ),
              ),
              if (entry.editedAt != null)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    DateConverter.dateMonthYearTime(entry.editedAt),
                    style: context.body.small,
                  ),
                ),
            ],
          ),
          const SizedBox(height: Dimensions.padding8),
          Row(
            children: <Widget>[
              Text('${'total_qty'.tr} : ', style: context.body.small),
              Text(
                '${entry.oldQuantity} → ${entry.newQuantity}',
                style: context.heading.defaultSize,
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  entry.scopeLabelKey.tr,
                  style: context.body.small,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding10),
          ...entry.lines.map((RepeatBookingEditLine line) => Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.padding6),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        line.label.isEmpty ? line.serviceName : line.label,
                        style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.padding8),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${line.quantity} x ${PriceConverter.convertPrice(line.unitPrice)}',
                        style: context.body.small,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(height: Dimensions.padding16, color: Theme.of(context).hintColor.withValues(alpha: 0.20)),
          BookingSummaryRow(label: 'sub_total'.tr, amount: entry.subTotal),
          BookingSummaryRow(
            label: 'service_discount'.tr,
            amount: entry.serviceDiscount,
            sign: BillingRowSign.minus,
          ),
          BookingSummaryRow(
            label: 'service_vat'.tr,
            amount: entry.vat,
            sign: BillingRowSign.plus,
          ),
        ],
      ),
    );
  }
}
