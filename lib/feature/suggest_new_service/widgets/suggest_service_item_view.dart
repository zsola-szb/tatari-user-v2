import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SuggestServiceItemView extends StatelessWidget {
  final SuggestedService suggestedService;

  const SuggestServiceItemView({super.key, required this.suggestedService});

  void _openDetails() => Get.bottomSheet(
    AdminFeedbackBottomSheet(suggestedService: suggestedService),
    isScrollControlled: true,
  );

  void _openEdit() => Get.toNamed(RouteHelper.getSuggestServiceFormRoute(editingService: suggestedService));

  void _confirmDelete() {
    Get.bottomSheet(
      ConfirmationBottomsheet(
        icon: Images.warning,
        description: 'are_you_sure_want_to_delete_this_service_request'.tr,
        onYesPressed: () {
          Get.back();
          Get.dialog(const CustomLoader(), barrierDismissible: false);
          Get.find<SuggestServiceController>().deleteServiceRequest(suggestedService.id!).then((response) {
            Get.back();
            customSnackBar(response.message!.tr, type: response.isSuccess == true ? ToasterMessageType.success : ToasterMessageType.error);
          });
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding12),
      child: CustomInkWell(
        radius: Dimensions.radius12,
        onTap: _openDetails,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius16),
          ),
          padding: const EdgeInsets.all(Dimensions.padding16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                  side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                ),
                surfaceTintColor: Theme.of(context).cardColor,
                position: PopupMenuPosition.under,
                elevation: 8,
                shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'view_details',
                    height: 35,
                    onTap: _openDetails,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.padding6),
                      Icon(Icons.remove_red_eye_outlined, size: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: Dimensions.padding10),
                      Text('view_details'.tr, style: context.subHeading.small),
                    ]),
                  ),
                  PopupMenuItem<String>(
                    value: 'edit',
                    height: 35,
                    onTap: _openEdit,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.padding6),
                      Icon(Icons.edit_outlined, size: Dimensions.fontSizeLarge, color: context.customThemeColors.info),
                      const SizedBox(width: Dimensions.padding10),
                      Text('edit'.tr, style: context.subHeading.small),
                    ]),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    height: 35,
                    onTap: _confirmDelete,
                    child: Row(children: [
                      const SizedBox(width: Dimensions.padding6),
                      Icon(Icons.delete_outline, size: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: Dimensions.padding10),
                      Text('delete'.tr, style: context.subHeading.small),
                    ]),
                  ),
                ],
                child: Icon(Icons.more_vert, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
              ),
            ]),

            if(suggestedService.serviceDescription != null && suggestedService.serviceDescription!.isNotEmpty) ...[
              const SizedBox(height: Dimensions.padding10),
              Text(suggestedService.serviceDescription!,
                style: context.body.small, maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
