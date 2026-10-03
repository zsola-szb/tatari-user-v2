import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ConversationSearchWidget extends StatelessWidget {
  const ConversationSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (ConversationController conversationController) {
        final OutlineInputBorder border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: BorderSide(color: context.customThemeColors.secondaryBackGroundColor),
        );

        return TextField(
          controller: conversationController.searchController,
          style: context.subHeading.defaultSize,
          cursorColor: Theme.of(context).colorScheme.primary,
          autofocus: false,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.search,
          onChanged: (String text) => conversationController.showSuffixIcon(context, text),
          onSubmitted: (String text) {
            if (text.isNotEmpty) {
              conversationController.getSearchedChannelList(query: text);
            }
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
            isDense: true,
            filled: true,
            fillColor: context.customThemeColors.secondaryBackGroundColor.withValues(alpha: Get.isDarkMode ? 0.1 : 1),
            border: border,
            errorBorder: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
            ),
            hintText: 'search'.tr,
            hintStyle: context.body.defaultSize,
            prefixIcon: Icon(Icons.search, size: 20, color: Theme.of(context).hintColor),
            suffixIcon: conversationController.isActiveSuffixIcon
                ? IconButton(
                    onPressed: () {
                      if (conversationController.searchController.text.trim().isNotEmpty) {
                        conversationController.clearSearchController();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(Icons.cancel_outlined, size: 18, color: Theme.of(context).hintColor),
                  )
                : null,
          ),
        );
      },
    );
  }
}
