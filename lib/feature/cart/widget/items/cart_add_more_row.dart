import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartAddMoreRow extends StatelessWidget {
  final VoidCallback onTap;

  const CartAddMoreRow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding4),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add_circle_outline_rounded,
              size: 20,
              color: context.customThemeColors.textColor,
            ),
            const SizedBox(width: Dimensions.padding10),
            Text('add_more_service'.tr, style: context.heading.defaultSize),
          ],
        ),
      ),
    );
  }
}
