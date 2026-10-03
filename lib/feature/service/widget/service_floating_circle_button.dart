import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceFloatingCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const ServiceFloatingCircleButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.customThemeColors.backGroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius8)),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius8)),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
