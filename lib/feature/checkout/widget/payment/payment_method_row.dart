import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethodRow extends StatelessWidget {
  final String label;
  final String? assetIcon;
  final String? networkIcon;
  final double? amount;
  final Widget? trailing;

  const PaymentMethodRow({
    super.key,
    required this.label,
    this.assetIcon,
    this.networkIcon,
    this.amount,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final double? value = amount;

    return Row(
      children: <Widget>[
        Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(Dimensions.radius6),
          ),
          child: _PaymentMethodIcon(assetIcon: assetIcon, networkIcon: networkIcon),
        ),
        const SizedBox(width: Dimensions.padding16),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.subHeading.defaultSize.medium,
          ),
        ),
        if (value != null)
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              PriceConverter.convertPrice(value),
              style: context.subHeading.defaultSize.medium,
            ),
          ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: Dimensions.padding10),
          trailing!,
        ],
      ],
    );
  }

}

class _PaymentMethodIcon extends StatelessWidget {
  final String? assetIcon;
  final String? networkIcon;

  const _PaymentMethodIcon({this.assetIcon, this.networkIcon});

  @override
  Widget build(BuildContext context) {
    final String? network = networkIcon;
    if (network != null && network.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius4),
        child: CustomImage(image: network, height: 20, width: 20, fit: BoxFit.contain),
      );
    }
    final String asset = assetIcon ?? Images.payAfterService;
    final Color tint = context.customThemeColors.secondaryTextColor;

    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(
        asset,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      );
    }
    return Image.asset(asset, height: 20, width: 20, color: tint);
  }
}
