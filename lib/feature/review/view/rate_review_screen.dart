import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/common/widgets/ldashed_line_printer.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/feature/review/widgets/select_rating.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class RateReviewScreen extends StatefulWidget{
  final String? id;
  const RateReviewScreen({super.key, this.id}) ;

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}
class _RateReviewScreenState extends State<RateReviewScreen> {

  Future<void> _loadData() async {
   if(widget.id !=null){
     Get.find<BookingDetailsController>().loadBooking(bookingId: widget.id!);
     await Get.find<ReviewRatingController>().getReviewList(widget.id!);
   }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        drawer: null,

        endDrawer: null,
        appBar: CustomAppBar(title: 'review'.tr,),
        body: GetBuilder<BookingDetailsController>(builder: (bookingController){
          final BookingDetailModel? booking = bookingController.booking;
          if(widget.id == null){
            return const NoDataScreen(text: "no_data_found", type: NoDataType.bookings,);
          } else if(booking != null){
           return GetBuilder<ReviewRatingController>(builder: (submitReviewController){
             if(submitReviewController.loading){
               return const Center(child: CircularProgressIndicator(),);
             }else{
               final List<Service> serviceReviews = submitReviewController.serviceReviewList ?? <Service>[];
               if(serviceReviews.isEmpty){
                 return const NoDataScreen(text: "no_data_found", type: NoDataType.bookings,);
               }
               return FooterBaseView(
                 child: SizedBox(
                   width: Dimensions.webMaxWidth,
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         Stack(children: [
                           Container(
                             height: 120.0,
                             width: Get.width,
                             decoration: BoxDecoration(
                                 image: DecorationImage(fit: BoxFit.fill, image: AssetImage(Images.reviewTopBanner))
                             ),),
                           SizedBox(
                             height: 120.0,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: const [
                                 SizedBox(),
                               ],
                             ),
                           )
                         ],),

                         const SizedBox(height: Dimensions.padding20,),
                         ReviewBookingDetailsCard(booking: booking),

                         ListView.builder(itemBuilder: (context,index) {
                           final Service serviceReview = serviceReviews[index];

                           List<String> variationList=[];
                           for (final BookingServiceItemModel service in booking.services) {
                             if(serviceReview.id == service.serviceId){
                               variationList.addAll(service.variations.map((BookingServiceVariation variation) => variation.variantKey));
                             }
                           }
                           final String variations = variationList.join(', ');

                           return Padding(
                             padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                             child: (submitReviewController.isEditable[serviceReview.id] ?? true)
                                 ? EditableReview(serviceReview: serviceReview, index: index, variations: variations, bookingId: widget.id,)
                                 : NonEditableReview(serviceReview: serviceReview, index: index, variations: variations),
                           );
                         },
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           itemCount: serviceReviews.length,
                         ),
      
                         const SizedBox(height: Dimensions.padding24,)
      
                       ],
                     ),
                   ),
                 ),
               );
             }
           }
           );
         }else{
           return const Center(child: CircularProgressIndicator(),);
         }
        }
        ),
      ),
    );
  }
}

class ReviewBookingDetailsCard extends StatelessWidget {
  const ReviewBookingDetailsCard({
    super.key,
    required this.booking,
  }) ;
  final BookingDetailModel booking;
  @override
  Widget build(BuildContext context) {
    final DateTime? placedAt = booking.placedAt;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding10,vertical: Dimensions.padding10),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16,vertical: Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${'booking_no'.tr} # ${booking.readableId}",
                style: context.heading.large.overrideWith(
                    color: Theme.of(context).colorScheme.primary),),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                    PriceConverter.convertPrice(booking.billing.grandTotal),
                    style: context.heading.large.overrideWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color
                    )
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding6,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  placedAt == null ? '-' : DateConverter.formatDate(placedAt),
                  style: context.body.defaultSize,
              ),
              Text(booking.rawStatus.tr, style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Colors.green),),
            ],
          ),
          const SizedBox(height: Dimensions.padding6,)
        ],

      ),
    );
  }
}

class EditableReview extends StatefulWidget {
 final Service serviceReview;
 final int index;
 final String variations;
 final String? bookingId;
  const EditableReview({super.key, required this.serviceReview, required this.index, required this.variations, this.bookingId}) ;

  @override
  State<EditableReview> createState() => _EditableReviewState();
}

