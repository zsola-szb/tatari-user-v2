import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool showFilterButton;
  final VoidCallback? onFilterTap;
  final VoidCallback? onBackTap;
  final Function(String text)? onChanged;
  final Function(String text)? onSubmit;
  final VoidCallback? onClear;
  final bool autofocus;
  final String? hintText;

  const SearchAppBar({
    super.key,
    this.backButton = true,
    this.showFilterButton = false,
    this.onFilterTap,
    this.onBackTap,
    this.onChanged,
    this.onSubmit,
    this.onClear,
    this.autofocus = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.customThemeColors.backGroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: Dimensions.searchbarSize + (Dimensions.padding8 * 2),
      titleSpacing: Dimensions.padding4,
      leadingWidth: backButton ? 65 : null,
      leading: backButton ? Center(
        child: _SearchAppBarIconButton(
          icon: Icons.arrow_back,
          onTap: onBackTap ?? (){
            Get.find<AllSearchController>().clearSearchController(shouldUpdate: false);
            Navigator.pop(context);
          },
        ),
      ) : null,
      title: _SearchInputField(onChanged: onChanged, onSubmit: onSubmit, onClear: onClear, autofocus: autofocus, hintText: hintText,),
      actions: showFilterButton ? [
        Padding(
          padding: const EdgeInsets.only(right: Dimensions.padding16),
          child: Center(
            child: _SearchAppBarIconButton(icon: Icons.tune, onTap: onFilterTap),
          ),
        ),
      ] : null,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.padding8),
        child: SizedBox.shrink(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(
    Dimensions.webMaxWidth,
    Dimensions.searchbarSize + Dimensions.padding8 + Dimensions.padding16,
  );
}

class _SearchAppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _SearchAppBarIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        height: Dimensions.searchbarSize,
        width: Dimensions.searchbarSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Icon(icon, size: 20, color: context.customThemeColors.textColor),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  final String? hintText;
  const _SearchHint({this.hintText});

  @override
  Widget build(BuildContext context) {
    final String? hintText = this.hintText;

    if (hintText != null) {
      return Text(hintText, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.body.defaultSize);
    }

    return GetBuilder<CategoryController>(
      builder: (categoryController) => RollingSearchHint(words: categoryController.searchHintNames),
    );
  }
}

class _SearchInputField extends StatefulWidget {
  final Function(String text)? onChanged;
  final Function(String text)? onSubmit;
  final VoidCallback? onClear;
  final bool autofocus;
  final String? hintText;
  const _SearchInputField({this.onChanged, this.onSubmit, this.onClear, this.autofocus = false, this.hintText});

  @override
  State<_SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<_SearchInputField> {
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  void _submit(AllSearchController searchController, String text){
    final String query = text.trim();

    if(query.isEmpty){
      customSnackBar('search_text_empty_message'.tr, type: ToasterMessageType.info);
      return;
    }
    if(query.length > 255){
      customSnackBar('search_text_length_message'.tr, type: ToasterMessageType.info);
      return;
    }

    if(widget.onSubmit != null){
      widget.onSubmit!(query);
    }else{
      searchController.searchData(query: query, offset: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final TextEditingController textController = searchController.searchController;

      return Container(
        height: Dimensions.searchbarSize,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          border: Border.all(color: context.customThemeColors.secondaryBackGroundColor),
        ),
        child: Stack(children: [
          PositionedDirectional(
            start: 40, end: Dimensions.padding8, top: 0, bottom: 0,
            child: IgnorePointer(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: textController,
                builder: (context, value, child) => value.text.isEmpty ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _SearchHint(hintText: widget.hintText),
                ) : const SizedBox.shrink(),
              ),
            ),
          ),

          TextField(
            controller: textController,
            focusNode: _searchFocus,
            autofocus: widget.autofocus,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            style: context.subHeading.defaultSize,
            cursorColor: Theme.of(context).hintColor,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, size: 20, color: Theme.of(context).hintColor),
              prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 20),
              suffixIcon: searchController.isActiveSuffixIcon ? InkWell(
                onTap: (){
                  if(widget.onClear != null){
                    widget.onClear!();
                  }else{
                    searchController.clearSearchController();
                  }
                },
                child: Icon(Icons.close, size: 18, color: Theme.of(context).hintColor),
              ) : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 20),
            ),
            onChanged: (text){
              if(widget.onChanged != null){
                widget.onChanged!(text);
              }else{
                searchController.showSuffixIcon(context, text);
              }
            },
            onSubmitted: (text) => _submit(searchController, text),
          ),
        ]),
      );
    });
  }
}
