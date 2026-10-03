import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutRadioIndicator extends StatelessWidget {
  final bool isSelected;
  final double size;

  const CheckoutRadioIndicator({super.key, required this.isSelected, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? primary : Theme.of(context).hintColor.withValues(alpha: 0.30),
          width: 2,
        ),
      ),
      child: isSelected
          ? Container(
              height: size / 2,
              width: size / 2,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
            ) : null,
    );
  }
}
