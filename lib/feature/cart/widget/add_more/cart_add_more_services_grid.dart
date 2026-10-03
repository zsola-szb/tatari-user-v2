import 'package:tatarigigs_user/util/core_export.dart';

class CartAddMoreServicesGrid extends StatelessWidget {
  final List<Service>? serviceList;

  const CartAddMoreServicesGrid({super.key, required this.serviceList});

  static const int _crossAxisCount = 2;
  static const int _shimmerItemCount = 6;

  @override
  Widget build(BuildContext context) {
    final List<Service>? services = serviceList;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double itemWidth = (constraints.maxWidth - (Dimensions.padding16 * (_crossAxisCount - 1))) / _crossAxisCount;

      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.padding16,
          mainAxisSpacing: Dimensions.padding16,
          mainAxisExtent: ServiceWidgetVertical.heightFor(context, itemWidth),
          crossAxisCount: _crossAxisCount,
        ),
        itemCount: services?.length ?? _shimmerItemCount,
        itemBuilder: (BuildContext context, int index) {
          if (services == null) {
            return const ServiceShimmer(isEnabled: true, hasDivider: false);
          }

          return ServiceWidgetVertical(service: services[index], fromType: '');
        },
      );
    });
  }
}