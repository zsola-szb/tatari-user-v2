import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class SubCategoryServiceCountLabelWidget extends StatelessWidget {
  final int count;
  const SubCategoryServiceCountLabelWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text('$count ${'services_available'.tr}', style: context.heading.large.strong);
  }
}
