import 'package:tatarigigs_user/feature/search/widget/popular_categories_init_section.dart';
import 'package:tatarigigs_user/feature/search/widget/popular_services_init_section.dart';
import 'package:tatarigigs_user/feature/search/widget/trending_search_section.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class SearchInitContentSection extends StatelessWidget {
  const SearchInitContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RecentSearch(),
          GetBuilder<AllSearchController>(
            builder: (searchController) {
              final bool hasRecentSearch = searchController.historyList != null && searchController.historyList!.isNotEmpty;
              return hasRecentSearch ? const SizedBox(height: Dimensions.padding20) : const SizedBox();
            },
          ),
          const TrendingSearchSection(),
          const SizedBox(height: Dimensions.padding20),
          const PopularCategoriesInitSection(),
          const SizedBox(height: Dimensions.padding20),
          const PopularServicesInitSection(),
          const SizedBox(height: Dimensions.padding20),
        ],
      ),
    );
  }
}
