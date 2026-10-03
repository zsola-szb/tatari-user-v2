import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class NoProviderBidsView extends StatelessWidget {
  const NoProviderBidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search, color: Theme.of(context).colorScheme.error, size: 32),
          const SizedBox(height: Dimensions.padding20),

          Text('no_provider_bids_yet'.tr, style: context.heading.large, textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.padding8),

          Text('your_post_is_live_youll_be_notified_as_soon_as_a_provider_places_a_bid'.tr,
            style: context.body.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
