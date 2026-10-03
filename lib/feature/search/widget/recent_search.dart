import 'package:tatarigigs_user/feature/search/model/search_suggestion_model.dart';
import 'package:tatarigigs_user/feature/search/widget/suggestion_type_icon.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final List<SearchSuggestion> historyList = searchController.historyList ?? <SearchSuggestion>[];

      return historyList.isNotEmpty ?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('recent_search'.tr,style: context.heading.extraLarge.strong),

          InkWell(
            onTap: () =>  searchController.removeHistory(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10, horizontal: Dimensions.padding8),
              child: Text('clear_all'.tr, style: context.subHeading.small.overrideWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: AppWeight.medium,
              )),
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.padding6,),

        Column(children: [for (int index = 0; index < historyList.length; index++)
          RecentSearchTile(suggestion: historyList[index], index: index),
        ]),

        ]),
      ): const SizedBox();
      }
    );
  }
}

class RecentSearchTile extends StatelessWidget {
  final SearchSuggestion suggestion;
  final int index;
  const RecentSearchTile({super.key, required this.suggestion, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Get.find<AllSearchController>().openSuggestion(suggestion);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Row(children: [
          SuggestionTypeIcon(type: suggestion.type, size: 20),
          const SizedBox(width: Dimensions.padding12,),
          Expanded(
            child: Text(suggestion.name ?? '',
              style: context.subHeading.defaultSize,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: Dimensions.padding10,),
          InkWell(
            onTap: () => Get.find<AllSearchController>().removeHistory(index: index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding8),
              child: Icon(Icons.close, size : 18, color: Theme.of(context).hintColor,),
            ),
          )
        ]),
      ),
    );
  }
}
