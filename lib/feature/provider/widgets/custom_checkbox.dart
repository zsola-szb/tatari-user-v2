import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isTitLeftAlign;
  final bool? value;
  final String? leadingIcon;
  const CustomCheckBox({super.key, required this.title, this.onTap, this.value, this.isTitLeftAlign = true, this.leadingIcon}) ;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      if(isTitLeftAlign) Expanded(
        child: Row(children: [
          if(leadingIcon != null) ...[
            SvgPicture.asset(leadingIcon!, width: 16, height: 16, color: Get.isDarkMode ? Colors.white : Colors.black),
            const SizedBox(width: Dimensions.padding8),
          ],
          Flexible(
            child: Text(title.tr,
              style: context.subHeading.defaultSize,
              overflow: TextOverflow.ellipsis, maxLines: 1,
            ),
          ),
        ]),
      ),
      if(isTitLeftAlign) const SizedBox(width: Dimensions.padding16),

      SizedBox(width: 20.0,
        child: Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          activeColor: Theme.of(context).colorScheme.primary,
          value: value,
          onChanged: (bool? isActive) => onTap!()
        ),
      ),
      if(!isTitLeftAlign) const SizedBox(width: Dimensions.padding10),
      if(!isTitLeftAlign) Expanded(
        child: Text(title.tr,
          style: context.subHeading.defaultSize,
          overflow: TextOverflow.ellipsis, maxLines: 1,
        ),
      ),
      const SizedBox(width: Dimensions.padding10)


    ]);
  }
}
