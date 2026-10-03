import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceNotAvailableScreen extends StatelessWidget {
  final String fromPage;
  const ServiceNotAvailableScreen({super.key, this.fromPage = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.notAvailableIcon, width:  90.0, height: 90.0, color: Colors.grey ),
          const SizedBox(height: Dimensions.padding20),

          Text(fromPage == "search_page"? "there_are_no_services_related_to_your_search".tr : "services_are_not_available".tr,
            style: context.subHeading.extraLarge.overrideWith(fontWeight: AppWeight.medium),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.padding20),

          fromPage != "search_page"?
          Text("please_select_among".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).hintColor), textAlign: TextAlign.center)
          : const SizedBox(),

          const SizedBox(height: Dimensions.padding20),

          fromPage != "search_page"?
          InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.getServiceArea());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding6),
              child: Text("view_available_areas".tr, style: context.subHeading.extraLarge.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary)),
            ),
          ) : const SizedBox(),

        ]
      ),
    );
  }
}
