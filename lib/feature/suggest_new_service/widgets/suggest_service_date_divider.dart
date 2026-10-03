import 'package:tatarigigs_user/util/core_export.dart';

class SuggestServiceDateDivider extends StatelessWidget {
  final String label;

  const SuggestServiceDateDivider({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Row(children: [
        Expanded(child: Divider(color: Theme.of(context).cardColor, height: 2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
          child: Text(label, style: context.subHeading.small),
        ),
        Expanded(child: Divider(color: Theme.of(context).cardColor, height: 2)),
      ]),
    );
  }
}
