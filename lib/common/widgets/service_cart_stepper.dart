import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceCartStepper extends StatelessWidget {
  final Service service;
  final ProviderData? providerData;
  final double size;

  const ServiceCartStepper({super.key, required this.service, this.providerData, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      final bool isLoading = cartController.isCartUpdatingForService(service.id ?? '');

      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
        ),
        child: AutoCollapsingQuantityStepper(
          key: ValueKey<String>(service.id ?? ''),
          size: size,
          quantity: ServiceCartHelper.quantityOf(service),
          isLoading: isLoading,
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
          onIncrement: () => ServiceCartHelper.increment(context, service, providerData: providerData),
          onDecrement: () => ServiceCartHelper.decrement(context, service, providerData: providerData),
        ),
      );
    });
  }
}
