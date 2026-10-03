import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/feature/search/model/search_suggestion_model.dart';
import 'package:tatarigigs_user/feature/search/widget/suggestion_type_icon.dart';
import 'package:get/get.dart';

class RealTimeSearchSuggestion extends StatelessWidget {
  final List<SearchSuggestion>  suggestionList;
  const RealTimeSearchSuggestion({super.key, required this.suggestionList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final String query = searchController.searchController.text.trim();

      return ListView.separated(
        itemBuilder: (context, index) => SearchSuggestionTile(suggestion: suggestionList[index], query: query),
        itemCount: suggestionList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: Dimensions.padding4);
        },
      );
    });
  }
}

class SearchSuggestionTile extends StatelessWidget {
  final SearchSuggestion suggestion;
  final String query;
  const SearchSuggestionTile({super.key, required this.suggestion, required this.query});

  void _openSuggestion(BuildContext context){
    FocusScope.of(context).unfocus();
    Get.find<AllSearchController>().openSuggestion(suggestion);
  }

  List<TextSpan> _titleSpans(BuildContext context){
    final String name = suggestion.name ?? '';
    final int startIndex = query.isEmpty ? -1 : name.toLowerCase().indexOf(query.toLowerCase());

    if(startIndex < 0){
      return <TextSpan>[TextSpan(text: name, style: context.body.defaultSize)];
    }

    final String prefix = name.substring(0, startIndex);
    final String suffix = name.substring(startIndex + query.length);

    return <TextSpan>[
      TextSpan(text: prefix, style: context.body.defaultSize),
      TextSpan(text: prefix.isEmpty ? query.capitalizeFirst : query, style: context.heading.defaultSize),
      TextSpan(text: suffix, style: context.body.defaultSize),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.zero,
      leading: SuggestionTypeIcon(type: suggestion.type),
      title: RichText(
        text: TextSpan(
          style: context.subHeading.defaultSize.overrideWith(color: context.customThemeColors.secondaryTextColor),
          children: _titleSpans(context),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _openSuggestion(context),
    );
  }
}
