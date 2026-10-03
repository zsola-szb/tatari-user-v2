import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ReviewRatingScreen extends StatefulWidget {
  final String id;
  final ReviewSource source;
  const ReviewRatingScreen({super.key, required this.id, required this.source});

  @override
  State<ReviewRatingScreen> createState() => _ReviewRatingScreenState();
}

class _ReviewRatingScreenState extends State<ReviewRatingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<ReviewRatingController>().getCustomerReviews(id: widget.id, source: widget.source, offset: 1, shouldUpdate: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        appBar: CustomAppBar(title: 'review_and_rating'.tr),
        body: GetBuilder<ReviewRatingController>(
          builder: (submitReviewController) {
            if(widget.id.isEmpty){
              return NoDataScreen(text: 'no_data_found'.tr);
            }
            if(submitReviewController.isCustomerReviewLoading){
              return const Center(child: CircularProgressIndicator());
            }

            final List<CustomerReview> reviewList = submitReviewController.customerReviewList;

            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ServiceRatingSummaryView(rating: submitReviewController.ratingSummary),

                  Gaps.verticalGapOf(Dimensions.padding16),
                  Divider(height: 1, color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
                  Gaps.verticalGapOf(Dimensions.padding16),

                  if(reviewList.isEmpty)
                    const EmptyReviewWidget()
                  else ...[
                    Text("${'reviews'.tr} (${submitReviewController.customerReviewTotalSize})", style: context.heading.large),
                    Gaps.verticalGapOf(Dimensions.padding10),

                    PaginatedListView(
                      scrollController: _scrollController,
                      totalSize: submitReviewController.customerReviewTotalSize,
                      offset: submitReviewController.customerReviewOffset,
                      limit: ReviewRatingController.customerReviewPageSize,
                      onPaginate: (int offset) async => await submitReviewController.getCustomerReviews(
                        id: widget.id, source: widget.source, offset: offset,
                      ),
                      itemView: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviewList.length,
                        separatorBuilder: (_, _) => Divider(color: Theme.of(context).disabledColor.withValues(alpha: 0.15)),
                        itemBuilder: (context, index) => ReviewRatingTile(review: reviewList[index]),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
