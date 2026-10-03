import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

const Color _kStarColor = Color(0xFFF5A623);

class ServiceReviewTile extends StatelessWidget {
  final Review review;
  final int index;
  const ServiceReviewTile({super.key, required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    final String name = review.customer == null
        ? 'customer_not_available'.tr
        : '${review.customer?.firstName ?? ''} ${review.customer?.lastName ?? ''}'.trim();
    final String imageUrl = review.customer?.profileImageFullPath ?? '';
    final bool hasReply = review.reviewReply != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Avatar(imageUrl: imageUrl, name: name),
              Gaps.horizontalGapOf(Dimensions.padding10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.isNotEmpty ? name : 'customer_not_available'.tr, style: context.subHeading.defaultSize.medium),
                    if ((review.updatedAt ?? '').isNotEmpty) ...[
                      Gaps.verticalGapOf(Dimensions.padding2),
                      Text(
                        DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.updatedAt!)),
                        style: context.body.small,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.horizontalGapOf(Dimensions.padding10),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.padding4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(Dimensions.radius4),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star_rounded, size: 16, color: _kStarColor),
                    Gaps.horizontalGapOf(Dimensions.padding4),
                    Text('${review.reviewRating ?? 0}', style: context.subHeading.small.medium),
                  ]),
                ),
              ),
            ],
          ),

          if ((review.reviewComment ?? '').isNotEmpty) ...[
            Gaps.verticalGapOf(Dimensions.padding10),
            ReadMoreText(
              review.reviewComment!.capitalizeFirst ?? '',
              trimCollapsedText: 'see_more'.tr,
              trimExpandedText: '  ${'see_less'.tr}',
              trimMode: TrimMode.Line,
              trimLines: 3,
              style: context.body.small,
              textAlign: TextAlign.justify,
              moreStyle: context.subHeading.small.medium.overrideWith(color: Colors.blueAccent),
              lessStyle: context.subHeading.small.medium.overrideWith(color: Colors.blueAccent),
            ),
          ],

          if (hasReply) ...[
            Gaps.verticalGapOf(Dimensions.padding10),
            _ReplySection(review: review, index: index),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  const _Avatar({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: CustomImage(image: imageUrl, height: 36, width: 36, fit: BoxFit.cover, placeholder: Images.userPlaceHolder),
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.12),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: context.heading.defaultSize.strong.overrideWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class _ReplySection extends StatelessWidget {
  final Review review;
  final int index;
  const _ReplySection({required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = review.isExpended == 1;

    return Column(
      children: [
        if (isExpanded) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.padding10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'replied_by_provider'.tr,
                        style: context.subHeading.small.medium.overrideWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    if ((review.reviewReply?.updatedAt ?? '').isNotEmpty)
                      Text(
                        DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(review.reviewReply!.updatedAt!)),
                        style: context.body.small,
                        textDirection: TextDirection.ltr,
                      ),
                  ],
                ),
                if (review.provider != null) ...[
                  Gaps.verticalGapOf(Dimensions.padding2),
                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getProviderDetails(review.provider!.id!)),
                    child: Text(
                      review.provider?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.body.small
                          .overrideWith(color: Theme.of(context).primaryColor)
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
                Gaps.verticalGapOf(Dimensions.padding6),
                Text(
                  review.reviewReply?.reply?.capitalizeFirst ?? '',
                  style: context.body.small,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Gaps.verticalGapOf(Dimensions.padding10),
        ],
        InkWell(
          onTap: () => Get.find<ServiceTabController>().updateProviderReviewExpendedStatus(index: index),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isExpanded ? 'hide_reply'.tr : 'view_reply'.tr,
                style: context.subHeading.small.medium.overrideWith(color: Colors.blueAccent),
              ),
              Gaps.horizontalGapOf(Dimensions.padding4),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(Images.chevronDownArrowIcon,
                  width: 16, height: 16,
                  colorFilter: const ColorFilter.mode(Colors.blueAccent, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
