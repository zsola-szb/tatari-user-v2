import 'package:tatarigigs_user/feature/booking/widget/common/booking_contact_actions.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const double _avatarSize = 40;

class BookingPartyTile extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? subtitle;
  final double? rating;
  final int? ratingCount;
  final bool isVerified;
  final String? phone;
  final VoidCallback? onChat;
  final EdgeInsetsGeometry padding;
  final Color? background;

  const BookingPartyTile({
    super.key,
    required this.name,
    this.imageUrl,
    this.subtitle,
    this.rating,
    this.ratingCount,
    this.isVerified = false,
    this.phone,
    this.onChat,
    this.padding = const EdgeInsets.all(Dimensions.padding10),
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: CustomImage(
              image: imageUrl ?? '',
              height: _avatarSize,
              width: _avatarSize,
              fit: BoxFit.cover,
              placeholder: Images.userPlaceHolder,
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        name,
                        style: context.heading.defaultSize,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...<Widget>[
                      const SizedBox(width: Dimensions.padding4),
                      Image.asset(Images.verified, height: 14, width: 14),
                    ],
                  ],
                ),
                if (rating != null || (subtitle ?? '').isNotEmpty) ...<Widget>[
                  const SizedBox(height: 2),
                  _SupportingLine(
                    subtitle: subtitle,
                    rating: rating,
                    ratingCount: ratingCount,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Dimensions.padding8),
          BookingContactActions(phone: phone, onChat: onChat),
        ],
      ),
    );
  }
}

class _SupportingLine extends StatelessWidget {
  final String? subtitle;
  final double? rating;
  final int? ratingCount;

  const _SupportingLine({this.subtitle, this.rating, this.ratingCount});

  @override
  Widget build(BuildContext context) {
    final double? value = rating;
    if (value == null) {
      return Text(
        subtitle ?? '',
        style: context.body.small,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final int count = ratingCount ?? 0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(Images.starIcon, height: 13, width: 13),
          const SizedBox(width: Dimensions.padding4),
          Text(value.toStringAsFixed(1), style: context.subHeading.small.medium),
          if (count > 0) ...<Widget>[
            const SizedBox(width: Dimensions.padding4),
            Text('($count+ ${'review'.tr})', style: context.body.small),
          ],
        ],
      ),
    );
  }
}
