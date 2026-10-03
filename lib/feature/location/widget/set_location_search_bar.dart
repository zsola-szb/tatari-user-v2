import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SetLocationSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        border: Border.all(
          color: context.customThemeColors.secondaryBackGroundColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 18,
            color: context.customThemeColors.textColor,
          ),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: onChanged,
              style: context.body.defaultSize.overrideWith(
                color: context.customThemeColors.textColor,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'type_your_location'.tr,
                hintStyle: context.body.defaultSize,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            CustomInkWell(
              onTap: onClear,
              child: Icon(
                Icons.clear,
                size: Dimensions.fontSizeLarge,
                color: context.customThemeColors.secondaryTextColor,
              ),
            ),
        ],
      ),
    );
  }
}
