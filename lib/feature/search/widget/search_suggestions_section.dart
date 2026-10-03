import 'package:tatarigigs_user/feature/search/widget/realtime_search_suggestion.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchSuggestionsSection extends StatelessWidget {
  const SearchSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final String query = searchController.searchController.text.trim();
      final bool hasSuggestion = searchController.searchSuggestionList.isNotEmpty;

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          hasSuggestion ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: RealTimeSearchSuggestion(suggestionList: searchController.searchSuggestionList),
          ) : Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding20),
            child: Center(child: Text('no_suggestions_found'.tr, style: context.body.defaultSize)),
          ),

          if(query.isNotEmpty) ...[
            Divider(height: 0.5, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),

            SearchForQueryTile(query: query),
          ],
        ]),
      );
    });
  }
}

class SearchForQueryTile extends StatelessWidget {
  final String query;
  const SearchForQueryTile({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        FocusScope.of(context).unfocus();
        Get.toNamed(RouteHelper.getSearchResultRoute(queryText: query));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding16),
        child: Row(children: [
          Icon(Icons.search, color: Theme.of(context).hintColor, size: 18),
          const SizedBox(width: Dimensions.padding10),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: '${'search_for'.tr} "', style: context.body.defaultSize),
                  TextSpan(text: query, style: context.heading.defaultSize),
                  TextSpan(text: '"', style: context.body.defaultSize),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
