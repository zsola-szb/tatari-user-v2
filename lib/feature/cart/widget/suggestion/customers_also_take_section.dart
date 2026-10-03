import 'package:tatarigigs_user/feature/cart/widget/common/cart_section_card.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CustomersAlsoTakeSection extends StatelessWidget {
  const CustomersAlsoTakeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (CartController controller) {
        final List<Service> services = controller.suggestedServices ?? const <Service>[];
        if (services.isEmpty) {
          return const SizedBox.shrink();
        }

        return _SuggestedServicesCard(services: services);
      },
    );
  }
}

class _SuggestedServicesCard extends StatelessWidget {
  final List<Service> services;

  const _SuggestedServicesCard({required this.services});

  @override
  Widget build(BuildContext context) {
    final double itemWidth = ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.3;

    return CartSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('customers_also_take'.tr, style: context.heading.large),
          const SizedBox(height: Dimensions.padding12),

          SizedBox(
            height: ServiceWidgetVertical.heightFor(context, itemWidth) + (Dimensions.padding6 * 2),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
              itemCount: services.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: Dimensions.padding12),
              itemBuilder: (BuildContext context, int index) => SizedBox(
                width: itemWidth,
                child: ServiceWidgetVertical(service: services[index], fromType: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
