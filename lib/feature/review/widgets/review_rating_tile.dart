import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const Color _kStarColor = Color(0xFFF5A623);

class ReviewRatingTile extends StatefulWidget {
  final CustomerReview review;
  const ReviewRatingTile({super.key, required this.review});

  @override
  State<ReviewRatingTile> createState() => _ReviewRatingTileState();
}

class _ReviewRatingTileState extends State<ReviewRatingTile> {
  bool _isReplyExpanded = false;

  @override
  Widget build(BuildContext context) {
    final CustomerReview review = widget.review;
    final String name = review.customer?.firstName.trim() ?? '';
    final String displayName = name.isEmpty ? 'customer_not_available'.tr : name;
    final String? reviewedAt = review.updatedAt ?? review.createdAt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ReviewerAvatar(imageUrl: review.customer?.imageFullUrl ?? '', name: displayName),
              Gaps.horizontalGapOf(Dimensions.padding10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: context.subHeading.defaultSize.medium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if((reviewedAt ?? '').isNotEmpty) ...[
                      Gaps.verticalGapOf(Dimensions.padding2),
                      Text(
                        DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(reviewedAt!)),
                        style: context.body.small,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.horizontalGapOf(Dimensions.padding10),
              _RatingChip(label: review.ratingLabel),
            ],
          ),

          if(review.reviewComment.isNotEmpty) ...[
            Gaps.verticalGapOf(Dimensions.padding10),
            _ExpandableReviewComment(comment: review.reviewComment),
          ],

          if(review.hasReply) ...[
            Gaps.verticalGapOf(Dimensions.padding10),
            if(_isReplyExpanded) ...[
              _ProviderReplyCard(reply: review.reviewReply),
              Gaps.verticalGapOf(Dimensions.padding10),
            ],
            Center(
              child: InkWell(
                onTap: () => setState(() => _isReplyExpanded = !_isReplyExpanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isReplyExpanded ? 'hide_reply'.tr : 'view_reply'.tr,
                      style: context.subHeading.small.medium.overrideWith(color: Colors.blueAccent),
                    ),
                    Gaps.horizontalGapOf(Dimensions.padding4),
                    _ExpandChevron(isExpanded: _isReplyExpanded, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandableReviewComment extends StatefulWidget {
  final String comment;
  const _ExpandableReviewComment({required this.comment});

  @override
  State<_ExpandableReviewComment> createState() => _ExpandableReviewCommentState();
}

class _ExpandableReviewCommentState extends State<_ExpandableReviewComment> {
  static const int _collapsedMaxLines = 1;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = context.body.small;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isOverflowing = _isOverflowing(
          style: style,
          maxWidth: constraints.maxWidth - _ExpandChevron.size - Dimensions.padding8,
        );

        final Text comment = Text(
          widget.comment,
          style: style,
          maxLines: _isExpanded ? null : _collapsedMaxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        );

        if(!isOverflowing){
          return comment;
        }

        return InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: comment),
              Gaps.horizontalGapOf(Dimensions.padding8),
              _ExpandChevron(isExpanded: _isExpanded, color: Theme.of(context).hintColor),
            ],
          ),
        );
      },
    );
  }

  bool _isOverflowing({required TextStyle style, required double maxWidth}) {
    if(maxWidth <= 0){
      return false;
    }

    final TextPainter painter = TextPainter(
      text: TextSpan(text: widget.comment, style: DefaultTextStyle.of(context).style.merge(style)),
      maxLines: _collapsedMaxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    final bool didExceedMaxLines = painter.didExceedMaxLines;
    painter.dispose();
    return didExceedMaxLines;
  }
}

class _ReviewerAvatar extends StatelessWidget {
  static const double _size = 36;

  final String imageUrl;
  final String name;
  const _ReviewerAvatar({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    if(imageUrl.isNotEmpty){
      return ClipRRect(
        borderRadius: BorderRadius.circular(_size / 2),
        child: CustomImage(image: imageUrl, height: _size, width: _size, fit: BoxFit.cover, placeholder: Images.userPlaceHolder),
      );
    }

    return CircleAvatar(
      radius: _size / 2,
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.12),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: context.heading.defaultSize.strong.overrideWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final String label;
  const _RatingChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(Dimensions.padding4),
        decoration: BoxDecoration(
          color: _kStarColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(Dimensions.radius4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 16, color: _kStarColor),
            Gaps.horizontalGapOf(Dimensions.padding4),
            Text(label, style: context.subHeading.small.medium),
          ],
        ),
      ),
    );
  }
}

class _ExpandChevron extends StatelessWidget {
  static const double size = 16;

  final bool isExpanded;
  final Color color;
  const _ExpandChevron({required this.isExpanded, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: SvgPicture.asset(
        Images.chevronDownArrowIcon,
        width: size, height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

class _ProviderReplyCard extends StatelessWidget {
  final ReviewReply? reply;
  const _ProviderReplyCard({required this.reply});

  @override
  Widget build(BuildContext context) {
    final String? repliedAt = reply?.updatedAt ?? reply?.createdAt;

    return Container(
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
              if((repliedAt ?? '').isNotEmpty)
                Text(
                  DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(repliedAt!)),
                  style: context.body.small,
                  textDirection: TextDirection.ltr,
                ),
            ],
          ),
          Gaps.verticalGapOf(Dimensions.padding6),
          Text(reply?.reply?.capitalizeFirst ?? '', style: context.body.small, textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
