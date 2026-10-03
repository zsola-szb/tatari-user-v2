import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const double _iconButtonSize = 36;

class BookingContactActions extends StatelessWidget {
  final String? phone;
  final VoidCallback? onChat;

  const BookingContactActions({super.key, this.phone, this.onChat});

  @override
  Widget build(BuildContext context) {
    final String? number = phone;
    final bool canCall = number != null && number.isNotEmpty && Get.find<BookingDetailsController>().canContact;

    if (!canCall && onChat == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (canCall)
          _ContactButton(asset: Images.phoneIcon, onTap: () => _dial(number)),
        if (canCall && onChat != null) const SizedBox(width: Dimensions.padding8),
        if (onChat != null) _ContactButton(asset: Images.chatIcon, onTap: onChat!),
      ],
    );
  }

  Future<void> _dial(String number) async {
    final Uri uri = Uri.parse('tel:$number');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      customSnackBar('something_went_wrong'.tr);
    }
  }
}

class _ContactButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  static const double _glyphSize = 20;

  const _ContactButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_iconButtonSize),
      child: SizedBox(
        height: _iconButtonSize,
        width: _iconButtonSize,
        child: Center(
          child: SvgPicture.asset(asset, height: _glyphSize, width: _glyphSize),
        ),
      ),
    );
  }
}
