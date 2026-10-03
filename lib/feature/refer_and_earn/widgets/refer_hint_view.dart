import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ReferHintView extends StatelessWidget {
  final List<String> hintList;
  const ReferHintView({super.key, required this.hintList}) ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: hintList.map((hint) {
        final int index = hintList.indexOf(hint);

        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.padding12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.padding16),
            decoration: BoxDecoration(
              color: context.customThemeColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 24, width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: context.customThemeColors.warning.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: Text('${index + 1}', style: context.heading.defaultSize),
              ),
              const SizedBox(width: Dimensions.padding12),

              Expanded(child: Text(hint, style: context.subHeading.small)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
