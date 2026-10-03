import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SuggestServiceScreen extends StatefulWidget {
  const SuggestServiceScreen({super.key}) ;

  @override
  State<SuggestServiceScreen> createState() => _SuggestServiceScreenState();
}

class _SuggestServiceScreenState extends State<SuggestServiceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(false);
    Get.find<SuggestServiceController>().getSuggestedServiceList(1, reload: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget (
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: "suggest_new_service".tr),
        floatingActionButton: GetBuilder<SuggestServiceController>(builder: (suggestServiceController){
          return suggestServiceController.suggestedServiceModel?.hasSuggestion != 0 ? FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => Get.toNamed(RouteHelper.getSuggestServiceFormRoute()),
            child: const Icon(Icons.add, color: Colors.white),
          ) : const SizedBox();
        }),
        body: GetBuilder<SuggestServiceController>(builder: (suggestServiceController){
          final bool isLoaded = suggestServiceController.suggestedServiceModel != null;
          final bool isEmpty = suggestServiceController.suggestedServiceModel?.hasSuggestion == 0;
          return SizedBox(
            width: Dimensions.webMaxWidth,
            child: !isLoaded ?
            SizedBox(height: Get.height * 0.85, child: const Center(child: CircularProgressIndicator())) :
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SuggestServicePromptCard(showButton: isEmpty),

                if(!isEmpty) ...[
                  const SizedBox(height: Dimensions.padding24),

                  Row(children: [
                    Text('${'service_request'.tr} ', style: context.heading.large),
                    Directionality(textDirection: TextDirection.ltr,
                      child: Text('(${suggestServiceController.suggestedServiceModel?.totalSize ?? 0})', style: context.heading.large),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.padding8),

                  const SuggestServiceStatusTabBar(),
                  const SizedBox(height: Dimensions.padding16),

                  PaginatedListView(
                    scrollController: _scrollController,
                    totalSize: suggestServiceController.suggestedServiceModel?.totalSize,
                    offset: suggestServiceController.suggestedServiceModel?.currentPage,
                    onPaginate: (int offset) async => await suggestServiceController.getSuggestedServiceList(offset),
                    itemView: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: suggestServiceController.groupedDateLabels.map((label) {
                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SuggestServiceDateDivider(label: label),
                          ...suggestServiceController.servicesForDateGroup(label).map(
                            (service) => SuggestServiceItemView(suggestedService: service),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ]),
            ),
          );
        }),
      ),
    );
  }
}
