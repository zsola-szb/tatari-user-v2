import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingDateHeader extends StatelessWidget {
  final BookingListSection section;

  const BookingDateHeader({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
      child: Row(
        children: <Widget>[
          const Expanded(child: _HeaderRule()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
            child: Text(
              section.usesTranslationKey ? section.labelKey.tr : section.label,
              style: context.subHeading.large.overrideWith(fontWeight: AppWeight.regular),
            ),
          ),
          const Expanded(child: _HeaderRule()),
        ],
      ),
    );
  }
}

class _HeaderRule extends StatelessWidget {
  const _HeaderRule();

  @override
  Widget build(BuildContext context) {
    return Container(height: 2, color: Theme.of(context).cardColor);
  }
}
