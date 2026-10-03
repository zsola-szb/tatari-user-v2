import 'package:tatarigigs_user/util/core_export.dart';

class ReferShareIcon extends StatelessWidget {
  final String assetIcon;
  final double? height;
  final double? weight;
  final Function() onTap;

  const ReferShareIcon({super.key, required this.assetIcon, required this.onTap, this.height, this.weight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      onTap: onTap,
      child: Image.asset(assetIcon, height: height ?? 40, width: weight ?? 40),
    );
  }
}
