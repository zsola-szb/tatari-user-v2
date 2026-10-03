import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutTapField extends StatelessWidget {
  final String label;
  final String? labelNote;
  final String? value;
  final String placeholder;
  final IconData icon;
  final bool isRequired;
  final VoidCallback? onTap;

  const CheckoutTapField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.labelNote,
    this.value,
    this.isRequired = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String? chosen = value;
    final bool hasValue = chosen != null && chosen.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: context.subHeading.defaultSize.medium,
            children: <InlineSpan>[
              TextSpan(text: label),
              if (labelNote != null && labelNote!.isNotEmpty)
                TextSpan(
                  text: ' ($labelNote)',
                  style: context.body.defaultSize,
                ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: context.subHeading
                      .defaultSize
                      .copyWith(color: context.customThemeColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.padding6),
        CustomInkWell(
          radius: Dimensions.radius12,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.padding16,
              vertical: Dimensions.padding10,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? chosen : placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: hasValue
                        ? context.subHeading.defaultSize : context.body.defaultSize,
                  ),
                ),
                Icon(icon, size: 20, color: context.customThemeColors.secondaryTextColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
