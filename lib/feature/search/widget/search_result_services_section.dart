import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class SearchResultServicesSection extends StatelessWidget {
  const SearchResultServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){

      if(searchController.showAllServices){
        return _ServicesCard(child: _ServicesVerticalList(serviceList: searchController.viewAllServiceList));
      }

      final List<Service>? serviceList = searchController.searchResultModel?.data?.services;

      if(serviceList == null || serviceList.isEmpty){
        return const SizedBox();
      }

      return _ServicesCard(
        child: _ServicesHorizontalList(serviceList: serviceList, hasMoreServices: searchController.hasMoreServices),
      );
    });
  }
}

class _ServicesCard extends StatelessWidget {
  final Widget child;
  const _ServicesCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          const SizedBox(height: Dimensions.padding20),
          Text('services'.tr, style: heading.large.strong),
          const SizedBox(height: Dimensions.padding16),

          child,
          const SizedBox(height: Dimensions.padding24),

        ]),
      ),
    );
  }
}

class _ServicesHorizontalList extends StatelessWidget {
  final List<Service> serviceList;
  final bool hasMoreServices;
  const _ServicesHorizontalList({required this.serviceList, required this.hasMoreServices});

  @override
  Widget build(BuildContext context) {
    final double itemWidth = ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.3;

    return SizedBox(
      height: ServiceWidgetVertical.heightFor(context, itemWidth),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hasMoreServices ? serviceList.length + 1 : serviceList.length,
        itemBuilder: (context, index){
          if(index == serviceList.length){
            return SeeAllCircularListItem(
              onTap: () => Get.find<AllSearchController>().showViewAllServices(),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.padding10 + 2),
            child: SizedBox(
              width: itemWidth,
              child: ServiceWidgetVertical(service: serviceList[index], fromType: '', fromPage: 'search_page'),
            ),
          );
        },
      ),
    );
  }
}

class _ServicesVerticalList extends StatelessWidget {
  final List<Service>? serviceList;
  const _ServicesVerticalList({required this.serviceList});

  static const int _crossAxisCount = 2;
  static const int _shimmerItemCount = 6;

  @override
  Widget build(BuildContext context) {
    final List<Service>? services = serviceList;

    if(services != null && services.isEmpty){
      return const ServiceNotAvailableScreen(fromPage: "search_page");
    }

    return LayoutBuilder(builder: (context, constraints){
      final double itemWidth = (constraints.maxWidth - (Dimensions.padding16 * (_crossAxisCount - 1))) / _crossAxisCount;

      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.padding16,
          mainAxisSpacing: Dimensions.padding16,
          mainAxisExtent: ServiceWidgetVertical.heightFor(context, itemWidth),
          crossAxisCount: _crossAxisCount,
        ),
        itemCount: services?.length ?? _shimmerItemCount,
        itemBuilder: (context, index){
          if(services == null){
            return const ServiceShimmer(isEnabled: true, hasDivider: false);
          }

          return ServiceWidgetVertical(service: services[index], fromType: '', fromPage: 'search_page');
        },
      );
    });
  }
}
