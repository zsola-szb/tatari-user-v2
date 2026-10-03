import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ReviewRatingController extends GetxController {
  final ReviewRatingRepo submitReviewRepo ;
  ReviewRatingController({required this.submitReviewRepo});


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loading = false;
  bool get loading => _loading;

  List<Service>? _serviceReviewList;
  List<Service>? get serviceReviewList => _serviceReviewList;

  Map<String,Map<String, dynamic>> listOfReview = {};

  TextEditingController reviewController = TextEditingController();
  Map<String, TextEditingController> textControllers =  {};
  Map<String, int> selectedRating =  {};
  Map<String, bool> isEditable =  {};
  Map<String, String> reviewComments =  {};

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

   void selectReview(int rating,serviceId){
     selectedRating[serviceId] = rating;
    update();
  }

  void setIndex(int index){
    _selectedIndex= index;
    update();
  }

  Future<void> submitReview(ReviewBody reviewBody,String serviceId,String review, int index)async{
    _isLoading = true;
    update();
    Response response =await submitReviewRepo.submitReview(reviewBody: reviewBody);
    if(response.statusCode == 200){
      isEditable[serviceId] = false;
      reviewComments[serviceId]= review;
      customSnackBar('review_submitted_successfully'.tr,type : ToasterMessageType.success);
    }
    _isLoading = false;
    update();
  }


  Future<void> getReviewList(String bookingId)async{
    _loading = true;
    _serviceReviewList = null;
    textControllers.clear();
    selectedRating.clear();
    isEditable.clear();
    reviewComments.clear();

    Response response =await submitReviewRepo.getReviewList(bookingId: bookingId);
    if(response.statusCode == 200){

      if( response.body['content'] !=null && response.body['content'].isNotEmpty){
        List<dynamic> list = response.body['content'];
        _serviceReviewList = [];
        for (var element in list) {
          _serviceReviewList!.add(Service.fromJson(element));
        }
        for (final Service service in _serviceReviewList!) {
          final String? serviceId = service.id;
          if(serviceId == null){
            continue;
          }
          final Review? submittedReview = (service.review?.isNotEmpty ?? false) ? service.review!.first : null;

          selectedRating[serviceId] = submittedReview?.reviewRating ?? 5;
          isEditable[serviceId] = submittedReview == null;
          reviewComments[serviceId] = submittedReview?.reviewComment ?? "";
          textControllers[serviceId] = TextEditingController(text: submittedReview?.reviewComment ?? "");
        }
      }
    }
    _loading = false;
    update();
  }

  void updateEditableValue(String serviceId,bool value,{bool isUpdate= false}){
    isEditable[serviceId] = value;
    if(isUpdate){
      update();
    }
  }

  static const int customerReviewPageSize = 10;

  bool _isCustomerReviewLoading = true;
  bool get isCustomerReviewLoading => _isCustomerReviewLoading;

  final List<CustomerReview> _customerReviewList = <CustomerReview>[];
  List<CustomerReview> get customerReviewList => List<CustomerReview>.unmodifiable(_customerReviewList);

  Rating? _ratingSummary;
  Rating? get ratingSummary => _ratingSummary;

  int _customerReviewTotalSize = 0;
  int get customerReviewTotalSize => _customerReviewTotalSize;

  int _customerReviewOffset = 1;
  int get customerReviewOffset => _customerReviewOffset;

  Future<void> getCustomerReviews({required String id, required ReviewSource source, required int offset, bool shouldUpdate = true}) async {
    if(id.isEmpty){
      return;
    }

    final bool isPagination = offset > 1;
    if(!isPagination){
      _isCustomerReviewLoading = true;
      _customerReviewList.clear();
      _ratingSummary = null;
      _customerReviewTotalSize = 0;
      _customerReviewOffset = 1;
      if(shouldUpdate){
        update();
      }
    }

    final Response response = await submitReviewRepo.getCustomerReviews(
      id: id, source: source, offset: offset, limit: customerReviewPageSize,
    );
    if(response.statusCode == 200 && response.body is Map<String, dynamic>){
      final ReviewRatingModel reviewRating = ReviewRatingModel.fromJson(response.body);
      _customerReviewList.addAll(reviewRating.reviews);
      _ratingSummary = reviewRating.rating ?? _ratingSummary;
      _customerReviewTotalSize = reviewRating.totalSize ?? _customerReviewList.length;
      _customerReviewOffset = offset;
    }else{
      ApiChecker.checkApi(response);
    }

    _isCustomerReviewLoading = false;
    update();
  }
}