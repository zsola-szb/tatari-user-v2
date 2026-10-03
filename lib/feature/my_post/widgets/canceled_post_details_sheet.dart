import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Full-screen bottom sheet showing read-only details of a canceled/deleted
/// custom post, fetched from `GET /api/v2/customer/post/details/{postId}`.
class CanceledPostDetailsSheet extends StatefulWidget {
  final String postId;
  const CanceledPostDetailsSheet({super.key, required this.postId});

  @override
  State<CanceledPostDetailsSheet> createState() => _CanceledPostDetailsSheetState();
}

class _CanceledPostDetailsSheetState extends State<CanceledPostDetailsSheet> {
  @override
  void initState() {
    super.initState();
    Get.find<CreatePostController>().getPostDetails(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: double.infinity,
      child: Material(
        color: Theme.of(context).cardColor,
        child: SafeArea(
          child: GetBuilder<CreatePostController>(
            builder: (createPostController) {
              final PostFullDetails? postData = createPostController.postDetails;

              return Column(children: [
                const SizedBox(height: Dimensions.padding24),

                const CanceledPostDetailsHeader(),

                Expanded(
                  child: createPostController.isLoadingPostDetails || postData == null
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(Dimensions.padding20),
                          child: CanceledPostDetailsContent(postData: postData),
                        ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class CanceledPostDetailsHeader extends StatelessWidget {
  const CanceledPostDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(children: [
        Expanded(
          child: Text('custom_service_details'.tr, style: context.heading.large,
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: Dimensions.padding10),

        CustomInkWell(
          radius: Dimensions.radiusFull,
          onTap: () => Get.back(),
          child: Container(
            height: 24, width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: context.customThemeColors.backGroundColor, shape: BoxShape.circle),
            child: Icon(Icons.close, size: 18, color: context.customThemeColors.secondaryTextColor),
          ),
        ),
      ]),
    );
  }
}

class CanceledPostDetailsContent extends StatelessWidget {
  final PostFullDetails postData;
  const CanceledPostDetailsContent({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final String customerName = postData.contactPersonName ?? '';
    final String customerPhone = postData.contactPersonNumber ?? '';
    final String customerAddress = postData.serviceAddress ?? postData.serviceAddressLocation?.address ?? '';
    final String cancelNote = postData.cancelNote ?? '';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('service_info'.tr, style: context.heading.large),
      const SizedBox(height: Dimensions.padding24),

      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.customThemeColors.secondaryBackGroundColor),
              borderRadius: BorderRadius.circular(Dimensions.radius8),
            ),
            child: CustomImage(height: 44, width: 44, fit: BoxFit.cover, image: postData.serviceImage ?? ""),
          ),
        ),
        const SizedBox(width: Dimensions.padding12),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(postData.serviceName ?? "", style: context.heading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Dimensions.padding4),

            Text(postData.subCategoryName ?? "", style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ]),

      if(postData.serviceDescription != null && postData.serviceDescription!.isNotEmpty) ...[
        const SizedBox(height: Dimensions.padding24),
        PostDetailsInfoCard(
          title: 'service_details'.tr,
          child: Text(postData.serviceDescription!, style: context.body.small.overrideWith(color: context.customThemeColors.textColor)),
        ),
      ],

      if(customerName.isNotEmpty || customerAddress.isNotEmpty) ...[
        const SizedBox(height: Dimensions.padding20),
        PostDetailsInfoCard(
          title: 'my_details'.tr,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if(customerName.isNotEmpty)
                Flexible(child: Text(customerName, style: context.body.defaultSize.overrideWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if(customerName.isNotEmpty && customerPhone.isNotEmpty) const SizedBox(width: Dimensions.padding8),

              if(customerPhone.isNotEmpty)
                Directionality(textDirection: TextDirection.ltr, child: Text('($customerPhone)', style: context.body.defaultSize)),
            ]),
            if(customerAddress.isNotEmpty) ...[
              const SizedBox(height: Dimensions.padding8),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.padding2),
                  child: SvgPicture.asset(Images.locationMarker, width: 16, height: 16),
                ),
                const SizedBox(width: Dimensions.padding8),

                Expanded(child: Text(customerAddress, style: context.body.small.overrideWith(color: context.customThemeColors.secondaryTextColor))),
              ]),
            ],
          ]),
        ),
      ],

      if(cancelNote.isNotEmpty) ...[
        const SizedBox(height: Dimensions.padding20),
        PostDetailsInfoCard(
          title: 'cancellation_reason'.tr,
          titleColor: Theme.of(context).colorScheme.error,
          backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.08),
          child: Text(cancelNote, style: context.body.small.overrideWith(color: context.customThemeColors.textColor)),
        ),
      ],
    ]);
  }
}

class PostDetailsInfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? titleColor;
  final Color? backgroundColor;
  const PostDetailsInfoCard({super.key, required this.title, required this.child, this.titleColor, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.customThemeColors.backGroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: context.heading.small.overrideWith(color: titleColor)),
        const SizedBox(height: Dimensions.padding8),

        child,
      ]),
    );
  }
}
