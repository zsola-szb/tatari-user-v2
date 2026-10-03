import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AdminFeedbackBottomSheet extends StatelessWidget {
  final SuggestedService suggestedService;

  const AdminFeedbackBottomSheet({super.key, required this.suggestedService});

  Color _statusColor(BuildContext context) {
    switch (suggestedService.status) {
      case 'approved': return context.customThemeColors.success;
      case 'denied': return context.customThemeColors.error;
      default: return context.customThemeColors.info;
    }
  }

  String _statusLabel() {
    switch (suggestedService.status) {
      case 'approved': return 'approved'.tr;
      case 'denied': return 'denied'.tr;
      default: return 'pending'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFeedback = suggestedService.adminFeedback != null && suggestedService.adminFeedback != "";
    final Color statusColor = _statusColor(context);

    return BaseBottomSheet(
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('suggested_service_details'.tr, style: context.heading.large),
            const SizedBox(height: Dimensions.padding20),

            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radius8),
                child: CustomImage(
                  image: suggestedService.category?.logo ?? "",
                  height: 40, width: 40, fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(suggestedService.serviceName ?? "",
                    style: context.heading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  if(suggestedService.category?.name != null) ...[
                    const SizedBox(height: Dimensions.padding4),
                    Text(suggestedService.category!.name!,
                      style: context.body.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ]),
              ),
            ]),
            const SizedBox(height: Dimensions.padding20),

            Text('description'.tr, style: context.heading.defaultSize),
            const SizedBox(height: Dimensions.padding8),
            Text(suggestedService.serviceDescription ?? "", style: context.body.small),
            const SizedBox(height: Dimensions.padding20),

            Container(
              width: Get.width,
              padding: const EdgeInsets.all(Dimensions.padding16),
              decoration: BoxDecoration(
                color: context.customThemeColors.secondaryBackGroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('feedback_by_admin'.tr, style: context.heading.defaultSize),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.padding10),
                    ),
                    child: Text(_statusLabel(), style: context.subHeading.small.overrideWith(color: statusColor)),
                  ),
                ]),

                if(hasFeedback)...[
                  const SizedBox(height: Dimensions.padding10),

                  Text(
                    suggestedService.adminFeedback ?? '',
                    style: context.body.small, textAlign: TextAlign.justify,
                  ),
                ],
              ]),
            ),
            const SizedBox(height: Dimensions.padding16)
          ]),
        ),
      ),
    );
  }
}
