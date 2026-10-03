import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/search/widget/search_init_content_section.dart';
import 'package:tatarigigs_user/feature/search/widget/search_suggestions_section.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchInitScreen extends StatelessWidget {
  const SearchInitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      onPopInvoked: (){
        Get.find<AllSearchController>().clearSearchController();
      },
      child: Scaffold(
        appBar: SearchAppBar(
          autofocus: true,
          onChanged: (text){
            Get.find<AllSearchController>().showSuffixIcon(context, text);
            if(text.trim().isNotEmpty){
              Get.find<AllSearchController>().getSearchSuggestion(text);
            }
          },
          onSubmit: (text) => Get.toNamed(RouteHelper.getSearchResultRoute(queryText: text)),
        ),
        body: GetBuilder<AllSearchController>(builder: (searchController){
          final String query = searchController.searchController.text.trim();
          final bool hasQuery = query.isNotEmpty;

          return RefreshIndicator(
            onRefresh: () => hasQuery
                ? searchController.getSearchSuggestion(query)
                : searchController.refreshSearchInitContent(),
            child: hasQuery ? const SearchSuggestionsSection() : FooterBaseView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: const SearchInitContentSection(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