class _EditableReviewState extends State<EditableReview> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<ReviewRatingController>(builder: (submitReviewController){
      final String serviceId = widget.serviceReview.id ?? "";
      final TextEditingController? reviewTextController = submitReviewController.textControllers[serviceId];

      return Column(
        children: [
          const SizedBox(height: Dimensions.padding16,),
          Text( widget.serviceReview.name ?? "",
            style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
          ),
          const SizedBox(height: Dimensions.padding6,),
          Text(
            widget.variations,
            style: context.body.small,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SelectRating(revivedId: serviceId,),
              const SizedBox()
            ],
          ),
          const SizedBox(height: Dimensions.padding10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Theme.of(context).hoverColor),
            child: Center(
              child: TextFormField(maxLines: 4,
                controller: reviewTextController,
                decoration: InputDecoration(
                  hintText: 'write_your_review'.tr,
                  border: InputBorder.none,
                  hintStyle: context.subHeading.defaultSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.padding16,),
          CustomButton(
            height: 40,
            width: ResponsiveHelper.isTab(context)?150:120,
            radius: Dimensions.radius8,
            isLoading: submitReviewController.selectedIndex== widget.index && submitReviewController.isLoading,
            buttonText: 'submit'.tr,
            onPressed: (){
              String review =  reviewTextController?.text ?? "";
              if(isRedundentClick(DateTime.now())){
                return;
              }
              submitReviewController.setIndex(widget.index);
              ReviewBody  reviewBody = ReviewBody(
                bookingID: widget.bookingId ?? "",
                serviceID: serviceId,
                rating: (submitReviewController.selectedRating[serviceId] ?? 5).toString(),
                comment: review,
              );
              submitReviewController.submitReview(reviewBody, serviceId, review, widget.index );

            },
          )
        ],
      );
    });
  }
}


class NonEditableReview extends StatelessWidget {
  final Service serviceReview;
  final int index;
  final String variations;
  const NonEditableReview({super.key, required this.serviceReview, required this.index, required this.variations}) ;

  @override
  Widget build(BuildContext context) {

    final ReviewReply? reply = (serviceReview.review?.isNotEmpty ?? false) ? serviceReview.review!.first.reviewReply : null;
    final String? reviewReply = reply?.reply;
    final String updatedAt = reply?.updatedAt ?? "";

    return  GetBuilder<ReviewRatingController>(builder: (submitReviewController){
      final String serviceId = serviceReview.id ?? "";
      final String reviewComment = submitReviewController.reviewComments[serviceId] ?? "";

      return Stack(
          children:[
            Column(
              children: [
                const SizedBox(height: Dimensions.padding16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text( serviceReview.name ?? "",
                        style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: Dimensions.padding10,),

                    Image.asset(Images.accepted,width: 15,),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: Dimensions.padding6,),
                Text(
                  variations,
                  style: context.body.small,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    SelectRating(revivedId: serviceId, clickable: false,),
                    const SizedBox()
                  ],
                ),
                const SizedBox(height: Dimensions.padding10,),
                reviewComment.isNotEmpty ? Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16,vertical: Dimensions.padding16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadMoreText(
                        reviewComment,
                        trimCollapsedText : "see_more".tr,
                        trimExpandedText: "  ${"see_less".tr}",
                        trimMode: TrimMode.Line,
                        trimLines: 3,
                        style: context.body.small.copyWith(height: 1.5),
                        textAlign: TextAlign.justify,
                        moreStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),
                        lessStyle: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium, color: Theme.of(context).colorScheme.primary),
                      ),
                      if(reviewReply != null) Padding(
                        padding: const EdgeInsets.only(top: Dimensions.padding8),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(width: Dimensions.padding8,),
                          CustomPaint(
                            size: const Size(20, 50), // Adjust size as needed
                            painter: LDashedLinePainter(),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).cardColor,
                              ),
                              padding: const EdgeInsets.all(Dimensions.padding16),
                              margin: const EdgeInsets.only(top: Dimensions.padding10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Image.asset(Images.reviewReply, width: 25,),
                                        const SizedBox(width: Dimensions.padding10,),
                                        Text("replied_by_provider".tr, style: context.subHeading.defaultSize,),
                                      ]),

                                      Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(updatedAt)),
                                        style: context.body.small.copyWith(fontSize: Dimensions.fontSizeSmall + 1),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.padding6,),
                                  ReadMoreText(
                                    reviewReply,
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
                        ],),
                      ),
                    ],
                  ),
                ) : const SizedBox(),
                const SizedBox(height: 40),
              ],
            ),
            PositionedDirectional(
              end: 0,
              child: CustomInkWell(
                radius: Dimensions.radius8,
                onTap: () => submitReviewController.updateEditableValue(serviceId, true, isUpdate: true),
                child: Container(height: 30, width: 30, alignment: Alignment.center,
                  decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(Dimensions.radius8)),
                  child: SvgPicture.asset(Images.editIcon, height: 15, width: 15),
                ),
              ),
            ),
          ]
      );
    });
  }
}

