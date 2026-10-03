import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class DemoResetDialogWidget extends StatefulWidget {
  const DemoResetDialogWidget({super.key});

  @override
  State<DemoResetDialogWidget> createState() => _DemoResetDialogWidgetState();
}

class _DemoResetDialogWidgetState extends State<DemoResetDialogWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius20)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          color: Theme.of(context).cardColor,
        ),
        width: 500,
        padding: const EdgeInsets.all(Dimensions.padding20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Theme.of(context).primaryColor, size: 55),
          const SizedBox(height: Dimensions.padding20),

          Text('session_time_out'.tr, style: context.heading.extraLarge),
          const SizedBox(height: Dimensions.padding20),

          Text(
            'though_it_is_demo_text'.tr,
            textAlign: TextAlign.center,
            style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),
          ),
          const SizedBox(height: 35),

          CustomButton(isLoading: _isLoading, buttonText: 'okay'.tr, onPressed: () {
            setState(() {
              _isLoading = true;
            });
            Get.find<SplashController>().getConfigData().then((isSuccess) {
              if(isSuccess) {
                setState(() {
                  _isLoading = false;
                });
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }
            });
          }),
        ]),
      ),
    );
  }
}
