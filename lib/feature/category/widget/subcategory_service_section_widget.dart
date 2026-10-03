import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryServiceSectionWidget extends StatelessWidget {
  final CategoryModel subCategory;
  final List<Service>? services;
  final ServiceContent? content;
  final ScrollController scrollController;
  final GlobalKey<CustomShakingWidgetState> signInShakeKey;
  final Future<void> Function(int offset) onPaginate;

  const SubCategoryServiceSectionWidget({
    super.key, required this.subCategory, required this.services, required this.content,
    required this.scrollController, required this.signInShakeKey, required this.onPaginate,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).cardColor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ColoredBox(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: SubCategoryHeroCardWidget(subCategory: subCategory),
          ),
        ),
        Container(height: 8, color: context.customThemeColors.backGroundColor),

        ColoredBox(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding16, Dimensions.padding16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SubCategoryServiceCountLabelWidget(count: subCategory.serviceCount ?? 0),

              const SizedBox(height: Dimensions.padding12),

              if(services == null)
                Column(children: List.generate(3, (index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.padding6),
                  child: SizedBox(height: 240, child: ServiceShimmer(isEnabled: true, hasDivider: false)),
                )))
              else if(services!.isEmpty)
                NoDataScreen(text: 'no_services_found'.tr, type: NoDataType.service)
              else
                PaginatedListView(
                  scrollController: scrollController,
                  totalSize: content?.total,
                  offset: content?.currentPage,
                  limit: ServiceController.subCategoryTabPageSize,
                  bottomPadding: 0,
                  onPaginate: onPaginate,
                  itemView: SubCategoryServiceListWidget(services: services!, signInShakeKey: signInShakeKey),
                ),
            ]),
          ),
        ),
      ]),
    );
  }
}
