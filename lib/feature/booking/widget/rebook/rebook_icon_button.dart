import 'package:tatarigigs_user/feature/booking/controller/booking_rebook_controller.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/booking_rebook_flow.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RebookIconButton extends StatelessWidget {
  final String bookingId;
  final String subCategoryId;
  final int index;

  const RebookIconButton({
    super.key,
    required this.bookingId,
    required this.subCategoryId,
    required this.index,
  });

  static const double _buttonSize = 36;
  static const double _iconSize = 20;
  static const double _indicatorSize = 18;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingRebookController>(builder: (BookingRebookController rebookController) {
      final bool isBusy = rebookController.isLoading && rebookController.activeIndex == index;

      return InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        onTap: isBusy ? null : () => BookingRebookFlow.start(
          context,
          bookingId: bookingId,
          subCategoryId: subCategoryId,
          index: index,
        ),
        child: Container(
          width: _buttonSize, height: _buttonSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radius6)),
          child: isBusy ?
          const SizedBox(
            width: _indicatorSize, height: _indicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ) :
          SvgPicture.asset(Images.reorder, width: _iconSize, height: _iconSize),
        ),
      );
    });
  }
}
