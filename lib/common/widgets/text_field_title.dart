import 'package:tatarigigs_user/util/core_export.dart';

class TextFieldTitle extends StatelessWidget {
  final String title;
  final bool requiredMark;
  const TextFieldTitle({super.key, required this.title, this.requiredMark = false}) ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: Dimensions.padding10,top: Dimensions.padding16),
      child: RichText(
          text:
          TextSpan(children: <TextSpan>[
            TextSpan(text: title, style: context.subHeading.defaultSize),
            TextSpan(text: requiredMark?' *':"", style: context.subHeading.defaultSize.overrideWith(color: Colors.red)),
          ])),
    );
  }
}
