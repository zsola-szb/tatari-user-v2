import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AllServiceListView extends StatelessWidget {
  final String categorySlug;
  final ScrollController scrollController;

  const AllServiceListView({super.key, required this.categorySlug, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      initState: (_) => Get.find<ServiceController>().getSubCategoryBasedServiceList(categorySlug, offset: 1),
      builder: (ServiceController serviceController) => FooterBaseView(
        scrollController: scrollController,
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: PaginatedListView(
            scrollController: scrollController,
            totalSize: serviceController.subcategoryBasedServiceContent?.total,
            offset: serviceController.subcategoryBasedServiceContent?.currentPage,
            onPaginate: (int offset) => serviceController.getSubCategoryBasedServiceList(categorySlug, offset: offset),
            itemView: ServiceViewVertical(
              service: serviceController.subCategoryBasedServiceList,
              padding: const EdgeInsets.all(Dimensions.padding10),
              type: 'others',
              noDataType: NoDataType.home,
            ),
          ),
        ),
      ),
    );
  }
}
