import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final bool isShowSeeAllButton;
  const TitleWidget({super.key, required this.title, this.onTap, required this.isShowSeeAllButton});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Flexible(
        child: Text(title!.tr, style: context.heading.extraLarge.overrideWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .8),
        ),maxLines: 1,overflow: TextOverflow.ellipsis,),
      ),
      const SizedBox(width: Dimensions.padding10,),
      (isShowSeeAllButton) ? SeeAllButton(
        onTap: onTap) : const SizedBox(),
    ]);
  }
}
