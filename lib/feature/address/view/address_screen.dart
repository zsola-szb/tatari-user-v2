import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/common/widgets/staggered_list_animation.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AddressScreen extends StatefulWidget {
  final String? fromPage;
  const AddressScreen({super.key, this.fromPage}) ;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}


class _AddressScreenState extends State<AddressScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<LocationController>().getAddressList(fromCheckout: widget.fromPage=="checkout"?true:false);
  }


  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        appBar: CustomAppBar(title: 'my_address'.tr),
        backgroundColor: context.customThemeColors.backGroundColor,
        body: GetBuilder<LocationController>(
            builder: (locationController) {
              List<AddressModel>? addressList = locationController.addressList;
              List<AddressModel>? zoneBasedAddress = [];
              if(addressList != null && addressList.isNotEmpty ){
                zoneBasedAddress =  addressList.where((element) =>
                element.zoneId == Get.find<LocationController>().getUserAddress()?.zoneId).toList();
              }
              if(widget.fromPage == "checkout"){
                addressList = zoneBasedAddress;
              }

              AddressModel? addressModel;
              addressModel = locationController.getUserAddress();

              if(locationController.addressList!=null){
                return Column(
                  children: [
                    const SizedBox(height: Dimensions.padding16),

                    addressList!.isNotEmpty ?
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await locationController.getAddressList();
                        },
                        child: StaggeredListAnimationWrapper(
                          key: ValueKey(addressList.length),
                          duration: const Duration(milliseconds: 600),
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(Dimensions.padding16),
                            itemCount: addressList.length,
                            itemBuilder: (context, index) {
                              return StaggeredListAnimationItem(
                                index: index,
                                child: MyAddressItem(
                                  address: addressList![index],
                                  isDefault: addressModel?.id != null && addressModel?.id == addressList[index].id,
                                  onTap: () async {
                                    if(widget.fromPage == 'checkout'){
                                      if(isRedundentClick(DateTime.now())){
                                        return;
                                      }
                                      Get.dialog(const CustomLoader(),barrierDismissible: false);
                                      await locationController.setAddressIndex(addressList![index]).then((isSuccess){
                                        Get.back();
                                        if(!isSuccess){
                                          customSnackBar('this_service_not_available'.tr);
                                        }
                                      });
                                      Get.back();
                                    }
                                  },
                                  onEditPressed: () {
                                    Get.toNamed(RouteHelper.getEditAddressRoute(addressList![index], false));
                                  },
                                  onDeletePressed: () {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    Get.bottomSheet(
                                      ConfirmationBottomsheet(
                                        icon: Images.warning,
                                        description: 'are_you_sure_want_to_delete_address'.tr,
                                        onYesPressed: () {
                                          Get.back();

                                          Get.dialog(
                                            const CustomLoader(), barrierDismissible: false,
                                          );
                                          locationController.deleteUserAddressByID(addressList![index],
                                          ).then((response) {
                                            Get.back();
                                            customSnackBar(response.message!.tr.capitalizeFirst,type : ToasterMessageType.success);
                                          });
                                        },
                                      ),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    );
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, idx){
                              return const SizedBox(height: Dimensions.padding12);
                            },
                          ),
                        ),
                      ),
                    ) :
                    SizedBox(height: Get.height*0.6,child: Center(child: NoDataScreen(text: 'no_address_found'.tr,type: NoDataType.address,))),
                  ],
                );
              }else{
                return const Center(child: CircularProgressIndicator());
              }
            }),

        floatingActionButton: Get.find<AuthController>().isLoggedIn() ? FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Get.toNamed(RouteHelper.getAddAddressRoute(widget.fromPage == 'checkout' ? true : false));
          },
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ) : null,
      ),
    );
  }
}
