import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ReviewRecommendationDialog extends StatefulWidget {

  final String id;

  const ReviewRecommendationDialog({
    super.key,
    required this.id,
  }) ;

  @override
  State<ReviewRecommendationDialog> createState() => _ReviewRecommendationDialogState();
}

class _ReviewRecommendationDialogState extends State<ReviewRecommendationDialog> {
  @override
  Widget build(BuildContext context) {

    return pointerInterceptor();
  }
  Padding pointerInterceptor(){
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Container(
            width: Dimensions.webMaxWidth,
            padding: const EdgeInsets.only(left: Dimensions.padding16, bottom: Dimensions.padding16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: Dimensions.padding16,
                                right: Dimensions.padding16),
                            child: Icon(Icons.close,color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6),),
                          )),
                    ),
                    Text(
                      'how_was_your_last_service'.tr,
                      style: context.heading.large.overrideWith(
                          color: Get.isDarkMode ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: Dimensions.padding10),

                    Text(
                      'leave_a_review'.tr,
                      style: context.heading.large.overrideWith(
                          color: Get.isDarkMode ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: Dimensions.padding20,),
                    Image.asset(
                      Images.emptyReview,
                      scale:Dimensions.padding10,
                      color:Get.isDarkMode ?  Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,),
                    const SizedBox(height: 30.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                            height: 40,
                            width: 150,
                            child: TextButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).hoverColor)),
                                onPressed: () => Get.back(),
                                child: Center(
                                  child: Text(
                                    'skip'.tr,
                                    style: context.subHeading.small.overrideWith(
                                      fontWeight: AppWeight.medium,
                                      color: Get.isDarkMode ? Colors.white:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6),
                                    ),),
                                )
                            )
                        ),

                        CustomButton(
                          height: 40,
                          width: 150,
                          fontSize: Dimensions.fontSizeSmall,
                          buttonText: 'give_review'.tr,
                          onPressed: () {
                            Get.back();
                            Get.toNamed(RouteHelper.getRateReviewScreen(
                                widget.id
                            ));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.padding24,)
                  ]),
            )),
    );
  }
}
