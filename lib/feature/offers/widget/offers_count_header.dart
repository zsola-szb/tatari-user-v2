import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OffersCountHeader extends StatelessWidget {
  final int count;

  const OffersCountHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding16, Dimensions.padding16, Dimensions.padding12),
      child: Text('$count ${'services_with_offers'.tr}', style: context.heading.large),
    );
  }
}