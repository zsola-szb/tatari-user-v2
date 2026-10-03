import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AreaTopWidget extends StatelessWidget {
  const AreaTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: Dimensions.padding20),

        Image.asset(Images.areaTopIcon, height: 100, width: 100),
        const SizedBox(height: Dimensions.padding16),

        Text("we_are_available_in_these_areas".tr, style: context.heading.large, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.padding6),

        Text("get_you_desired_service".tr, style: context.body.small, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.padding32),
        ],
      ),
    );
  }
}
