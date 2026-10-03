import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ColumnText extends StatelessWidget {
  final String accountAgo;
  final String amount;
  final String title;
   const ColumnText({super.key,required this.title,required this.amount,  this.accountAgo =''}) ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .40,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              amount,
              style: context.heading.large,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: Dimensions.padding4),

            Text(
              title,
              textAlign: TextAlign.center,
              style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
