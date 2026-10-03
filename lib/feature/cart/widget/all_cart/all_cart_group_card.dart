import 'package:tatarigigs_user/feature/cart/widget/common/cart_section_card.dart';
import 'package:tatarigigs_user/feature/cart/widget/provider/cart_provider_availability_row.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const double _avatarSize = 45;
const double _avatarBorderWidth = 2;
const double _thumbnailSize = 32;
const double _addButtonSize = 32;

class AllCartGroupCard extends StatelessWidget {
  final CartProviderGroup group;
  final bool isEnabled;
  final VoidCallback onDelete;
  final VoidCallback onViewCart;
  final VoidCallback onAddService;

  const AllCartGroupCard({
    super.key,
    required this.group,
    required this.onDelete,
    required this.onViewCart,
    required this.onAddService,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CartSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _GroupHeader(group: group, onDelete: isEnabled ? onDelete : () {}),

          Divider(height: Dimensions.padding24, color: Theme.of(context).hintColor.withValues(alpha: 0.35)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: AvatarStack(
                            imageUrls: group.thumbnails,
                            totalCount: group.serviceCount,
                            size: _thumbnailSize,
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding10),
                        _AddServiceButton(onTap: isEnabled ? onAddService : () {}),
                      ],
                    ),
                    const SizedBox(height: Dimensions.padding10),

                    _GroupPriceColumn(group: group),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.padding12),

              CustomButton(
                width: 110,
                height: 40,
                radius: Dimensions.radius8,
                buttonText: 'view_cart'.tr,
                onPressed: isEnabled ? onViewCart : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final CartProviderGroup group;
  final VoidCallback onDelete;

  const _GroupHeader({required this.group, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: _avatarSize,
          width: _avatarSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius6),
            border: Border.all(color: context.customThemeColors.borderColor, width: _avatarBorderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radius6 - _avatarBorderWidth),
            child: CustomImage(
              image: group.provider?.logoFullPath ?? '',
              height: _avatarSize,
              width: _avatarSize,
              placeholder: Images.providerImage,
            ),
          ),
        ),
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
                      group.providerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.heading.defaultSize,
                    ),
                  ),
                  if (group.isVerified) ...<Widget>[
                    const SizedBox(width: Dimensions.padding6),
                    Image.asset(Images.verified, height: 14, width: 14),
                  ],
                ],
              ),
              const SizedBox(height: Dimensions.padding2),

              CartProviderAvailabilityRow(provider: group.provider),
            ],
          ),
        ),
        const SizedBox(width: Dimensions.padding10),

        CustomInkWell(
          radius: Dimensions.radius8,
          onTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.padding4),
            child: SvgPicture.asset(
              Images.deleteOutlinedIcon,
              height: 28,
              width: 28,
              colorFilter: ColorFilter.mode(context.customThemeColors.error, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddServiceButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddServiceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      radius: _addButtonSize / 2,
      onTap: onTap,
      child: Container(
        height: _addButtonSize,
        width: _addButtonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).hintColor.withValues(alpha: 0.15),
        ),
        child: Icon(Icons.add, size: 18, color: context.customThemeColors.textColor),
      ),
    );
  }
}

class _GroupPriceColumn extends StatelessWidget {
  final CartProviderGroup group;

  const _GroupPriceColumn({required this.group});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (group.hasDiscount)
            Text(
              PriceConverter.convertPrice(group.originalAmount, isShowLongPrice: true),
              style: context.body.small.copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).hintColor,
              ),
            ),
          Text(
            PriceConverter.convertPrice(group.discountedAmount, isShowLongPrice: true),
            style: context.heading.extraLarge,
          ),
        ],
      ),
    );
  }
}
