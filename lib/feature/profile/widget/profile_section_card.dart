import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const ProfileSectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    if(children.isEmpty){
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.padding16).copyWith(bottom: 0),
            child: Text(title,
              style: context.body.small.overrideWith(
                color: context.customThemeColors.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          for(int index = 0; index < children.length; index++) ...[
            children[index],
            if(index != children.length - 1)
              Divider(height: 1, indent: Dimensions.padding16, endIndent: Dimensions.padding16, color: Theme.of(context).hintColor.withValues(alpha: .3)),
          ],
        ]),
      ),
    );
  }
}
