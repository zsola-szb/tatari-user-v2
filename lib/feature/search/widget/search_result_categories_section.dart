import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchResultCategoriesSection extends StatelessWidget {
  const SearchResultCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      final List<CategoriesList>? categoryList = searchController.searchResultModel?.data?.categories;

      if(categoryList == null || categoryList.isEmpty){
        return const SizedBox();
      }

      return Container(
        width: double.infinity,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.padding24),
            Text('popular_categories'.tr, style: heading.large.strong),
            const SizedBox(height: Dimensions.padding16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [for (final CategoriesList category in categoryList)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: Dimensions.padding10),
                    child: InkWell(
                      onTap: (){
                        Get.find<AllSearchController>().populatedSearchController(category.name ?? '');
                        Get.find<AllSearchController>().searchData(query: category.name ?? '', offset: 1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                          border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(Dimensions.padding8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radius12)),
                              color: context.customThemeColors.secondaryBackGroundColor,
                            ),
                            child: Center(child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius12),
                              child: CustomImage(

                                image: category.logo ?? "",
                                fit: BoxFit.cover,
                              ),
                            )),
                          ),
                          const SizedBox(width: Dimensions.padding10),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: Text(category.name ?? '',
                                style: context.heading.defaultSize,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text('${category.totalServices ?? 0} ${'services_available'.tr}', style: context.body.small),
                          ]),
                        ]),
                      ),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: Dimensions.padding24),

          ]),
        ),
      );
    });
  }
}
