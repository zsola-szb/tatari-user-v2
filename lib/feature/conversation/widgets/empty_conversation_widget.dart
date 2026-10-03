import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class EmptyConversationWidget extends StatelessWidget {
  final bool fromSearch;

  const EmptyConversationWidget({super.key, this.fromSearch = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding32,
          vertical: Dimensions.padding32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(Images.emptyConversation, width: 50),
            const SizedBox(height: Dimensions.padding32),
            Text(
              fromSearch
                  ? 'no_conversation_found_to_your_related_search'.tr
                  : "you_don't_have_any_conversation_yet".tr,
              style: context.body.defaultSize,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
