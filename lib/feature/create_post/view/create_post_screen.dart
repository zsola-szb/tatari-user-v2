import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CreatePostScreen extends StatefulWidget {
  final PostFullDetails? postData;
  const CreatePostScreen({super.key, this.postData}) ;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  late JustTheController tooltipController;
  final focusNode = FocusNode();

  bool get isEditMode => widget.postData != null;

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(false);
    tooltipController = JustTheController();

    CreatePostController createPostController = Get.find<CreatePostController>();
    if(isEditMode){
      createPostController.initPostForEdit(widget.postData!);
    }else{
      createPostController.resetForNewPost();
      _initScheduleForNewPost();
    }
  }

  void _initScheduleForNewPost() {
    ScheduleController scheduleController = Get.find<ScheduleController>();
    bool scheduleAllowed = Get.find<CartController>().checkScheduleBookingAvailability() == null;

    if(scheduleAllowed){
      // Starts on the current date and time, keeping the small lead the app already uses for instant bookings.
      scheduleController.applySingleSchedule(DateTime.now().add(const Duration(minutes: 2)), shouldUpdate: false);
    }else{
      scheduleController.resetSchedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController){
      return Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: isEditMode ? "edit_request".tr : "create_custom_service".tr, isBackButtonExist: true,
          onBackPressed: (){
          if(Navigator.canPop(context)){
            Get.back();
          }else{
            Get.offAllNamed(RouteHelper.getMainRoute("home"));
          }
          },
        ),
        body: GetBuilder<CategoryController>(builder: (categoryController){
          return GetBuilder<CreatePostController>(
            builder: (createPostController){
              return SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.padding16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                  const CreatePostScheduleCard(),
                  const SizedBox(height: Dimensions.padding16),

                  CreatePostLocationCard(editingPost: widget.postData),
                  const SizedBox(height: Dimensions.padding16),

                  CreatePostServiceInfoCard(tooltipController: tooltipController),

                  if(createPostController.additionalInstruction.isNotEmpty)
                    ListView.builder(itemBuilder: (context,index){
                      return Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius6),
                        color: Get.isDarkMode ? Theme.of(context).hintColor.withValues(alpha: 0.1) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        border: Border.all(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium!.color! : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),),
                        padding: const EdgeInsets.all(Dimensions.padding16),
                        margin: const EdgeInsets.only(top: Dimensions.padding10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Flexible(child: Text(createPostController.additionalInstruction[index],style: context.subHeading.defaultSize.overrideWith(color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary),)),

                          const SizedBox(width: Dimensions.padding16,),
                          GestureDetector(
                            onTap: ()=> createPostController.removeAdditionalInstruction(index),
                            child: Container(
                              color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                              padding: const EdgeInsets.all(2),
                              child: Center(child: Icon(
                                Icons.close,color: Theme.of(context).colorScheme.primary, size: 12,
                              ),),
                            ),
                          )
                        ],),
                      );
                    },
                      itemCount: createPostController.additionalInstruction.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),

                  const SizedBox(height: Dimensions.padding24),
                  InkWell(
                    onTap: () => showDialog(
                        context: context, builder: (BuildContext context){
                      return const AdditionalInstructionDialog();
                    }).then((value) => createPostController.additionalInstructionController.text = ''),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text(createPostController.hasServiceSelection ?
                      'add_additional_instruction'.tr : 'add_any_specific_requests_here'.tr,
                        style:  context.subHeading.defaultSize.overrideWith(
                          color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary,
                        ),),
                      const SizedBox(width: Dimensions.padding6),
                      Container(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          child: Icon(Icons.add,color: Get.isDarkMode ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).colorScheme.primary, size: 20)),
                    ],),
                  ),
                  const SizedBox(height: Dimensions.padding24),

                  (isEditMode ? createPostController.isUpdatingPost : createPostController.isLoading) ? const Center(child: CircularProgressIndicator()) : CustomButton(
                    buttonText: isEditMode ? "save_changes".tr : "create_post".tr,
                    height: 50,
                    radius: Dimensions.radius12,
                    onPressed: (){
                      _submitPost(createPostController, scheduleController);
                    },
                  ),
                ],),
              );
            },
          );
        }),
      );
    });
  }

  void _submitPost(CreatePostController  createPostController, ScheduleController scheduleController) {
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress ?? Get.find<LocationController>().getUserAddress();
    String? schedule = scheduleController.scheduleTime;
    ConfigModel configModel = Get.find<SplashController>().configModel;

    if(schedule == null && scheduleController.selectedScheduleType != ScheduleType.asap) {
      customSnackBar("select_your_preferable_booking_time".tr, type: ToasterMessageType.info);
    }
    else if(scheduleController.selectedScheduleType == ScheduleType.schedule && configModel.content?.scheduleBookingTimeRestriction == 1 && scheduleController.checkValidityOfTimeRestriction(Get.find<SplashController>().configModel.content!.advanceBooking!) != null){
      customSnackBar(scheduleController.checkValidityOfTimeRestriction(Get.find<SplashController>().configModel.content!.advanceBooking!));
    }
    else if(addressModel == null){
      customSnackBar('add_address_first'.tr, type: ToasterMessageType.info);
    } else if(!ContactInfoHelper.hasContactInfo(fallbackName: widget.postData?.contactPersonName, fallbackPhone: widget.postData?.contactPersonNumber)){
      customSnackBar(Get.find<AuthController>().isLoggedIn()
          ? "please_enter_phone_number".tr : "please_input_contact_person_name_and_phone_number".tr, type: ToasterMessageType.info);
    }
    else if(BusinessModelHelper.isOpenMarket && createPostController.selectedCategoryId.isEmpty){
      customSnackBar("select_category".tr, type: ToasterMessageType.info);
    }
    else if(BusinessModelHelper.isOpenMarket && createPostController.selectedSubCategoryId.isEmpty){
      customSnackBar("select_sub_category".tr, type: ToasterMessageType.info);
    }
    else if(!createPostController.hasServiceSelection){
      customSnackBar(BusinessModelHelper.isOpenMarket
          ? "enter_service_name".tr : "select_your_desired_service".tr, type: ToasterMessageType.info);
    }else if(createPostController.descriptionController.text.isEmpty){
      customSnackBar("enter_service_description".tr, type: ToasterMessageType.info);
    }else{
      if(scheduleController.selectedScheduleType == ScheduleType.asap){
        scheduleController.buildSchedule(scheduleType: ScheduleType.asap);
      }
      if(isEditMode){
        _updatePost(createPostController, scheduleController, addressModel);
      }else{
        createPostController.createCustomPost(schedule, serviceAddress: addressModel);
      }
    }
  }

  Future<void> _updatePost(CreatePostController createPostController, ScheduleController scheduleController, AddressModel addressModel) async {
    PostFullDetails postData = widget.postData!;
    String description = createPostController.descriptionController.text.trim();
    List<String> instructions = List<String>.from(createPostController.additionalInstruction);
    String? addressId = addressModel.id == "null" ? null : addressModel.id;

    Service? selectedService = createPostController.selectedService;
    bool isOpenMarket = BusinessModelHelper.isOpenMarket;
    String typedServiceName = createPostController.serviceNameController.text.trim();

    String? serviceId = isOpenMarket ? null : selectedService?.id;
    String? categoryId = isOpenMarket ? createPostController.selectedCategoryId : selectedService?.categoryId;
    String? subCategoryId = isOpenMarket ? createPostController.selectedSubCategoryId : selectedService?.subCategoryId;

    bool isSuccess = await createPostController.updatePostRequest(
      postData.id ?? "",
      description: description,
      instructions: instructions,
      schedule: scheduleController.scheduleTime,
      serviceAddressId: addressId,
      serviceId: serviceId,
      serviceName: isOpenMarket ? typedServiceName : null,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      contactPersonName: ContactInfoHelper.resolveName(fallbackName: postData.contactPersonName),
      contactPersonNumber: ContactInfoHelper.resolvePhone(fallbackPhone: postData.contactPersonNumber),
    );

    if(isSuccess){
      postData.serviceDescription = description;
      postData.additionInstructions = instructions.map((details) => AdditionInstructions(details: details)).toList();
      postData.bookingSchedule = scheduleController.scheduleTime;
      postData.serviceAddressId = addressId ?? postData.serviceAddressId;
      postData.contactPersonName = ContactInfoHelper.resolveName(fallbackName: postData.contactPersonName);
      postData.contactPersonNumber = ContactInfoHelper.resolvePhone(fallbackPhone: postData.contactPersonNumber);
      postData.serviceId = serviceId;
      postData.serviceName = isOpenMarket ? typedServiceName : selectedService?.name;
      postData.serviceImage = isOpenMarket ? postData.serviceImage : selectedService?.thumbnailFullPath;
      postData.categoryId = categoryId;
      postData.categoryName = createPostController.selectedCategoryName;
      postData.categoryImage = Get.find<CategoryController>().categoryList?.firstWhereOrNull(
        (element) => element.id == categoryId,
      )?.imageFullPath ?? postData.categoryImage;
      postData.subCategoryId = subCategoryId;
      postData.subCategoryName = isOpenMarket
          ? createPostController.selectedSubCategoryName
          : Get.find<CategoryController>().subCategoryList?.firstWhereOrNull(
              (element) => element.id == selectedService?.subCategoryId,
            )?.name;

      Get.back(result: postData);
      createPostController.resetCreatePostValue();
      createPostController.getMyPostList(1, reload: true);
    }
  }
}
