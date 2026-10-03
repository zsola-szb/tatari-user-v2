import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceShimmer extends StatelessWidget {
  final bool? isEnabled;
  final bool? hasDivider;
  const ServiceShimmer({super.key, required this.isEnabled, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        boxShadow:  Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnabled!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Dimensions.padding10,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
            ),
            const SizedBox(height: Dimensions.padding10,),
            Container(height: 15, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius6),
              ),
            ),
            const SizedBox(height: Dimensions.padding10),
            Container(
              height:  10, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius6),
              ),
              margin: const EdgeInsets.only(right: Dimensions.padding20),
            ),
            const SizedBox(height: Dimensions.padding6),
            Container(
              height:  10, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radius6),
              ),
              margin: const EdgeInsets.only(right: Dimensions.padding20 * 2),
            ),
            const SizedBox(height: Dimensions.padding6),
            const SizedBox(height: Dimensions.padding6),
            Row(children: [
              Container(height:10, width: 30, color:  Theme.of(context).shadowColor),
              const SizedBox(width: Dimensions.padding6),
              Container(height: 10, width: 20, color: Theme.of(context).shadowColor),
            ]),
            const SizedBox(height: Dimensions.padding10,),
          ],
        ),
      ),
    );
  }
}
