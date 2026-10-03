import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

Future<T?> showBookingBottomSheet<T>(
  Widget bottomSheet, {
  bool isDismissible = true,
}) {
  if (Get.isBottomSheetOpen ?? false) {
    return Future<T?>.value();
  }

  final Completer<T?> completer = Completer<T?>();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (Get.isBottomSheetOpen ?? false) {
      completer.complete(null);
      return;
    }

    final T? result = await Get.bottomSheet<T>(
      bottomSheet,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
    );

    if (!completer.isCompleted) {
      completer.complete(result);
    }
  });

  return completer.future;
}
