import 'package:tatarigigs_user/feature/search/model/search_result_model.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

const double _providerCardHeight = 244;

class SearchResultProvidersSection extends StatelessWidget {
  const SearchResultProvidersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){

      if(searchController.showAllProviders){
        return _ProvidersCard(child: _ProvidersVerticalList(providerList: searchController.viewAllProviderList));
      }

      final List<Providers>? providerList = searchController.searchResultModel?.data?.providers;

      if(providerList == null || providerList.isEmpty){
        return const SizedBox();
      }

      return _ProvidersCard(
        child: _ProvidersHorizontalList(providerList: providerList, hasMoreProviders: searchController.hasMoreProviders),
      );
    });
  }
}

class _ProvidersCard extends StatelessWidget {
  final Widget child;
  const _ProvidersCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          const SizedBox(height: Dimensions.padding24),
          Text('providers'.tr, style: heading.extraLarge.strong),
          const SizedBox(height: Dimensions.padding16),

          child,
          const SizedBox(height: Dimensions.padding24),

        ]),
      ),
    );
  }
}

class _ProvidersHorizontalList extends StatelessWidget {
  final List<Providers> providerList;
  final bool hasMoreProviders;
  const _ProvidersHorizontalList({required this.providerList, required this.hasMoreProviders});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _providerCardHeight,
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: hasMoreProviders ? providerList.length + 1 : providerList.length,
        separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding10),
        itemBuilder: (context, index){
          if(index == providerList.length){
            return SeeAllCircularListItem(
              padding: EdgeInsets.zero,
              onTap: () => Get.find<AllSearchController>().showViewAllProviders(),
            );
          }
          return SizedBox(
            width: ResponsiveHelper.isTab(context) ? Get.width / 2.5 : Get.width / 1.3,
            child: _SearchProviderCard(provider: providerList[index]),
          );
        },
      ),
    );
  }
}

class _ProvidersVerticalList extends StatelessWidget {
  final List<Providers>? providerList;
  const _ProvidersVerticalList({required this.providerList});

  static const int _shimmerItemCount = 4;

  @override
  Widget build(BuildContext context) {
    final List<Providers>? providers = providerList;

    if(providers == null){
      return Column(children: List.generate(_shimmerItemCount, (index) => const Padding(
        padding: EdgeInsets.only(bottom: Dimensions.padding16),
        child: _ProviderCardShimmer(),
      )));
    }

    if(providers.isEmpty){
      return Center(child: Text('no_provider_found'.tr, style: context.body.defaultSize));
    }

    return Column(children: List.generate(providers.length, (index) => Padding(
      padding: EdgeInsets.only(bottom: index == providers.length - 1 ? 0 : Dimensions.padding16),
      child: _SearchProviderCard(provider: providers[index]),
    )));
  }
}

class _ProviderCardShimmer extends StatelessWidget {
  const _ProviderCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        height: _providerCardHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).shadowColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
      ),
    );
  }
}

class _SearchProviderCard extends StatelessWidget {
  final Providers provider;
  const _SearchProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ProviderCard(
      onTap: () => Get.toNamed(RouteHelper.getProviderDetails(provider.id ?? '')),
      providerId: provider.id,
      companyName: provider.name ?? '',
      discountPercent: 0,
      isVerified: provider.isVerified == 1,
      isFavorite: provider.isFavorite == 1,
      serviceTypeTags: provider.categories?.map((Categories category) => category.name ?? '').toList() ?? [],
      avgRating: provider.rating ?? 0,
      ratingCount: provider.ratingCount ?? 0,
      distanceKm: MapHelper.getDistanceBetweenUserCurrentLocationAndProvider(Get.find<LocationController>().getUserAddress()!, ProviderData(coordinates: provider.coordinates)),
      totalServiceServed: provider.totalCompletedServices ?? 0,
      isAvailable: provider.serviceAvailability == 1,
      isAd: provider.isAdvertisementOngoing == 1,
      coverImage: provider.coverImage,
      providerImage: provider.providerImage,
    );
  }
}
