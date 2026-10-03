import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class FavoriteProviderItemView extends StatelessWidget {
  final bool enableSlideDelete;
  final ProviderData providerData;
  final int index;
  const FavoriteProviderItemView({super.key,  required this.providerData, required this.index, this.enableSlideDelete = true}) ;

  @override
  Widget build(BuildContext context) {
    List<String> serviceTypeTags = providerData.categoryNames;

    return Padding(padding: const EdgeInsets.fromLTRB( 15, 0, 15, 15),
      child: Slidable(
        key: const ValueKey(1),
        closeOnScroll: false,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: null,
          extentRatio: 0.2,
          children: [
            CustomSlidableAction(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
              flex: 1,
              onPressed: (context) async {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (context) => FavoriteItemRemoveDialog(
                    providerId : providerData.id,
                  ),
                  backgroundColor: Colors.transparent,
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius6),
                  bottomRight:  Radius.circular(Dimensions.radius6)),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.padding8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(Dimensions.padding10),
                ),
                child: const Icon(Icons.delete_forever_outlined, color: Colors.white,),
              ),
            ),
          ],
        ),
        child: ProviderCard(
          coverImage: providerData.coverImageFullPath,
          providerImage: providerData.logoFullPath,
          companyName: providerData.name ?? "",
          isVerified: providerData.isVerified ?? false,
          serviceTypeTags: serviceTypeTags,
          avgRating: providerData.rating ?? 0,
          ratingCount: providerData.ratingCount ?? 0,
          distanceKm: providerData.distance,
          totalServiceServed: providerData.totalCompletedServices,
          isAvailable: providerData.serviceAvailability == 1,
          isFavorite: true,
          providerId: providerData.id,
          showFavoriteRemoveDialog: true,
          onTap: () => Get.toNamed(RouteHelper.getProviderDetails(providerData.id!)),
        ),
      ),
    );
  }
}
