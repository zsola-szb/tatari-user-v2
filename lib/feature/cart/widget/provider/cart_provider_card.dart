import 'package:tatarigigs_user/feature/cart/widget/common/cart_section_card.dart';
import 'package:tatarigigs_user/feature/cart/widget/provider/cart_provider_availability_row.dart';
import 'package:tatarigigs_user/feature/cart/widget/provider/cart_provider_picker_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const double _avatarSize = 44;

class CartProviderCard extends StatelessWidget {
  const CartProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (CartController controller) {
        final ProviderData? provider = controller.visibleCart.provider;

        return CartSectionCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(_avatarSize / 2),
                child: provider == null
                    ? Container(
                        height: _avatarSize,
                        width: _avatarSize,
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                        alignment: Alignment.center,
                        child: Image.asset(Images.providerImage, height: 28, width: 28),
                      )
                    : CustomImage(
                        image: provider.logoFullPath ?? '',
                        height: _avatarSize,
                        width: _avatarSize,
                      ),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(
                child: provider == null
                    ? Text('${'let'.tr} ${AppConstants.appName} ${'choose_for_you'.tr}',
                        style: context.subHeading.defaultSize.medium,
                      ) : _ProviderDetails(provider: provider),
              ),

              if (!BusinessModelHelper.isOpenMarket) ...<Widget>[
                const SizedBox(width: Dimensions.padding10),
                _SelectProviderButton(onTap: () => openCartProviderPickerSheet(context, controller.visibleCart.subCategoryId)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProviderDetails extends StatelessWidget {
  final ProviderData provider;

  const _ProviderDetails({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                provider.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.heading.defaultSize,
              ),
            ),
            if (provider.isVerified ?? false) ...<Widget>[
              const SizedBox(width: Dimensions.padding6),
              Image.asset(Images.verified, height: 14, width: 14),
            ],
          ],
        ),
        const SizedBox(height: Dimensions.padding2),

        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            provider.contactPersonPhone ?? '',
            style: context.body.small,
          ),
        ),
        const SizedBox(height: Dimensions.padding4),

        CartProviderAvailabilityRow(provider: provider),
      ],
    );
  }
}

class _SelectProviderButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SelectProviderButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: SvgPicture.asset(
          Images.editIcon,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
