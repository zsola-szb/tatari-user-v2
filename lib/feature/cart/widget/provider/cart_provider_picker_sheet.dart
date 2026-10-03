import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

Future<void> openCartProviderPickerSheet(BuildContext context, String subCategoryId) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) => CartProviderPickerSheet(subCategoryId: subCategoryId),
  );
}

class CartProviderPickerSheet extends StatefulWidget {
  final String subCategoryId;

  const CartProviderPickerSheet({super.key, required this.subCategoryId});

  @override
  State<CartProviderPickerSheet> createState() => _CartProviderPickerSheetState();
}

class _CartProviderPickerSheetState extends State<CartProviderPickerSheet> {
  @override
  void initState() {
    super.initState();
    Get.find<CartController>().loadProviders(widget.subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: GetBuilder<CartController>(
        builder: (CartController controller) {
          final List<ProviderData>? providers = controller.providerList;

          if (providers == null) {
            return const SizedBox(height: 180, child: Center(child: CustomLoader()));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimensions.padding20, 0, Dimensions.padding20, Dimensions.padding20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('available_providers'.tr, style: context.heading.large),
                const SizedBox(height: Dimensions.padding2),
                Text(
                  providers.length > 1 ? '${providers.length} ${'providers_available'.tr}' : '${providers.length} ${'provider_available'.tr}',
                  style: context.body.small,
                ),
                const SizedBox(height: Dimensions.padding16),

                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.45),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _ProviderOptionTile(
                          isSelected: controller.selectedProviderIndex == -1,
                          onTap: () => controller.setProviderIndex(-1),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radius8),
                            child: Image.asset(Images.providerImage, height: 44, width: 44),
                          ),
                          title: '${'let'.tr} ${AppConstants.appName} ${'choose_for_you'.tr}',
                        ),
                        for (int index = 0; index < providers.length; index++)
                          _ProviderOptionTile(
                            isSelected: controller.selectedProviderIndex == index,
                            onTap: () => controller.setProviderIndex(index),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radius8),
                              child: CustomImage(
                                image: providers[index].logoFullPath ?? '',
                                height: 44,
                                width: 44,
                              ),
                            ),
                            title: providers[index].name ?? '',
                            isVerified: providers[index].isVerified ?? false,
                            rating: providers[index].rating,
                          ),
                      ],
                    ),
                  ),
                ),

                if (controller.hasProviderUnavailability) ...<Widget>[
                  const SizedBox(height: Dimensions.padding10),
                  Text(
                    '* ${'your_selected_provider_is_unavailable_right_now'.tr} ''${'or'.tr} ${'let'.tr} ${AppConstants.appName} ${'choose_for_you'.tr}',
                    style: context.body.small.overrideWith(color: context.customThemeColors.error),
                  ),
                ],

                const SizedBox(height: Dimensions.padding16),
                CustomButton(
                  height: 48,
                  radius: Dimensions.radius12,
                  isLoading: controller.isUpdating,
                  buttonText: 'confirm'.tr,
                  onPressed: () async {
                    final int index = controller.selectedProviderIndex;
                    await controller.updateProvider(
                      index == -1 || providers.isEmpty ? null : providers[index],
                    );
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProviderOptionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final bool isSelected;
  final bool isVerified;
  final double? rating;
  final VoidCallback onTap;

  const _ProviderOptionTile({
    required this.leading,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.isVerified = false,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding10),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Dimensions.padding12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius12),
            border: Border.all(
              color: isSelected ? primary.withValues(alpha: 0.5) : Theme.of(context).hintColor.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: Dimensions.padding12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.subHeading.defaultSize.medium,
                          ),
                        ),
                        if (isVerified) ...<Widget>[
                          const SizedBox(width: Dimensions.padding6),
                          Image.asset(Images.verified, height: 14, width: 14),
                        ],
                      ],
                    ),
                    if (rating != null) ...<Widget>[
                      const SizedBox(height: Dimensions.padding2),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, size: 14, color: context.customThemeColors.warning),
                          const SizedBox(width: Dimensions.padding4),
                          Text(rating!.toStringAsFixed(1), style: context.body.small),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle_rounded, size: 20, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}
