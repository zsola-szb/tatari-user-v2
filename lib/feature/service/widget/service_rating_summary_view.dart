import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const Color _kStarColor = Color(0xFFF5A623);

class ServiceRatingSummaryView extends StatelessWidget {
  final Rating? rating;
  const ServiceRatingSummaryView({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final double avg = rating?.averageRating ?? 0;
    final int total = rating?.reviewCount ?? rating?.ratingCount ?? 0;
    final List<RatingGroupCount> groupCount = rating?.ratingGroupCount ?? [];

    int countFor(int star) {
      for (final group in groupCount) {
        if (group.reviewRating?.round() == star) {
          return group.total ?? 0;
        }
      }
      return 0;
    }

    final Map<int, int> breakdown = {for (int star = 5; star >= 1; star--) star: countFor(star)};
    final int breakdownTotal = breakdown.values.fold(0, (sum, count) => sum + count);

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(Dimensions.padding10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.customThemeColors.backGroundColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star_rounded, size: 20, color: _kStarColor),
                    Gaps.horizontalGapOf(Dimensions.padding4),
                    Text(avg.toStringAsFixed(1), style: context.heading.overLarge.strong),
                  ]),
                ),
                Gaps.verticalGapOf(Dimensions.padding4),
                Text('$total ${'reviews'.tr}', style: context.body.small, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding16),
          Expanded(
            child: Column(
              children: [
                for (int star = 5; star >= 1; star--)
                  _BreakdownRow(label: _starLabel(star), count: breakdown[star] ?? 0, total: breakdownTotal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _starLabel(int star) {
  switch (star) {
    case 5:
      return 'excellent'.tr;
    case 4:
      return 'good'.tr;
    case 3:
      return 'average'.tr;
    case 2:
      return 'below_average'.tr;
    case 1:
    default:
      return 'poor'.tr;
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  const _BreakdownRow({required this.label, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text(label, style: context.body.small, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : count / total,
              minHeight: 3,
              backgroundColor: Theme.of(context).cardColor,
              valueColor: const AlwaysStoppedAnimation<Color>(_kStarColor),
            ),
          ),
        ),
        Gaps.horizontalGapOf(Dimensions.padding10),
        SizedBox(width: 24, child: Text('$count', textAlign: TextAlign.end, style: context.subHeading.small.medium)),
      ]),
    );
  }
}
