import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutProviderCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String phone;
  final String address;

  const CheckoutProviderCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: CustomImage(
              image: imageUrl ?? '',
              height: 48,
              width: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.padding16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.heading.defaultSize,
                ),
                if (phone.isNotEmpty) ...<Widget>[
                  const SizedBox(height: Dimensions.padding2),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(phone, style: context.body.small),
                  ),
                ],
                if (address.isNotEmpty) ...<Widget>[
                  const SizedBox(height: Dimensions.padding2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: context.customThemeColors.secondaryTextColor,
                      ),
                      const SizedBox(width: Dimensions.padding2),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.body.small,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
