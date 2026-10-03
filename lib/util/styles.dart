import 'package:tatarigigs_user/feature/splash/controller/theme_controller.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/app_constants.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<BoxShadow>? searchBoxShadow =  [ BoxShadow(
  offset: Offset(0,4),
  color: Colors.black.withValues(alpha: 0.05) ,
  blurRadius: 14,
  spreadRadius: 0,
)];

List<BoxShadow> cardShadow = [ const BoxShadow(
  offset: Offset(0,2),
  spreadRadius: 2,
  blurRadius: 2,
  color: Color(0x20A8A8EA),
)];

List<BoxShadow>? lightShadow = Get.isDarkMode? [ const BoxShadow()]:[
  const BoxShadow(
    offset: Offset(0, 1),
    blurRadius: 3,
    spreadRadius: 1,
    color: Color(0x20D6D8E6),
  )];

List<BoxShadow>? shadow = Get.find<ThemeController>().darkTheme ? [const BoxShadow()] : [BoxShadow(
    offset: const Offset(0,3),
    color: Colors.grey[100]!, blurRadius: 1, spreadRadius: 2)];

Decoration shimmerDecorationGreySoft = BoxDecoration(
  color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius6)),
);

Decoration shimmerDecorationGreyHard = BoxDecoration(
  color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 400],
  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius6)),
);


/// Font weights, named as in the design system.
abstract class AppWeight {
  static const FontWeight regular  = FontWeight.w400;
  static const FontWeight medium   = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight strong   = FontWeight.w700;
}


class Tracking {
  final double extraSmall;
  final double small;
  final double defaultSize;
  final double large;
  final double extraLarge;
  final double overLarge;
  final double extraOverLarge;

  const Tracking({
    required this.extraSmall,
    required this.small,
    required this.defaultSize,
    required this.large,
    required this.extraLarge,
    required this.overLarge,
    required this.extraOverLarge,
  });

  /// The same tracking at every size in the scale.
  const Tracking.uniform(double percent)
      : extraSmall = percent,
        small = percent,
        defaultSize = percent,
        large = percent,
        extraLarge = percent,
        overLarge = percent,
        extraOverLarge = percent;
}

/// Tracking tightens as headings grow: -2% up to Default, -3% at Large,
/// -4% from Extra Large upward.
const Tracking _headingTracking = Tracking(
  extraSmall: -0.02,
  small: -0.02,
  defaultSize: -0.02,
  large: -0.03,
  extraLarge: -0.04,
  overLarge: -0.04,
  extraOverLarge: -0.04,
);

/// Sub-headings track at -2% across the whole scale.
const Tracking _subHeadingTracking = Tracking.uniform(-0.02);

/// Body copy uses the font's natural tracking.
const Tracking _bodyTracking = Tracking.uniform(0);

/// One text family — a fixed weight/colour/line-height/tracking, and the size scale.
///
/// Every getter returns a plain [TextStyle], so `.copyWith(...)` and the
/// [TextStyleWeight] modifiers both work on the result.
class TextScale {
  /// Default weight for this family. Override per call with [TextStyleWeight].
  final FontWeight weight;
  /// Line height multiplier. 1.1 matches the design system's `/110`.
  final double height;
  /// Letter spacing per size, as a fraction of the font size.
  final Tracking tracking;
  /// Resolved text colour, or null when the call site supplies it.
  final Color? color;

  const TextScale._({
    required this.weight,
    required this.height,
    required this.tracking,
    this.color,
  });

  /// 10.0 Font Size
  TextStyle get extraSmall => _sized(Dimensions.fontSizeExtraSmall, tracking.extraSmall);
  /// 12.0 Font Size
  TextStyle get small => _sized(Dimensions.fontSizeSmall, tracking.small);
  /// 14.0 Font Size
  TextStyle get defaultSize => _sized(Dimensions.fontSizeDefault, tracking.defaultSize);
  /// 16.0 Font Size
  TextStyle get large => _sized(Dimensions.fontSizeLarge, tracking.large);
  /// 18.0 Font Size
  TextStyle get extraLarge => _sized(Dimensions.fontSizeExtraLarge, tracking.extraLarge);
  /// 20.0 Font Size
  TextStyle get overLarge => _sized(Dimensions.overLarge, tracking.overLarge);
  /// 24.0 Font Size
  TextStyle get extraOverLarge => _sized(Dimensions.extraOverLarge, tracking.extraOverLarge);

  TextStyle _sized(double size, double trackingPercent) => TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontWeight: weight,
    fontSize: size,
    height: height,
    letterSpacing: size * trackingPercent,
    color: color,
  );
}

///   context.heading.large.medium
///   sansRegular.strong
extension TextStyleWeight on TextStyle {
  /// Weight Regular (400)
  TextStyle get regular => copyWith(fontWeight: AppWeight.regular);
  /// Weight Medium (500)
  TextStyle get medium => copyWith(fontWeight: AppWeight.medium);
  /// Weight Semibold (600)
  TextStyle get semiBold => copyWith(fontWeight: AppWeight.semiBold);
  /// Weight Bold (700)
  TextStyle get strong => copyWith(fontWeight: AppWeight.strong);
}

///   context.subHeading.extraLarge.overrideWith(
///     fontWeight: FontWeight.w600,
///     color: Theme.of(context).primaryColor,
///   )
extension TextStyleOverride on TextStyle {
  TextStyle overrideWith({Color? color, FontWeight? fontWeight}) =>
      copyWith(color: color, fontWeight: fontWeight);
}

/// Titles and section headers. Strong (700), tracking -2%/-3%/-4% by size.
/// No colour — pass one at the call site, or use `context.heading` instead.
const TextScale heading = TextScale._(
  weight: AppWeight.strong,
  height: Dimensions.fontHeightSmall,
  tracking: _headingTracking,
);

/// Secondary titles and card headings. Regular (400), tracking -2%. No colour.
const TextScale subHeading = TextScale._(
  weight: AppWeight.regular,
  height: Dimensions.fontHeightDefault,
  tracking: _subHeadingTracking,
);

/// Body and descriptive copy. Regular (400), no tracking. No colour.
const TextScale body = TextScale._(
  weight: AppWeight.regular,
  height: Dimensions.fontHeightMedium,
  tracking: _bodyTracking,
);

/// Theme-aware variants of the three families. Each resolves its colour from
/// the active [ThemeData], so they stay correct in both light and dark.
extension AppTextStyle on BuildContext {

  /// [heading], in the theme's default text colour.
  TextScale get heading => TextScale._(
    weight: AppWeight.strong,
    height: Dimensions.fontHeightSmall,
    tracking: _headingTracking,
    color: Get.context!.customThemeColors.textColor,
  );

  /// [subHeading], in the theme's default text colour.
  TextScale get subHeading => TextScale._(
    weight: AppWeight.regular,
    height: Dimensions.fontHeightDefault,
    tracking: _subHeadingTracking,
    color: Get.context!.customThemeColors.textColor,
  );

  /// [body], in the theme's muted/secondary text colour.
  TextScale get body => TextScale._(
    weight: AppWeight.regular,
    height: Dimensions.fontHeightMedium,
    tracking: _bodyTracking,
    color: Get.context!.customThemeColors.secondaryTextColor
  );
}