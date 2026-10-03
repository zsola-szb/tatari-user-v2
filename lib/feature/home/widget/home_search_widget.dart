import 'package:tatarigigs_user/common/widgets/home_search_field.dart';
import 'package:tatarigigs_user/util/core_export.dart';

// Kept intact for the pre-redesign home_screen.dart, which still places this
// as a pinned sliver. HomeScreenNew instead uses HomeSearchField directly,
// integrated into AddressAppBar — see home_search_field.dart for the shared
// visual + tap-to-search logic both of these build on.
class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return  SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(extentSize: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: Dimensions.padding16, right: Dimensions.padding16, top: Dimensions.padding6,),
          child: HomeSearchField(),
        ),
      ),
    );
  }
}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget? child;
  double? extentSize;
  SliverDelegate({required this.child,required this.extentSize});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child!;
  }
  @override
  double get maxExtent => extentSize!;
  @override
  double get minExtent => extentSize!;
  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != maxExtent || child != oldDelegate.child;
  }
}