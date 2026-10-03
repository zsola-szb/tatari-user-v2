import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

/// Placeholder cards matching [ChannelItem]'s layout while the inbox loads.
class InboxListShimmer extends StatelessWidget {
  final int itemCount;

  const InboxListShimmer({super.key, this.itemCount = 7});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding12,
          vertical: Dimensions.padding12,
        ),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) => const _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.padding10),
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        boxShadow: Get.isDarkMode ? null : cardShadow,
      ),
      child: Row(
        children: <Widget>[
          const _ShimmerBox(height: 44, width: 44, radius: Dimensions.radiusFull),
          const SizedBox(width: Dimensions.padding12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Row(
                  children: <Widget>[
                    _ShimmerBox(height: 14, width: 130),
                    Spacer(),
                    _ShimmerBox(height: 12, width: 60),
                  ],
                ),
                SizedBox(height: Dimensions.padding10),
                _ShimmerBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const _ShimmerBox({this.height = 12, this.width, this.radius = Dimensions.radius4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
