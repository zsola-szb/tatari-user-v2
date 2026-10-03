import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

void openPostDetails(String status, MyPostData? postData){
  if(status == "canceled"){
    Get.bottomSheet(
      CanceledPostDetailsSheet(postId: postData?.id ?? ""),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }else if(status == "bid_accepted" && postData?.bookingId != null){
    Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId: postData!.bookingId));
  }else{
    Get.toNamed(RouteHelper.getProviderOfferListScreen(postData?.id??"",status));
  }
}

class MyPostView extends StatelessWidget {
  final MyPostData? postData;
  const MyPostView({super.key, this.postData});

  @override
  Widget build(BuildContext context) {

    final int providersCount = postData?.providers?.length ?? 0;
    final String status = (postData?.isCanceled ?? 0) == 1
        ? "canceled"
        : (postData?.isBooked ?? 0) == 1
            ? "bid_accepted"
            : (providersCount > 0 ? "bid_available" : "no_bid");

    return GestureDetector(
      onTap: () => openPostDetails(status, postData),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: MyPostServiceHeader(postData: postData)),

                if(status == "bid_accepted" || status == "bid_available")...[
                const SizedBox(width: Dimensions.padding8),
                MyPostOfferPriceLabel(amount: postData?.offerPrice ?? 0, isBidAccepted: status == "bid_accepted"),
                ]

              ],
            ),

            const SizedBox(height: Dimensions.padding10),

            MyPostStatusSection(status: status, postData: postData),
          ],
        ),
      ),
    );
  }
}

class MyPostServiceHeader extends StatelessWidget {
  final MyPostData? postData;
  const MyPostServiceHeader({super.key, this.postData});

  @override
  Widget build(BuildContext context) {
    final bool isOpenMarket = BusinessModelHelper.isOpenMarket;
    final String image = (isOpenMarket ? postData?.categoryImage : postData?.serviceImage) ?? "";
    final String title = (isOpenMarket ? postData?.categoryName : postData?.serviceName) ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius8),
          child: CustomImage(height: 48, width: 48, fit: BoxFit.cover, image: image),
        ),
        const SizedBox(width: Dimensions.padding10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.heading.defaultSize,
                  maxLines: 1, overflow: TextOverflow.ellipsis),

              Padding(
                padding: const EdgeInsets.only(top: Dimensions.padding4),
                child: Text(postData?.subCategoryName ?? "", style: context.body.small,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyPostOfferPriceLabel extends StatelessWidget {
  final double? amount;
  final bool isBidAccepted;
  const MyPostOfferPriceLabel({super.key, this.amount, required this.isBidAccepted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(isBidAccepted ? 'offer_price'.tr : 'min_offer_price'.tr, style: context.body.extraSmall),
        Text(PriceConverter.convertPrice(amount), style: context.heading.small),
      ],
    );
  }
}

class MyPostStatusSection extends StatelessWidget {
  final String status;
  final MyPostData? postData;
  const MyPostStatusSection({super.key, required this.status, this.postData});

  @override
  Widget build(BuildContext context) {
    final Widget detailsButton = CustomButton(
      buttonText: 'details'.tr,
      width: 78,
      height: 32,
      radius: Dimensions.radius8,
      fontSize: Dimensions.fontSizeSmall,
      onPressed: () => openPostDetails(status, postData),
    );

    if(status == "canceled"){
      return Row(children: [
        Icon(Icons.delete_outline, size: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.error),
        const SizedBox(width: Dimensions.padding4),

        Expanded(child: Text('deleted_this_post'.tr,
          style: context.body.small.overrideWith(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        )),
        const SizedBox(width: Dimensions.padding16),
        detailsButton,
      ]);
    }

    if(status == "no_bid"){
      return Row(children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
          ),
          padding: EdgeInsets.all(Dimensions.padding6),
          child: Icon(Icons.block, size: 14, color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(width: Dimensions.padding4),

        Expanded(child: Text("no_providers_bid_for_this_post".tr,
          style: context.body.small.overrideWith(color: Theme.of(context).colorScheme.error),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        )),
        const SizedBox(width: Dimensions.padding16),
        detailsButton,
      ]);
    }

    if(status == "bid_available"){
      final int providersCount = postData?.providers?.length ?? 0;
      return Row(children: [
        MyPostProviderAvatarStack(count: providersCount, providers: postData?.providers),
        const SizedBox(width: Dimensions.padding6),

        Expanded(child: Text('${providersCount > 2 ? '+${providersCount - 2}' : ''} ${'providers_are_interested'.tr}',
          style: context.body.small.overrideWith(color: context.customThemeColors.textColor),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        )),
        const SizedBox(width: Dimensions.padding16),
        detailsButton,
      ]);
    }

    final PostProvider? assignedProvider = (postData?.providers?.isNotEmpty ?? false) ? postData!.providers!.first : null;
    final String? companyName = assignedProvider?.name;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding6),
      child: Row(children: [
        MyPostProviderAvatar(imageUrl: assignedProvider?.image),
        const SizedBox(width: Dimensions.padding6),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName ?? '', style: context.heading.small, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Dimensions.padding6),

            Row(children: [
              Flexible(child: Text('${'id'.tr} #${postData?.bookingReadableId ?? ""}',
                style: context.body.small, maxLines: 1, overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(width: Dimensions.padding6),

              const MyPostBookingStatusBadge(bookingStatus: 'accepted'),
              const SizedBox(width: Dimensions.padding8),
            ]),
          ],
        )),
        const SizedBox(width: Dimensions.padding16),

        detailsButton,
      ]),
    );
  }
}

class MyPostBookingStatusBadge extends StatelessWidget {
  final String? bookingStatus;
  const MyPostBookingStatusBadge({super.key, this.bookingStatus});

  @override
  Widget build(BuildContext context) {
    final bool isSettled = bookingStatus == 'accepted' || bookingStatus == 'completed';
    final bool isCanceled = bookingStatus == 'canceled';

    final Color color = isSettled ? context.customThemeColors.success
        : isCanceled ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding2, horizontal: Dimensions.padding8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: Text(bookingStatus?.tr ?? "", style: context.body.extraSmall.overrideWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class MyPostProviderAvatar extends StatelessWidget {
  final String? imageUrl;
  const MyPostProviderAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.red,
        height: 35, width: 35,
        child: CustomImage(image: imageUrl ?? "", height: 22, width: 22, fit: BoxFit.cover),
      ),
    );
  }
}

class MyPostProviderAvatarStack extends StatelessWidget {
  final int count;
  final List<PostProvider>? providers;
  const MyPostProviderAvatarStack({super.key, required this.count, required this.providers});

  @override
  Widget build(BuildContext context) {
    final int avatarCount = count > 2 ? 2 : (count < 1 ? 1 : count);

    return SizedBox(
      height: 35, width: count == 1 ? 35 : (avatarCount * 35).toDouble(),
      child: Stack(
        children: List.generate(avatarCount, (index) => Positioned(
          left: (index * 30).toDouble(),
          child: MyPostProviderAvatar(imageUrl: providers?[index].image),
        )),
      ),
    );
  }
}
