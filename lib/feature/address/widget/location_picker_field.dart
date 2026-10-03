import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class LocationPickerField extends StatelessWidget {
  const LocationPickerField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        final bool hasAddress = locationController.address.address?.isNotEmpty ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'location'.tr,
                    style: context.subHeading.defaultSize.medium,
                  ),
                  TextSpan(
                    text: ' *',
                    style: context.body.defaultSize.overrideWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.padding6),

            CustomInkWell(
              radius: Dimensions.radius8,
              onTap: () => Get.toNamed(RouteHelper.setLocation),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.padding16,
                  vertical: Dimensions.padding16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius8),
                  border: Border.all(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: Dimensions.fontSizeLarge,
                      color: context.customThemeColors.textColor,
                    ),
                    const SizedBox(width: Dimensions.padding10),
                    Expanded(
                      child: Text(
                        hasAddress
                            ? locationController.address.address!
                            : 'add_location'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: hasAddress
                            ? context.body.defaultSize.overrideWith(color: context.customThemeColors.textColor)
                            : context.body.defaultSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
