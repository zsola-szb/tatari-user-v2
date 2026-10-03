import 'package:tatarigigs_user/util/core_export.dart';

class HomeSectionSliver extends StatelessWidget {
  final String name;
  final Widget child;

  const HomeSectionSliver({super.key, required this.name, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: child,
        ),
      ),
    );
  }
}
