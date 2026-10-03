import 'package:tatarigigs_user/common/models/language_model.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';

class LanguageRadioTile extends StatelessWidget {
  final LanguageModel languageModel;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageRadioTile({super.key, required this.languageModel, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              border: isSelected ?  Border.all(color: context.customThemeColors.secondaryBackGroundColor) : null,
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                child: Image.asset(languageModel.imageUrl!, width: 36, height: 36, fit: BoxFit.cover),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(
                child: Text(
                  languageModel.languageName ?? '',
                  style: context.body.large.overrideWith(color: context.customThemeColors.textColor),
                ),
              ),

              Container(
                height: 22, width: 22,
                padding: const EdgeInsets.all(Dimensions.padding4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : context.customThemeColors.secondaryTextColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: isSelected ? DecoratedBox(decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor)) : null,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
