import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SetLocationSuggestionsCard extends StatelessWidget {
  final List<AddressModel> matchedAddresses;
  final List<PredictionModel> predictions;
  final ValueChanged<AddressModel> onAddressTap;
  final ValueChanged<PredictionModel> onPredictionTap;

  const SetLocationSuggestionsCard({
    super.key,
    required this.matchedAddresses,
    required this.predictions,
    required this.onAddressTap,
    required this.onPredictionTap,
  });

  IconData _iconForLabel(String? label) {
    switch (label?.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = matchedAddresses.isEmpty && predictions.isEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.padding16,
              ),
              child: Text(
                'no_address_found'.tr,
                textAlign: TextAlign.center,
                style: context.body.defaultSize,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('suggestions'.tr, style: context.heading.defaultSize),
                const SizedBox(height: Dimensions.padding8),

                ...matchedAddresses.map(
                  (address) => SetLocationSuggestionRow(
                    icon: _iconForLabel(address.addressLabel),
                    boldPrefix: '${(address.addressLabel ?? 'others').tr} : ',
                    text: address.address ?? '',
                    onTap: () => onAddressTap(address),
                  ),
                ),

                ...predictions.map((prediction) {
                  final text =
                      prediction.description ??
                      prediction.placePrediction?.text?.text ??
                      '';
                  return SetLocationSuggestionRow(
                    icon: Icons.location_on_outlined,
                    text: text,
                    onTap: () => onPredictionTap(prediction),
                  );
                }),
              ],
            ),
    );
  }
}
