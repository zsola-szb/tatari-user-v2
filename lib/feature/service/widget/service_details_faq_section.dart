import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceDetailsFaqSection extends StatelessWidget {
  const ServiceDetailsFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceDetailsController>(
      builder: (serviceDetailsController) {
        final List<Faqs> faqs = serviceDetailsController.service?.faqs ?? [];

        if(faqs.isEmpty){
          return const SizedBox.shrink();
        }

        return ServiceExpandableCard(
          title: 'faqs'.tr,
          children: [
            for (int index = 0; index < faqs.length; index++) ...[
              if (index > 0) Divider(height: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
              ServiceFaqItem(faq: faqs[index], initiallyExpanded: index == 0),
            ],
          ],
        );
      },
    );
  }
}