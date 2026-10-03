import 'package:tatarigigs_user/common/widgets/ldashed_line_printer.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ServiceReviewItem extends StatelessWidget {
  final Review review;
  final bool isProviderReview;
  final int index;
  const ServiceReviewItem({super.key, required this.review, required this.isProviderReview, required this.index}) ;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.padding24)),
            child: CustomImage(
              image: review.customer?.profileImageFullPath ??"",
              height: 40, width: 40,
              placeholder: Images.userPlaceHolder,
            ),
          ),
          const SizedBox(width: Dimensions.padding10,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text( review.customer == null ? "customer_not_available".tr : "${review.customer?.firstName ?? ""} ${review.customer?.lastName ?? ""}",
                    style: context.subHeading.defaultSize,
                  ),
                ),

                const SizedBox(height: Dimensions.padding6,),

                Row( children: [
                  RatingBar(rating: review.reviewRating!.toDouble(), color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: Dimensions.padding6,),
                  Text(review.reviewRating!.toStringAsFixed(1),
                    style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).hintColor),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding10,),

          Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.updatedAt!)),
            style: context.body.small.copyWith(fontSize: Dimensions.fontSizeSmall + 1),
            textDirection: TextDirection.ltr,
          ),

        ],
      ),

      Padding(padding: const EdgeInsets.only(bottom: Dimensions.padding8, top: Dimensions.padding16),
        child: ReadMoreText(
          review.reviewComment?.capitalizeFirst ?? "",
          trimCollapsedText : "see_more".tr,
          trimExpandedText: "  ${"see_less".tr}",
          trimMode: TrimMode.Line,
          trimLines: 3,
          style: context.body.small.copyWith(height: 1.5),
          textAlign: TextAlign.justify,
          moreStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Colors.blueAccent),
          lessStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Colors.blueAccent),
        ),
      ),

      (review.reviewReply !=null && review.isExpended == 1) ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: Dimensions.padding6,),
        CustomPaint(
          size: const Size(15, 50), // Adjust size as needed
          painter: LDashedLinePainter(),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), width: 0.5),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            ),
            padding: const EdgeInsets.all(Dimensions.padding16),
            margin: const EdgeInsets.only(top: Dimensions.padding10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: Row(children: [
                      Image.asset(Images.reviewReply, width: 25,),
                      const SizedBox(width: Dimensions.padding8,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("replied_by_provider".tr, style: context.subHeading.defaultSize, overflow: TextOverflow.ellipsis,),
                            review.provider != null ? TextButton(
                              onPressed: (){
                                Get.toNamed(RouteHelper.getProviderDetails(review.provider!.id!));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(60,20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    
                              ),
                              child: Text(review.provider?.name ?? "", style: context.subHeading.small.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ) : const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding6,),
                      const SizedBox()

                    ]),
                  ),
                  Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.reviewReply!.updatedAt!)),
                    style: context.body.small.copyWith(fontSize: Dimensions.fontSizeSmall + 1),
                    textDirection: TextDirection.ltr,
                  ),
                ]),
                const SizedBox(height: Dimensions.padding6,),
                ReadMoreText(
                  review.reviewReply?.reply?.capitalizeFirst ?? "",
                  trimCollapsedText : "see_more".tr,
                  trimExpandedText: "  ${"see_less".tr}",
                  trimMode: TrimMode.Line,
                  trimLines: 3,
                  style: context.body.small.copyWith(height: 1.5),
                  textAlign: TextAlign.justify,
                  moreStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),
                  lessStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        )
      ]) : (review.reviewReply != null && review.isExpended == 0) ?
      InkWell(
        onTap: (){
          if(isProviderReview){
            Get.find<ProviderBookingController>().updateProviderReviewExpendedStatus(index: index);
          }else{
            Get.find<ServiceTabController>().updateProviderReviewExpendedStatus(index: index);
          }
        },
        child: Text(
          "view_reply".tr, style: context.subHeading.defaultSize.copyWith(
            fontWeight: AppWeight.medium,
            color: Colors.blueAccent,
            fontSize: Dimensions.fontSizeDefault - 1,
          ),
        ),
      ) : const SizedBox(),
      const SizedBox(height: Dimensions.padding24,),
    ]);
  }
}
