import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersSearchHeader extends StatelessWidget {
  final ScrollController scrollController;
  final ValueNotifier<bool> collapsedNotifier;

  const OffersSearchHeader({super.key, required this.scrollController, required this.collapsedNotifier});

  @override
  Widget build(BuildContext context) {
    return CollapseOnScroll(
      scrollController: scrollController,
      collapsedNotifier: collapsedNotifier,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding12),
        child: OffersSearchField(),
      ),
    );
  }
}

class OffersSearchField extends StatelessWidget {
  const OffersSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OffersController>(builder: (OffersController offersController){
      return Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: context.customThemeColors.secondaryBackGroundColor, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.padding16),
        child: Center(
          child: TextField(
            controller: offersController.searchController,
            focusNode: offersController.searchFocus,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            style: context.subHeading.defaultSize,
            cursorColor: Theme.of(context).hintColor,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
              border: InputBorder.none,
              hintText: 'search_services'.tr,
              hintStyle: context.body.defaultSize,
              prefixIcon: Image.asset(
                Images.searchIcon,
                width: 20, height: 20,
                color: context.customThemeColors.secondaryTextColor,
                colorBlendMode: BlendMode.srcIn,
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 20),
              suffixIcon: offersController.query.isEmpty ? null : InkWell(
                onTap: offersController.clearSearch,
                child: Icon(Icons.close, size: 18, color: Theme.of(context).hintColor),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 20),
            ),
            onChanged: offersController.onSearchChanged,
          ),
        ),
      );
    });
  }
}

class OffersCollapsedSearchAction extends StatelessWidget {
  final ValueNotifier<bool> collapsedNotifier;
  final VoidCallback onTap;

  const OffersCollapsedSearchAction({super.key, required this.collapsedNotifier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: collapsedNotifier,
      builder: (BuildContext context, bool collapsed, Widget? child) {
        if(!collapsed){
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(right: Dimensions.padding16),
          child: Center(
            child: CustomInkWell(
              radius: Dimensions.radius8,
              onTap: onTap,
              child: Container(
                height: 32, width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.customThemeColors.secondaryBackGroundColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius8),
                ),
                child: Icon(Icons.search, size: 18, color: context.customThemeColors.textColor),
              ),
            ),
          ),
        );
      },
    );
  }
}