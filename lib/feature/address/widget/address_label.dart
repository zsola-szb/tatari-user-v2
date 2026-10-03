import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AddressLabelWidget extends StatelessWidget {
  const AddressLabelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Row(
          children: AddressLabel.values.map((label) {
            final bool isSelected = label == locationController.selectedAddressLabel;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: label != AddressLabel.values.last
                      ? Dimensions.padding10
                      : 0,
                ),
                child: CustomInkWell(
                  radius: Dimensions.radius8,
                  onTap: () {
                    locationController.updateAddressLabel(addressLabel: label);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.padding10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius8),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          label.index == 0
                              ? Icons.home_filled
                              : label.index == 1
                              ? Icons.work
                              : Icons.widgets,
                          color: isSelected
                              ? Theme.of(context).cardColor
                              : context.customThemeColors.secondaryTextColor,
                          size: 18,
                        ),
                        const SizedBox(width: Dimensions.padding6),
                        Text(
                          label.name.tr,
                          style: context.heading.small.overrideWith(
                            color: isSelected
                                ? Theme.of(context).cardColor
                                : context.customThemeColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
