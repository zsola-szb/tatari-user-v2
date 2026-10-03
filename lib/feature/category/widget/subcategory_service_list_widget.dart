import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryServiceListWidget extends StatelessWidget {
  final List<Service> services;
  final GlobalKey<CustomShakingWidgetState> signInShakeKey;
  const SubCategoryServiceListWidget({super.key, required this.services, required this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (context, index) => Divider(color: context.customThemeColors.backGroundColor, height: 6, thickness: 1.5),
      itemBuilder: (context, index) => ServiceCardWidget(
        padding: EdgeInsets.only(bottom: Dimensions.padding8, top: index != 0 ? Dimensions.padding8 : 0),
        service: services[index],
        fromType: 'others',
        fromPage: 'category_subcategory',
        signInShakeKey: signInShakeKey,
      ),
    );
  }
}
