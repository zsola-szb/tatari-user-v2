import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseBottomSheet extends StatelessWidget {
  final Widget child;
  final bool showDragHandle;
  final ScrollController? scrollController;
  const BaseBottomSheet({super.key, required this.child, this.showDragHandle = false, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.padding10).copyWith(bottom: 0),
          child: Stack(alignment: Alignment.center, children: [
            if (showDragHandle)
              Container(
                height: 5, width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                  color: Theme.of(context).hintColor.withValues(alpha: 0.15),
                ),
              ),

            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.padding6),
                  decoration: BoxDecoration(color: context.customThemeColors.secondaryBackGroundColor, shape: BoxShape.circle),
                  child: Icon(Icons.close, size: Dimensions.fontSizeDefault, color: context.customThemeColors.textColor),
                ),
              ),
            ),
          ]),
        ),

        Flexible(child: SingleChildScrollView(controller: scrollController, child: child)),
      ]),
    );
  }
}
