import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AppliedCouponTicket extends StatelessWidget {
  static const double _stubHeight = 60;
  static const double _perforationBand = 20;
  static const double _notchRadius = 10;
  static const double _cornerRadius = Dimensions.radius16;
  static const double _actionHeight = 40;
  final String code;
  final CouponModel? coupon;
  final double discountAmount;
  final bool isRemoving;
  final VoidCallback? onRemove;

  const AppliedCouponTicket({
    super.key,
    required this.code,
    required this.discountAmount,
    this.coupon,
    this.isRemoving = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Discount? discount = coupon?.discount;
    final String title = discount?.discountTitle?.isNotEmpty == true ? discount!.discountTitle! : 'coupon_applied'.tr;
    final String? validTill = discount?.endDate;

    return ClipPath(
      clipper: const _TicketClipper(
        notchRadius: _notchRadius,
        cornerRadius: _cornerRadius,
        notchOffsetFromBottom: _stubHeight + _perforationBand / 2,
      ),
      child: ColoredBox(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding16, Dimensions.padding16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.heading.large,
                        ),
                        if (validTill != null && validTill.isNotEmpty) ...<Widget>[
                          const SizedBox(height: Dimensions.padding4),
                          Text('${'valid_till'.tr}: $validTill',
                            style: context.body.small,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding10),
                  Text(
                    _discountLabel(discount),
                    style: context.heading.overLarge,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: _perforationBand,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _notchRadius + Dimensions.padding4),
                  child: CustomDivider(
                    height: 5,
                    dashWidth: 7,
                    color: Theme.of(context).cardColor
                  ),
                ),
              ),
            ),

            SizedBox(
              height: _stubHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding10, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.heading.overLarge,
                      ),
                    ),
                    const SizedBox(width: Dimensions.padding10),
                    CustomButton(
                      buttonText: 'cancel'.tr,
                      width: 110,
                      height: _actionHeight,
                      radius: Dimensions.radius8,
                      fontSize: Dimensions.fontSizeDefault,
                      backgroundColor: context.customThemeColors.error,
                      isLoading: isRemoving,
                      onPressed: onRemove,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _discountLabel(Discount? discount) {
    final double? amount = discount?.discountAmount;
    if (amount == null || amount <= 0) {
      return '${PriceConverter.convertPrice(discountAmount)} ${'off'.tr}';
    }
    if (discount?.discountAmountType == 'percent') {
      final String value = amount == amount.roundToDouble() ? amount.toInt().toString() : '$amount';
      return '$value% ${'off'.tr}';
    }
    return '${PriceConverter.convertPrice(amount)} ${'off'.tr}';
  }
}

class _TicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double cornerRadius;
  final double notchOffsetFromBottom;

  const _TicketClipper({
    required this.notchRadius,
    required this.cornerRadius,
    required this.notchOffsetFromBottom,
  });

  @override
  Path getClip(Size size) {
    final double notchY = size.height - notchOffsetFromBottom;

    final Path body = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(cornerRadius),
        ),
      );

    final Path notches = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, notchY), radius: notchRadius))
      ..addOval(Rect.fromCircle(center: Offset(size.width, notchY), radius: notchRadius));

    return Path.combine(PathOperation.difference, body, notches);
  }

  @override
  bool shouldReclip(_TicketClipper oldClipper) =>
      oldClipper.notchRadius != notchRadius ||
      oldClipper.cornerRadius != cornerRadius ||
      oldClipper.notchOffsetFromBottom != notchOffsetFromBottom;
}
