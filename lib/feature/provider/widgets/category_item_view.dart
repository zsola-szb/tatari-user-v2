import 'package:tatarigigs_user/feature/provider/widgets/provider_details_shimmer.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CategorySection extends StatelessWidget {
  final ProviderData? providerData;
  const CategorySection({super.key, required this.category, this.providerData,}) ;

  final CategoryModelItem category;

  static const double itemWidth = 160;

  @override
  Widget build(BuildContext context) {
    if (category.isEmptyAfterLoad) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(
          Dimensions.padding16, Dimensions.padding20, Dimensions.padding16,
          category.isPopularSection ? Dimensions.padding16 : Dimensions.padding4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            category.isPopularSection ? 'most_popular_services'.tr : category.title,
            style: context.heading.extraLarge,
          ),
          category.isPopularSection ? const SizedBox(height: Dimensions.padding16) : const SizedBox(height: Dimensions.padding12),

          if (!category.hasLoaded)
            _SectionShimmer(isPopularSection: category.isPopularSection)
          else if (category.isPopularSection)
            _PopularServiceRail(category: category, providerData: providerData)
          else
            _CategoryServiceList(category: category, providerData: providerData),

          if (category.hasLoaded && category.isLoading) ...[
            const SizedBox(height: Dimensions.padding16),
            const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          ],
        ]),
      ),

      Divider(color: context.customThemeColors.backGroundColor, height: 6, thickness: 3),
    ]);
  }
}

class _PopularServiceRail extends StatelessWidget {
  final CategoryModelItem category;
  final ProviderData? providerData;
  const _PopularServiceRail({required this.category, required this.providerData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ServiceWidgetVertical.heightFor(context, CategorySection.itemWidth, showProviderName: false),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: category.serviceList.length,
        separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding12),
        itemBuilder: (context, index) => SizedBox(
          width: CategorySection.itemWidth,
          child: ServiceWidgetVertical(service: category.serviceList[index], fromType: 'provider_details', providerData: providerData, showProviderName: false),
        ),
      ),
    );
  }
}

class _CategoryServiceList extends StatelessWidget {
  final CategoryModelItem category;
  final ProviderData? providerData;
  const _CategoryServiceList({required this.category, required this.providerData});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: category.serviceList.length,
      separatorBuilder: (context, index) => Divider(color: context.customThemeColors.backGroundColor, height: 6, thickness: 1.5),
      itemBuilder: (context, index) => ServiceCardWidget(
        service: category.serviceList[index],
        fromType: 'provider_details',
        providerData: providerData,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
        showCardColor: false,
        showProviderName: false,
      ),
    );
  }
}

class _SectionShimmer extends StatelessWidget {
  final bool isPopularSection;
  const _SectionShimmer({required this.isPopularSection});

  static const int _placeholderCount = 3;

  @override
  Widget build(BuildContext context) {
    if (isPopularSection) {
      return SizedBox(
        height: ServiceWidgetVertical.heightFor(context, CategorySection.itemWidth, showProviderName: false),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _placeholderCount,
          separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding12),
          itemBuilder: (context, index) => const SizedBox(width: CategorySection.itemWidth, child: ServiceVerticalCardShimmer()),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.padding16),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _placeholderCount,
        separatorBuilder: (context, index) => Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
        itemBuilder: (context, index) => const ServiceCardShimmer(),
      ),
    );
  }
}
