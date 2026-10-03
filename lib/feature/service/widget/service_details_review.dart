import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/styles.dart' as context;
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class ServiceDetailsReview extends StatelessWidget {

  final String serviceID;

  const ServiceDetailsReview({super.key,required this.serviceID}) ;

  static const int _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ReviewRatingController>(builder: (reviewRatingController){
      final List<CustomerReview> reviewList = reviewRatingController.customerReviewList;
      if(reviewList.isEmpty){
        return const SizedBox.shrink();
      }

      final int totalSize = reviewRatingController.customerReviewTotalSize;
      final bool hasMoreThanPreview = totalSize > _previewCount || reviewList.length > _previewCount;
      final int previewLength = reviewList.length < _previewCount ? reviewList.length : _previewCount;

      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ServiceRatingSummaryView(rating: reviewRatingController.ratingSummary),

        Gaps.verticalGapOf(Dimensions.padding16),
        Divider(height: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
        Gaps.verticalGapOf(Dimensions.padding16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${'reviews'.tr} ($totalSize)", style: context.heading.large.strong),
            if(hasMoreThanPreview)
              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getReviewRatingScreen(serviceID, ReviewSource.service)),
                child: Text('view_all'.tr,
                    style: context.subHeading.small.medium.overrideWith(color: Theme.of(context).primaryColor)),
              ),
          ],
        ),
        Gaps.verticalGapOf(Dimensions.padding10),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: previewLength,
          separatorBuilder: (_, _) => Divider(color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
          itemBuilder: (context, index) => ReviewRatingTile(review: reviewList[index]),
        ),
      ]);
    });
  }

}


class ProgressCardWidget extends StatelessWidget {
  final Rating rating;

  const ProgressCardWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {

    double fiveStar = 0.0, fourStar = 0.0, threeStar = 0.0,twoStar = 0.0, oneStar = 0.0;
    int totalFiveStar = 0, totalFourStar = 0, totalThreeStar = 0, totalTwoStar = 0, totalOneStar = 0;

    for(int i =0 ; i< rating.ratingGroupCount!.length; i++){
      if(rating.ratingGroupCount![i].reviewRating == 1){
        oneStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
        totalOneStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if(rating.ratingGroupCount![i].reviewRating == 2){
        twoStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
        totalTwoStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if(rating.ratingGroupCount![i].reviewRating == 3){
        threeStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
        totalThreeStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if(rating.ratingGroupCount![i].reviewRating == 4){
        fourStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
        totalFourStar = rating.ratingGroupCount![i].total ?? 0;
      }
      if(rating.ratingGroupCount![i].reviewRating == 5){
        fiveStar = (rating.ratingGroupCount![i].reviewRating! * rating.ratingCount!) / 100;
        totalFiveStar = rating.ratingGroupCount![i].total ?? 0;
      }
    }

    return Column(children: [
      _progressBar(
        title: 'excellent'.tr,
        percent: fiveStar,
        total: totalFiveStar,
      ),
      _progressBar(
        title: 'good'.tr,
        percent: fourStar,
        total: totalFourStar,
      ),
      _progressBar(
        title: 'average'.tr,
        percent: threeStar,
        total: totalThreeStar,
      ),
      _progressBar(
        title: 'below_average'.tr,
        percent: twoStar,
        total: totalTwoStar,
      ),
      _progressBar(
        title: 'poor'.tr,
        percent: oneStar,
        total: totalOneStar
      ),
    ],);
  }
  Widget _progressBar({required String title, required double percent, required int total}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(title.tr ,
              style: Get.context!.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(Get.context!).textTheme.bodySmall?.color?.withValues(alpha: 0.7)),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(Get.context!).colorScheme.primary
                ),
                backgroundColor: const Color(0xFFEAEAEA),
              ),
            ),
          ),

          const SizedBox(width: Dimensions.padding10,),

          SizedBox(
            width: 25, height: 15,
            child: FittedBox(child: Text("$total", style: Get.context!.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),)),
          )
        ],
      ),
    );
  }
}

class ReviewCardWidget extends StatelessWidget {
  final Rating rating;
  final bool transparent;
  const ReviewCardWidget({super.key, required this.rating,   this.transparent = false});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding10),
      decoration: transparent ? null : BoxDecoration(
        color: context.customThemeColors.secondaryBackGroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      child: Column(
        children: [
          if(!transparent) Align(alignment: Alignment.centerLeft, child: Text("reviews".tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)))),
          if(!transparent) const Divider(),
          Text(rating.averageRating?.toStringAsFixed(2) ?? "0.0", style: context.heading.small.copyWith(color:Theme.of(context).colorScheme.secondary, fontSize: 36)),
          const SizedBox(height: Dimensions.padding3),

          RatingBar(rating: double.tryParse('${rating.averageRating}',), color: Theme.of(context).colorScheme.secondary, size: 20,),
          const SizedBox(height: Dimensions.padding6),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${rating.ratingCount ?? ""} ${'ratings'.tr}",
              style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .5)),

            ),
            const SizedBox(width: Dimensions.padding10),

            Text(
              "${rating.reviewCount ?? ""} ${'reviews'.tr}",
              style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .5)),
            ),
          ]),
        ],
      ),
    );
  }
}

