import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartProviderAvailabilityRow extends StatelessWidget {
  final ProviderData? provider;

  const CartProviderAvailabilityRow({super.key, required this.provider});

  static String? availabilityWindow(ProviderData? provider) {
    if (provider == null || provider.isAvailable == false) {
      return null;
    }

    final String? startTime = provider.timeSchedule?.startTime;
    final String? endTime = provider.timeSchedule?.endTime;
    if (startTime == null || endTime == null) {
      return null;
    }

    final List<String> weekends = provider.weekends ?? <String>[];
    if (weekends.contains(DateConverter.dateToWeek(DateTime.now()).toLowerCase())) {
      return null;
    }

    final String start = DateConverter.convertStringDateTimeToTime(startTime);
    final String end = DateConverter.convertStringDateTimeToTime(endTime);
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final String? availability = availabilityWindow(provider);

    return Row(
      children: <Widget>[
        Icon(Icons.access_time_rounded, size: 13, color: Theme.of(context).hintColor),
        const SizedBox(width: Dimensions.padding4),

        if (availability == null)
          Flexible(
            child: Text(
              'provider_is_currently_on_a_break'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.body.small,
            ),
          )
        else ...<Widget>[
          Text('${'availability'.tr}: ', style: context.body.small),
          Flexible(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                availability,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.subHeading.small.overrideWith(
                  color: context.customThemeColors.secondaryTextColor,
                  fontWeight: AppWeight.medium,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}