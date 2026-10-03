import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationSearchResults extends StatelessWidget {
  final String query;
  final List<PredictionModel> predictions;
  final ValueChanged<PredictionModel> onPredictionTap;
  final ValueChanged<AddressModel> onAddressTap;
  final VoidCallback onSetOnMap;
  final VoidCallback onCurrentLocationTap;

  const SetLocationSearchResults({
    super.key,
    required this.query,
    required this.predictions,
    required this.onPredictionTap,
    required this.onAddressTap,
    required this.onSetOnMap,
    required this.onCurrentLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        final List<AddressModel> matchedAddresses =
            (locationController.addressList ?? [])
                .where(
                  (address) => (address.address ?? '').toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Dimensions.padding16,
                  Dimensions.padding8,
                  Dimensions.padding16,
                  Dimensions.padding16,
                ),
                child: SetLocationSuggestionsCard(
                  matchedAddresses: matchedAddresses,
                  predictions: predictions,
                  onAddressTap: onAddressTap,
                  onPredictionTap: onPredictionTap,
                ),
              ),
            ),
            SetLocationQuickActionsBar(
              onSetOnMap: onSetOnMap,
              onCurrentLocationTap: onCurrentLocationTap,
            ),
          ],
        );
      },
    );
  }
}
