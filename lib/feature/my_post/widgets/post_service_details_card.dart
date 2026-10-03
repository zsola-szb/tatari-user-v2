import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PostServiceDetailsCard extends StatelessWidget {
  final PostFullDetails postData;
  final String postId;
  final bool showEditButton;
  const PostServiceDetailsCard({super.key, required this.postData, required this.postId, this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      AddressModel? addressModel = CheckoutHelper.selectedAddressModel(
        selectedAddress: locationController.selectedAddress,
        pickedAddress: locationController.getUserAddress(),
      );

      String customerName = postData.contactPersonName ?? '';

      String customerPhone = postData.contactPersonNumber ?? '';

      String customerAddress = addressModel?.address ?? "";

      bool isOpenMarket = BusinessModelHelper.isOpenMarket;
      String typedServiceName = postData.serviceName ?? "";

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Container(
            height: 2, width: 40,
            decoration: BoxDecoration(
              color: context.customThemeColors.secondaryBackGroundColor
            ),
          ),
        ),
        const SizedBox(height: Dimensions.padding16),

        Text('service_info'.tr, style: context.heading.large),
        const SizedBox(height: Dimensions.padding16),

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            child: CustomImage(
              height: 56, width: 56, fit: BoxFit.cover,
              image: (isOpenMarket ? postData.categoryImage : postData.serviceImage) ?? "",
            ),
          ),
          const SizedBox(width: Dimensions.padding12),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text((isOpenMarket ? postData.categoryName : postData.serviceName) ?? "",
                  style: context.heading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: Dimensions.padding4),

              Text(postData.subCategoryName ?? "", style: context.body.small, maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
        const SizedBox(height: Dimensions.padding20),

        // Open market posts carry no catalog service, so the name the customer
        // typed is the only record of what they actually asked for.
        if(isOpenMarket && typedServiceName.isNotEmpty) ...[
          PostDetailsInfoBox(title: 'service_name'.tr, value: typedServiceName),
          const SizedBox(height: Dimensions.padding20),
        ],

        PostDetailsInfoBox(title: 'service_details'.tr, value: postData.serviceDescription ?? ""),

        if(customerName.isNotEmpty || customerAddress.isNotEmpty) ...[
          const SizedBox(height: Dimensions.padding20),

          Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: context.customThemeColors.secondaryBackGroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16)
            ),
            padding: EdgeInsets.all(Dimensions.padding16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('my_details'.tr, style: context.heading.small),
              const SizedBox(height: Dimensions.padding8),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      if(customerName.isNotEmpty)
                        Flexible(child: Text(customerName, style: context.subHeading.small.overrideWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if(customerName.isNotEmpty && customerPhone.isNotEmpty) const SizedBox(width: Dimensions.padding8),

                      if(customerPhone.isNotEmpty)
                        Directionality(textDirection: TextDirection.ltr, child: Text('($customerPhone)', style: context.body.small.overrideWith(color: context.customThemeColors.textColor))),
                    ]),
                    if(customerAddress.isNotEmpty) ...[
                      const SizedBox(height: Dimensions.padding4),

                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.padding2),
                          child: SvgPicture.asset(Images.locationMarker, width: 14, height: 14),
                          ),
                        const SizedBox(width: Dimensions.padding10),

                        Text(customerAddress, style: context.body.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
                      ]),
                    ],
                  ]),
                ),
              ]),
            ]),
          )
        ],

        const SizedBox(height: Dimensions.padding20),
        PostRequestActionButtons(postId: postId, postData: postData, showEditButton: showEditButton),
      ]);
    });
  }
}

class PostDetailsInfoBox extends StatelessWidget {
  final String title;
  final String value;
  const PostDetailsInfoBox({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: context.customThemeColors.secondaryBackGroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(Dimensions.padding16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: context.heading.small),
        const SizedBox(height: Dimensions.padding8),

        Text(value, style: context.body.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
      ]),
    );
  }
}

class PostRequestActionButtons extends StatelessWidget {
  final String postId;
  final PostFullDetails postData;
  final bool showEditButton;
  const PostRequestActionButtons({super.key, required this.postId, required this.postData, this.showEditButton = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(builder: (createPostController) {
      final Widget cancelButton = CustomButton(
        buttonText: 'cancel_request'.tr,
        height: 44,
        radius: Dimensions.radius8,
        backgroundColor: context.customThemeColors.secondaryBackGroundColor,
        textColor: context.customThemeColors.textColor,
        onPressed: () {
          Get.bottomSheet(
            CancelPostRequestSheet(postId: postId),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        },
      );

      if(!showEditButton){
        return cancelButton;
      }

      return Row(children: [
        Expanded(child: cancelButton),
        const SizedBox(width: Dimensions.padding12),
        Expanded(
          child: CustomButton(
            buttonText: 'edit_request'.tr,
            height: 44,
            radius: Dimensions.radius8,
            onPressed: () async {
              dynamic result = await Get.toNamed(RouteHelper.getCreatePostScreen(postData: postData));
              if(result is PostFullDetails){
                postData.serviceDescription = result.serviceDescription;
                postData.additionInstructions = result.additionInstructions;
                postData.bookingSchedule = result.bookingSchedule;
                postData.serviceAddressId = result.serviceAddressId;
                postData.serviceId = result.serviceId;
                postData.serviceName = result.serviceName;
                postData.serviceImage = result.serviceImage;
                postData.categoryId = result.categoryId;
                postData.categoryName = result.categoryName;
                postData.subCategoryId = result.subCategoryId;
                postData.subCategoryName = result.subCategoryName;
                postData.contactPersonNumber = result.contactPersonNumber;
                postData.contactPersonName = result.contactPersonName;
                createPostController.update();
              }
            },
          ),
        ),
      ]);
    });
  }
}
