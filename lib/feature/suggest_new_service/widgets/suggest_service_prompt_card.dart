import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SuggestServicePromptCard extends StatelessWidget {
  final bool showButton;

  const SuggestServicePromptCard({super.key, this.showButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding24, horizontal: Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: Column(children: [
        Image.asset(Images.suggestServiceIcon, height: 64, width: 64),
        const SizedBox(height: Dimensions.padding16),
        Text('cant_find_your_service'.tr, style: context.heading.large, textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.padding8),
        Text('share_the_services_you_would_like_to_see'.tr, style: context.body.small, textAlign: TextAlign.center),

        if(showButton) ...[
          const SizedBox(height: Dimensions.padding20),
          CustomButton(
            width: Get.width * 0.5,
            buttonText: 'suggest_new_service'.tr,
            onPressed: () => Get.toNamed(RouteHelper.getSuggestServiceFormRoute()),
          ),
        ],
      ]),
    );
  }
}
