import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class PickerSheetHeader extends StatelessWidget {
  static const double _closeButtonSize = 28;
  final String title;
  final String subtitle;
  final bool showDivider;
  final VoidCallback? onClose;

  const PickerSheetHeader({super.key, required this.title, required this.subtitle, this.showDivider = false, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(Dimensions.padding20, Dimensions.padding20, Dimensions.padding16, Dimensions.padding10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: context.heading.large),
                    const SizedBox(height: Dimensions.padding2),
                    Text(subtitle, style: context.body.small),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.padding10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose ?? () => Navigator.of(context).pop(),
                child: Container(
                  height: _closeButtonSize,
                  width: _closeButtonSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 16, color: context.customThemeColors.secondaryTextColor),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
      ],
    );
  }
}
