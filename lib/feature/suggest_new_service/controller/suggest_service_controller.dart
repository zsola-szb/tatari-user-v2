import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/suggest_new_service/repository/suggest_service_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SuggestServiceController extends GetxController{

  final SuggestServiceRepo suggestServiceRepo;
  SuggestServiceController({required this.suggestServiceRepo});

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  String selectedCategoryName= "";
  String selectedCategoryId= "";
  String selectedSubCategoryName= "";
  String selectedSubCategoryId= "";

  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDetailsController = TextEditingController();

  String? editingServiceRequestId;
  bool get isEditing => editingServiceRequestId != null;

  List<SuggestedService> suggestedServiceList =[];
  SuggestedServiceModel? suggestedServiceModel;

  String selectedStatusFilter = 'all';

  List<String> get groupedDateLabels {
    final List<String> dateLabels = [];
    for (var service in suggestedServiceList) {
      final String label = _dateGroupLabel(service.createdAt);
      if(!dateLabels.contains(label)){
        dateLabels.add(label);
      }
    }
    return dateLabels;
  }

  List<SuggestedService> servicesForDateGroup(String label) {
    return suggestedServiceList.where((service) => _dateGroupLabel(service.createdAt) == label).toList();
  }

  String _dateGroupLabel(String? createdAt) {
    final DateTime? date = createdAt == null || createdAt.isEmpty ? null : DateTime.tryParse(createdAt);
    if(date == null){
      return '';
    }
    final DateTime now = DateTime.now();
    if(date.year == now.year && date.month == now.month && date.day == now.day){
      return 'today'.tr;
    }
    return DateFormat('d MMM yyyy').format(date);
  }

  void updateStatusFilter(String status){
    if(selectedStatusFilter == status){
      return;
    }
    selectedStatusFilter = status;
    getSuggestedServiceList(1, reload: true);
  }

  Future<void> getSuggestedServiceList(int offset,{reload = false}) async {
    if(reload){
      suggestedServiceModel= null;
      suggestedServiceList = [];
      update();
    }
    Response response = await suggestServiceRepo.getSuggestedServiceList(offset, status: selectedStatusFilter);
    if(response.statusCode == 200){
      suggestedServiceModel = SuggestedServiceModel.fromJson(response.body);
      if(offset!=1){
        suggestedServiceList.addAll(suggestedServiceModel!.suggestedServiceList!);
      }else{
        suggestedServiceList = [];
        suggestedServiceList.addAll(suggestedServiceModel!.suggestedServiceList!);
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> submitServiceRequest() async {
    _isLoading = true;
    update();

    Map<String,String> body={
      "category_id":selectedCategoryId,
      "service_name": serviceNameController.text,
      "service_description": serviceDetailsController.text,
      if(selectedSubCategoryId.isNotEmpty) "sub_category_id": selectedSubCategoryId,
    };
    Response response = isEditing
        ? await suggestServiceRepo.updateServiceRequest(editingServiceRequestId!, body)
        : await suggestServiceRepo.submitNewServiceRequest(body);
    if(response.statusCode == 200){
      final bool wasEditing = isEditing;
      clearData();
      Get.back();
      customSnackBar(
        wasEditing ? "service_request_updated_successfully".tr : "service_request_placed_successfully_to_admin".tr,
        type : ToasterMessageType.success,
      );
      getSuggestedServiceList(1, reload: true);
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void setupForEdit(SuggestedService service){
    editingServiceRequestId = service.id;
    selectedCategoryId = service.category?.id ?? "";
    selectedCategoryName = service.category?.name ?? "";
    selectedSubCategoryName = service.subCategory?.name ?? '';
    selectedSubCategoryId = service.subCategory?.id ?? '';
    serviceNameController.text = service.serviceName ?? "";
    serviceDetailsController.text = service.serviceDescription ?? "";
    update();
    if(service.category?.slug != null){
      Get.find<CategoryController>().getSubCategoryList(service.category!.slug!);
    }
  }

  Future<ResponseModel> deleteServiceRequest(String id) async {
    ResponseModel responseModel;
    Response response = await suggestServiceRepo.deleteServiceRequest(id);
    if(response.statusCode == 200){
      getSuggestedServiceList(1);
      responseModel = ResponseModel(true, response.body['message'] ?? "service_request_deleted_successfully".tr);
    }
    else {
      responseModel = ResponseModel(false, response.body['message'] ?? response.statusText ?? "");
    }
    update();
    return responseModel;
  }

  void setCategory(CategoryModel? category){
    selectedCategoryName = category?.name ?? "";
    selectedCategoryId = category?.id ?? "";
    selectedSubCategoryName = "";
    selectedSubCategoryId = "";
    update();
    if(category?.slug != null){
      Get.find<CategoryController>().getSubCategoryList(category!.slug!);
    }
  }

  void setSubCategory(CategoryModel? subCategory){
    selectedSubCategoryName = subCategory?.name ?? "";
    selectedSubCategoryId = subCategory?.id ?? "";
    update();
  }

  void clearData(){
    serviceNameController.text="";
    serviceDetailsController.text = "";
    selectedCategoryName= "";
    selectedCategoryId= "";
    selectedSubCategoryName= "";
    selectedSubCategoryId= "";
    editingServiceRequestId = null;
  }

}
