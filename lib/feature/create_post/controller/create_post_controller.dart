import 'dart:convert';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class CreatePostController extends GetxController implements GetxService{

  final CreatePostRepo createPostRepo;
  CreatePostController({required this.createPostRepo});

  bool _isLoading= false;
  bool get isLoading => _isLoading;


  String selectedCategoryName= "";
  String selectedCategoryId= "";
  String selectedSubCategoryName= "";
  String selectedSubCategoryId= "";



  int _offset = 1;
  int get offset => _offset;

  Service? selectedService;

  List<String> additionalInstruction = [];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController additionalInstructionController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();
  bool get hasServiceSelection => BusinessModelHelper.isOpenMarket
      ? serviceNameController.text.trim().isNotEmpty : selectedService != null;

  PostModel? postModel;
  List<List<MyPostData>>? listOfMyPost= [];
  List allPostList=[];
  List<String> dateList = [];

  static const List<String?> _postTabStatuses = ['all', 'pending', 'accepted', 'canceled'];

  int selectedPostTabIndex = 0;
  void updatePostTabIndex(int index){
    if(selectedPostTabIndex == index) return;
    selectedPostTabIndex = index;
    getMyPostList(1, reload: true);
  }

  List<MyPostData> postsForDate(int dateIndex) => listOfMyPost![dateIndex];

  int get filteredPostTotalCount {
    int total = 0;
    for(int i=0; i<dateList.length; i++){
      total += postsForDate(i).length;
    }
    return total;
  }

  String dateGroupLabel(int dateIndex){
    final String rawLabel = dateList[dateIndex];
    return rawLabel == DateConverter.dateStringMonthYear(DateTime.now()) ? 'today'.tr : rawLabel;
  }

  String? _editingPostId;
  String? get editingPostId => _editingPostId;
  bool get isEditMode => _editingPostId != null;

  PostFullDetails? postDetails;
  bool _isLoadingPostDetails = false;
  bool get isLoadingPostDetails => _isLoadingPostDetails;

  ProviderOfferModel? providerOfferModel;
  List<ProviderOfferData>? listOfProviderOffer = [];

  ProviderOfferData? notificationBiddingDetails;

  String _errorMessage(Response response){
    dynamic body = response.body;
    if(body is Map && body['message'] != null){
      return body['message'].toString();
    }
    return response.statusText ?? 'something_went_wrong'.tr;
  }


  Future<void> createCustomPost(String? schedule, {AddressModel? serviceAddress }) async {
    _isLoading = true;
    update();
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress;
    bool isOpenMarket = BusinessModelHelper.isOpenMarket;

    Response  response = await createPostRepo.createCustomPost(
      CreatePostBody(
        serviceId: isOpenMarket ? null : selectedService?.id,
        serviceName: isOpenMarket ? serviceNameController.text.trim() : null,
        categoryId: isOpenMarket ? selectedCategoryId : selectedService?.categoryId,
        subCategoryId: isOpenMarket ? selectedSubCategoryId : selectedService?.subCategoryId,
        addressId: addressModel?.id == "null" || addressModel?.id == null ? "" :  addressModel?.id,
        serviceDescription: descriptionController.text,
        serviceSchedule: schedule,
        additionDescriptions: additionalInstruction,
        serviceAddress: jsonEncode(serviceAddress),
        contactPersonName: ContactInfoHelper.resolveName(),
        contactPersonNumber: ContactInfoHelper.resolvePhone(),
      )
    );

    if(response.statusCode==200){
      resetCreatePostValue();
      Get.offNamed(RouteHelper.getCreatePostSuccessfullyScreen());
      customSnackBar("your_post_has_been_created_successfully".tr,type : ToasterMessageType.success);
    }else{
      customSnackBar(_errorMessage(response));
    }
    _isLoading = false;
    update();
  }




  Future<void> getMyPostList(int offset,{reload = false, bool shouldUpdate = true, int? tabIndex}) async {
    _offset = offset;
    if(reload){
      allPostList = [];
      listOfMyPost = [];
      dateList = [];
    }
    _isLoading = true;
    if(shouldUpdate){
      update();
    }
    Response response = await createPostRepo.getMyPostList(offset, status: _postTabStatuses[tabIndex ?? selectedPostTabIndex]);
    if(response.statusCode == 200){
      allPostList =[];
      postModel = PostModel.fromJson(response.body);
      for (var data in postModel!.data ?? <MyPostData>[]) {
        if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
          dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
        }
      }

      for (var data in postModel!.data ?? <MyPostData>[]) {
        allPostList.add(data);
      }

      for(int i=0;i< dateList.length;i++){
        listOfMyPost?.add([]);
        for (var element in allPostList) {
          if(dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            listOfMyPost![i].add(element);
          }
        }
      }
      _isLoading =false;
    } else{
      _isLoading =false;
    }
    update();
  }


  Future<void> getPostDetails(String postId) async {
    _isLoadingPostDetails = true;
    postDetails = null;

    Response response = await createPostRepo.getPostDetails(postId);
    if(response.statusCode == 200){
      final dynamic details = response.body is Map ? response.body['data'] : null;
      if(details is Map<String, dynamic>){
        postDetails = PostFullDetails.fromJson(details);
      }
    }
    _isLoadingPostDetails = false;
    update();
  }

  Future<void> getProvidersOfferList(int offset,String postId,{reload = false}) async {
    if(reload && providerOfferModel == null){
      providerOfferModel= null;
      providerOfferModel = null;
    }
    Response response = await createPostRepo.getProvidersOfferList(offset,postId);

    providerOfferModel = ProviderOfferModel.fromJson(response.body);


    if(response.statusCode == 200 && response.body["response_code"]=="default_200"){
      if(offset!=1){
        listOfProviderOffer!.addAll(providerOfferModel!.data ?? <ProviderOfferData>[]);
      }else{
        listOfProviderOffer = [];
        listOfProviderOffer!.addAll(providerOfferModel!.data ?? <ProviderOfferData>[]);
      }
    }
    else {
      listOfProviderOffer = [];
    }
    update();
  }


  Future<void> providerBidDetailsForNotification(String postId,String providerId) async {
    Response response = await createPostRepo.getProviderBidDetails(postId,providerId);
    if(response.statusCode==200){

      if(response.body['content']!=null){
        notificationBiddingDetails = ProviderOfferData.fromJson(response.body['content']['post_bid']);

        showGeneralDialog(
          context: Get.context!,
          barrierDismissible: true,
          transitionDuration: const Duration(milliseconds: 500),
          barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          pageBuilder: (context, _, a) {
            return ProviderBiddingNotificationDialog(providerOfferData: notificationBiddingDetails??ProviderOfferData(), postId: postId,);
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ).drive(Tween<Offset>(
                begin: const Offset(0, -1.0),
                end: Offset.zero,
              )),
              child: child,
            );
          },
        );


      }else{
        notificationBiddingDetails = null;
      }

    }
    else{
      notificationBiddingDetails = null;
    }
    update();
  }

  Future<Response> updatePostStatus(String postId, String providerId, String status, {int? isPartial, String? serviceAddress, String? serviceAddressId}) async {
    Response response = await createPostRepo.updatePostStatus(postId, providerId, status, isPartial: isPartial, serviceAddress: serviceAddress, serviceAddressId: serviceAddressId);

    return response;
  }

  Future<Response> makePayment({String? postId, String? providerId, String? paymentMethod, String? offlinePaymentId, String? customerInfo, int? isPartial} ) async {

    String zoneId = Get.find<LocationController>().getUserAddress()!.zoneId.toString();
    String? schedule = Get.find<ScheduleController>().scheduleTime;
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress ?? Get.find<LocationController>().getUserAddress();

    Response response = await createPostRepo.makePayment(
      paymentMethod : paymentMethod,
      postId : postId,
      providerId : providerId,
      schedule : schedule,
      serviceAddressID : addressModel?.id.toString() ?? "",
      address: jsonEncode(addressModel),
      zoneId : zoneId,
      offlinePaymentId: offlinePaymentId,
      customerInformation: customerInfo,
      isPartial: isPartial
    );
    return response;
  }


  void selectCategory(String id){
    if(Get.find<CategoryController>().categoryList!=null){
      for (var element in Get.find<CategoryController>().categoryList!) {
        if(element.id==id){
          selectedCategoryName =element.name!;
          selectedCategoryId =element.id!;
        }
      }

      selectedSubCategoryName = "";
      selectedSubCategoryId = "";
      update();
    }
  }

  void selectSubCategory(CategoryModel subCategory){
    selectedSubCategoryId = subCategory.id ?? "";
    selectedSubCategoryName = subCategory.name ?? "";
    update();
  }



  Future<void> initPostForEdit(PostFullDetails postData) async {
    Get.find<LocationController>().resetGuestContactInfo();
    _editingPostId = postData.id;
    if(BusinessModelHelper.isOpenMarket){
      selectedService = null;
      serviceNameController.text = postData.serviceName ?? "";
      selectedSubCategoryId = postData.subCategoryId ?? "";
    }else{
      selectedService = Service(
        id: postData.serviceId,
        name: postData.serviceName,
        thumbnailFullPath: postData.serviceImage,
        categoryId: postData.categoryId,
        subCategoryId: postData.subCategoryId,
        category: ServiceCategory(id: postData.categoryId, name: postData.categoryName),
      );
    }
    selectedCategoryName = postData.categoryName ?? "";
    selectedCategoryId = postData.categoryId ?? "";
    selectedSubCategoryName = postData.subCategoryName ?? "";
    descriptionController.text = postData.serviceDescription ?? "";
    additionalInstruction = (postData.additionInstructions ?? [])
        .map((instruction) => instruction.details ?? "")
        .where((details) => details.isNotEmpty)
        .toList();

    DateTime? schedule = postData.bookingSchedule != null ? DateTime.tryParse(postData.bookingSchedule!) : null;
    if(schedule != null){
      // Called from initState, so the builders must not be notified before the first build.
      Get.find<ScheduleController>().applySingleSchedule(schedule, shouldUpdate: false);
    }else{
      Get.find<ScheduleController>().resetSchedule();
    }

    await _selectPostAddress(postData.serviceAddressId);
  }

  Future<void> _selectPostAddress(String? addressId) async {
    if(addressId == null || addressId.isEmpty || addressId == "null"){
      return;
    }
    LocationController locationController = Get.find<LocationController>();
    if(locationController.addressList == null || locationController.addressList!.isEmpty){
      await locationController.getAddressList();
    }
    AddressModel? address = locationController.addressList?.firstWhereOrNull((address) => address.id.toString() == addressId);
    if(address != null){
      locationController.updateSelectedAddress(address);
    }
  }

  void resetForNewPost(){
    Service? preSelectedService = isEditMode ? null : selectedService;
    resetCreatePostValue();

    if(preSelectedService != null){
      selectedService = preSelectedService;
      selectedCategoryName = preSelectedService.category?.name ?? "";
      selectedCategoryId = preSelectedService.category?.id ?? "";
    }
  }


  void updateSelectedService(Service? newService){
    selectedService = newService;
    selectedCategoryName = newService?.category?.name ?? "";
    selectedCategoryId = newService?.category?.id ?? "";
    selectedSubCategoryName = "";
    selectedSubCategoryId = "";
    update();
  }


  void addAdditionalInstruction(String newInstruction){
    additionalInstruction.add(newInstruction);
    additionalInstructionController.text = '';
    update();
  }


  void removeAdditionalInstruction(int index){
    additionalInstruction.removeAt(index);
    update();
  }


  void resetCreatePostValue({bool removeService = true}){
    _isLoading = false;
    _editingPostId = null;
    selectedCategoryName= "";
    selectedCategoryId= "";
    selectedSubCategoryName= "";
    selectedSubCategoryId= "";
    additionalInstruction = [];
    descriptionController.clear();
    serviceNameController.clear();
    if(removeService){
      selectedService= null;
    }
    Get.find<LocationController>().resetGuestContactInfo();
  }

  bool checkProviderAvailability({required ProviderOfferData providerOfferData}){
    return providerOfferData.nextBookingEligibility ?? false;
  }

  bool _isUpdatingPost = false;
  bool get isUpdatingPost => _isUpdatingPost;

  bool _isCancelingPost = false;
  bool get isCancelingPost => _isCancelingPost;

  Future<bool> updatePostRequest(String postId, {required String description, required List<String> instructions, String? schedule, String? serviceAddressId, String? serviceId, String? serviceName, String? categoryId, String? subCategoryId, String? contactPersonName, String? contactPersonNumber}) async {
    _isUpdatingPost = true;
    update();

    Response response = await createPostRepo.updatePostRequest(postId, description: description, instructions: instructions, schedule: schedule, serviceAddressId: serviceAddressId, serviceId: serviceId, serviceName: serviceName, categoryId: categoryId, subCategoryId: subCategoryId, contactPersonName: contactPersonName, contactPersonNumber: contactPersonNumber);
    bool isSuccess = response.statusCode == 200;

    if(isSuccess){
      customSnackBar("post_updated_successfully".tr, type: ToasterMessageType.success);
    }else{
      customSnackBar(_errorMessage(response));
    }

    _isUpdatingPost = false;
    update();
    return isSuccess;
  }

  Future<bool> cancelPostRequest(String postId) async {
    _isCancelingPost = true;
    update();

    Response response = await createPostRepo.deletePost(postId);
    bool isSuccess = response.statusCode == 200;

    if(isSuccess){
      customSnackBar("post_canceled_successfully".tr, type: ToasterMessageType.success);
    }else{
      customSnackBar(_errorMessage(response));
    }

    _isCancelingPost = false;
    update();
    return isSuccess;
  }
}