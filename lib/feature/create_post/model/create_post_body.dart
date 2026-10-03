
class CreatePostBody {
  String? serviceId;
  String? serviceName;
  String? categoryId;
  String? subCategoryId;
  String? addressId;
  String? serviceDescription;
  String? serviceSchedule;
  String? serviceAddress;
  List<String>? additionDescriptions;
  String? contactPersonName;
  String? contactPersonNumber;

  CreatePostBody({
    this.serviceId, this.serviceName, this.categoryId,this.subCategoryId,
    this.addressId, this.serviceDescription, this.serviceSchedule,
    this.additionDescriptions, this.serviceAddress,
    this.contactPersonName, this.contactPersonNumber
  });

  CreatePostBody.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    addressId = json['service_address_id'];
    serviceAddress = json['service_address'];
    serviceDescription = json['service_description'];
    serviceSchedule = json['booking_schedule'];
    additionDescriptions = json['additional_instructions'].cast<String>();
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(serviceId != null && serviceId!.isNotEmpty) data['service_id'] = serviceId;
    if(serviceName != null && serviceName!.isNotEmpty) data['service_name'] = serviceName;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['service_address_id'] = addressId;
    data['service_address'] = serviceAddress;
    data['service_description'] = serviceDescription;
    data['booking_schedule'] = serviceSchedule;
    data['additional_instructions'] = additionDescriptions;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;

    return data;
  }
}
