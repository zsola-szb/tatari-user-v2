import 'package:tatarigigs_user/feature/cart/widget/cart_shimmer_view.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AllCartShimmerView extends StatelessWidget {
  const AllCartShimmerView({super.key});

  static const int _cardCount = 3;
  static const double _cardHeight = 168;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(
              children: <Widget>[
                for (int index = 0; index < _cardCount; index++) ...<Widget>[
                  if (index > 0) const SizedBox(height: Dimensions.padding16),
                  const CartShimmerBox(height: _cardHeight, radius: Dimensions.radius16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
