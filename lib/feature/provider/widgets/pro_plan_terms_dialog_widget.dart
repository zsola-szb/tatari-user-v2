import 'package:tatarigigs_user/feature/subscription/controller/subscription_controller.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ProPlanTermsDialogWidget extends StatelessWidget {
  final ScrollController? scrollController;
  final bool isBottomSheet;

  const ProPlanTermsDialogWidget({
    super.key,
    this.scrollController,
    required this.isBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    final Widget dragHandle = Center(
      child: Container(
        margin: const EdgeInsets.only(top: Dimensions.padding10),
        height: 5,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
        ),
      ),
    );

    final Widget titleRow = Stack(children: [
      Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Dimensions.padding10,
            left: Dimensions.padding24,
            right: Dimensions.padding24,
          ),
          child: Text(
            'terms_and_conditions'.tr,
            style: context.heading.large.overrideWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).hintColor.withValues(alpha: 0.1),
            ),
            padding: const EdgeInsets.all(Dimensions.padding6),
            child: Icon(
              Icons.close,
              size: 16,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    ]);

    final Widget htmlView = SingleChildScrollView(
      controller: isBottomSheet ? scrollController : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
          boxShadow: Get.isDarkMode ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: Get.find<SubscriptionController>().tramsAndCondition?.content?.content == null ? Text('no_data_found'.tr) :  Html(
          data: Get.find<SubscriptionController>().tramsAndCondition?.content?.content ?? 'no_data_found'.tr,
          style: {
            "p": Style(
              fontSize: FontSize.medium,
            ),
          },
        ),
      ),
    );

    final Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isBottomSheet) dragHandle,
        titleRow,
        const SizedBox(height: Dimensions.padding20),
        Flexible(child: htmlView),
        const SizedBox(height: Dimensions.padding10),
      ],
    );

    if (isBottomSheet) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radius20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          Dimensions.padding16,
          0,
          Dimensions.padding16,
          Dimensions.padding16,
        ),
        child: body,
      );
    } else {
      return body;
    }
  }
}
