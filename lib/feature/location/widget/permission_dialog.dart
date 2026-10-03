import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius6)),
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding20),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            const SizedBox(height: Dimensions.padding20),
            Text(
              'you_denied_location_permission'.tr,
              textAlign: TextAlign.center,
              style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
            ),
            const SizedBox(height: Dimensions.padding20),
            Row(children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'close'.tr,
                  height: 50,
                  radius: Dimensions.radius12,
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.2),
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(width: Dimensions.padding10),
              Expanded(child: CustomButton(buttonText: 'settings'.tr, height: 50, radius: Dimensions.radius12, onPressed: () async {
                await Geolocator.openAppSettings();
                Navigator.pop(Get.context!);
              })),
            ]),
          ]),
        ),
      ),
    );
  }
}
