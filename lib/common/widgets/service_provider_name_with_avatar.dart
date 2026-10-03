import 'dart:math' as math;
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceProviderNameWithAvatar extends StatelessWidget {
  final String? providerName;
  final String? providerImage;
  final double avatarSize;
  final double bottomSpacing;

  static const double defaultAvatarSize = 20;

  const ServiceProviderNameWithAvatar({
    super.key,
    required this.providerName,
    required this.providerImage,
    this.avatarSize = defaultAvatarSize,
    this.bottomSpacing = Dimensions.padding6,
  });


  static double heightFor(BuildContext context, {
    double avatarSize = defaultAvatarSize,
    double bottomSpacing = Dimensions.padding6,
  }) {
    if (!BusinessModelHelper.isOpenMarket) {
      return 0;
    }
    final TextStyle style = context.subHeading.small;
    final double lineHeight = MediaQuery.textScalerOf(context).scale(style.fontSize ?? 0) * (style.height ?? 1);
    return math.max(avatarSize, lineHeight) + bottomSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final String name = providerName?.trim() ?? '';
    if (name.isEmpty || !BusinessModelHelper.isOpenMarket) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ClipOval(
          child: CustomImage(
            image: providerImage ?? '',
            height: avatarSize,
            width: avatarSize,
            placeholder: Images.providerImage,
          ),
        ),
        const SizedBox(width: Dimensions.padding6),

        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.subHeading.small.overrideWith(
              color: context.customThemeColors.secondaryTextColor,
              fontWeight: AppWeight.semiBold,
            ),
          ),
        ),
      ]),
    );
  }
}
