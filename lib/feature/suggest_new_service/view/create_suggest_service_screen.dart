import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CreateSuggestServiceScreen extends StatefulWidget {
  final SuggestedService? editingService;

  const CreateSuggestServiceScreen({super.key, this.editingService});

  @override
  State<CreateSuggestServiceScreen> createState() => _CreateSuggestServiceScreenState();
}

class _CreateSuggestServiceScreenState extends State<CreateSuggestServiceScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.editingService != null){
        Get.find<SuggestServiceController>().setupForEdit(widget.editingService!);
      }else{
        Get.find<SuggestServiceController>().clearData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: CustomAppBar(title: 'suggest_new_service'.tr),
      body: SizedBox(
        width: Dimensions.webMaxWidth,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.padding16),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.padding16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius16),
            ),
            child: const SuggestServiceInputField(),
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<SuggestServiceController>(builder: (suggestServiceController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.padding16),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Expanded(child: CustomButton(
                  backgroundColor: Theme.of(context).hintColor.withValues(alpha: 0.15),
                  textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  buttonText: 'cancel'.tr,
                  onPressed: () => Get.back(),
                )),
                const SizedBox(width: Dimensions.padding16),
                Expanded(child: CustomButton(
                  buttonText: suggestServiceController.isEditing ? 'update_request'.tr : 'send_request'.tr,
                  isLoading: suggestServiceController.isLoading,
                  onPressed: (){
                    if(suggestServiceController.selectedCategoryName==""){
                      customSnackBar('select_category'.tr, type: ToasterMessageType.info);
                    }else if(suggestServiceController.serviceNameController.text==""){
                      customSnackBar('provide_your_desired_service_name'.tr, type: ToasterMessageType.info);
                    }else if(suggestServiceController.serviceDetailsController.text.isEmpty){
                      customSnackBar("provide_some_details_about_your_service".tr, type: ToasterMessageType.info);
                    }else{
                      suggestServiceController.submitServiceRequest();
                    }
                  },
                )),
              ]),
            ],
          ),
        );
      }),
    );
  }
}
