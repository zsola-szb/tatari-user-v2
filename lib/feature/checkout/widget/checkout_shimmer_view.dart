import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_shimmer_box.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutShimmerView extends StatelessWidget {
  final bool showBookingTypeTabs;

  const CheckoutShimmerView({super.key, this.showBookingTypeTabs = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Shimmer(
            duration: const Duration(seconds: 2),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Column(
                children: <Widget>[
                  if (showBookingTypeTabs) ...<Widget>[
                    const CheckoutShimmerBox(
                      height: 44,
                      radius: Dimensions.radius12,
                    ),
                    const SizedBox(height: Dimensions.padding16),
                  ],
                  const CheckoutShimmerCard(height: 90),
                  const SizedBox(height: Dimensions.padding16),
                  const CheckoutShimmerCard(height: 150),
                  const SizedBox(height: Dimensions.padding16),
                  const CheckoutShimmerCard(height: 110),
                  const SizedBox(height: Dimensions.padding16),
                  const CheckoutShimmerCard(height: 70),
                  const SizedBox(height: Dimensions.padding16),
                  const _ShimmerBillingBlock(),
                ],
              ),
            ),
          ),
        ),
        const _ShimmerBottomBar(),
      ],
    );
  }
}

class _ShimmerBillingBlock extends StatelessWidget {
  const _ShimmerBillingBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const CheckoutShimmerBox(height: 16, width: 130),
        const SizedBox(height: Dimensions.padding16),
        ...List<Widget>.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: Dimensions.padding10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CheckoutShimmerBox(height: 14, width: 110),
                CheckoutShimmerBox(height: 14, width: 70),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerBottomBar extends StatelessWidget {
  const _ShimmerBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding10,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding10,
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CheckoutShimmerBox(height: 14, width: 120),
              CheckoutShimmerBox(height: 14, width: 80),
            ],
          ),
          SizedBox(height: Dimensions.padding10),
          CheckoutShimmerBox(height: 50, radius: Dimensions.radius12),
        ],
      ),
    );
  }
}
