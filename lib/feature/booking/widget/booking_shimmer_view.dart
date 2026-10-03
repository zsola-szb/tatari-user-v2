import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BookingShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const BookingShimmerBox({
    super.key,
    this.height = 12,
    this.width,
    this.radius = Dimensions.radius4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class BookingListShimmerView extends StatelessWidget {
  const BookingListShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: ListView.separated(
        padding: const EdgeInsets.all(Dimensions.padding16),
        itemCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: Dimensions.padding20),
        itemBuilder: (BuildContext context, int index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            BookingShimmerBox(height: 16, width: 170),
            SizedBox(height: Dimensions.padding10),
            BookingShimmerBox(height: 12, width: 120),
            SizedBox(height: Dimensions.padding12),
            Row(
              children: <Widget>[
                BookingShimmerBox(height: 32, width: 90),
                Spacer(),
                BookingShimmerBox(height: 32, width: 90, radius: Dimensions.radius8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsShimmerView extends StatelessWidget {
  const BookingDetailsShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Column(
          children: <Widget>[
            const _ShimmerCard(lines: <double>[140, 220, 200, 110]),
            const SizedBox(height: Dimensions.padding12),
            const _ShimmerCard(lines: <double>[160, 240]),
            const SizedBox(height: Dimensions.padding12),
            const _ShimmerCard(lines: <double>[130, 200, 180]),
            const SizedBox(height: Dimensions.padding12),
            const _ShimmerCard(lines: <double>[150, 210, 190, 160]),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final List<double> lines;

  const _ShimmerCard({required this.lines});

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(lines.length * 2 - 1, (int index) {
          if (index.isOdd) {
            return const SizedBox(height: Dimensions.padding10);
          }
          return BookingShimmerBox(height: index == 0 ? 16 : 12, width: lines[index ~/ 2]);
        }),
      ),
    );
  }
}
