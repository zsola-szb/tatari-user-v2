import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CouponBottomSheetWidget extends StatefulWidget {
  const CouponBottomSheetWidget({super.key});

  @override
  State<CouponBottomSheetWidget> createState() => _CouponBottomSheetWidgetState();
}

class _CouponBottomSheetWidgetState extends State<CouponBottomSheetWidget> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customThemeColors.backGroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: GetBuilder<CouponController>(
          builder: (CouponController couponController) {
            final List<CouponModel>? coupons = couponController.activeCouponList;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _SheetHeader(title: 'add_coupon'.tr),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  child: _CouponCodeField(
                    controller: _codeController,
                    isApplying: couponController.isLoading,
                    onApply: () => _apply(_codeController.text.trim()),
                  ),
                ),
                const SizedBox(height: Dimensions.padding20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'available_promo'.tr,
                      style: context.heading.large,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.padding10),

                Flexible(
                  child: _AvailableCouponList(coupons: coupons, onApply: _apply),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _apply(String code) async {
    if (code.isEmpty) {
      customSnackBar('select_a_coupon'.tr, toasterTitle: 'select_a_coupon'.tr);
      return;
    }
    if (!Get.find<AuthController>().isLoggedIn()) {
      customSnackBar('please_login_to_use_coupon'.tr, toasterTitle: 'sorry_you_can_not_use_coupon'.tr);
      return;
    }
    if (Get.find<CartController>().isEmpty) {
      customSnackBar('looks_like_no_service_is_added_to_your_cart'.tr, toasterTitle: 'oops'.tr);
      return;
    }

    final ResponseModel response = await Get.find<CouponController>().applyCoupon(code);
    if (!mounted) {
      return;
    }

    if (response.isSuccess != true) {
      customSnackBar('${response.message}', toasterTitle: 'can_not_apply_coupon'.tr);
      return;
    }

    Navigator.of(context).pop();
    customSnackBar('review_your_cart_for_applied_discounts'.tr, toasterTitle: 'coupon_applied_successfully'.tr, type: ToasterMessageType.success);
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;

  const _SheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.padding20,
        Dimensions.padding20,
        Dimensions.padding16,
        Dimensions.padding16,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(title, style: context.heading.extraLarge),
          ),
          const SizedBox(width: Dimensions.padding10),
          CustomInkWell(
            radius: Dimensions.radius20,
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: context.customThemeColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponCodeField extends StatelessWidget {
  final TextEditingController controller;
  final bool isApplying;
  final VoidCallback onApply;

  const _CouponCodeField({
    required this.controller,
    required this.isApplying,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding4,
        Dimensions.padding4,
        Dimensions.padding4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              style: context.subHeading.defaultSize,
              onSubmitted: (_) => onApply(),
              decoration: InputDecoration.collapsed(
                hintText: 'enter_coupon'.tr,
                hintStyle: context.body.defaultSize,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.padding10),
          CustomButton(
            buttonText: 'apply'.tr,
            width: 90,
            height: 42,
            radius: Dimensions.radius8,
            fontSize: Dimensions.fontSizeSmall,
            isLoading: isApplying,
            onPressed: onApply,
          ),
        ],
      ),
    );
  }
}

class _AvailableCouponList extends StatelessWidget {
  final List<CouponModel>? coupons;
  final ValueChanged<String> onApply;

  const _AvailableCouponList({required this.coupons, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final List<CouponModel>? list = coupons;

    if (list == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) {
      return NoDataScreen(text: 'no_coupon_available'.tr, type: NoDataType.coupon);
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        Dimensions.padding16,
        0,
        Dimensions.padding16,
        MediaQuery.of(context).padding.bottom + Dimensions.padding16,
      ),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) => CouponCardWidget(
        couponModel: list[index],
        isExpired: false,
        index: index,
        fromCheckout: true,
        onTap: (CouponModel coupon) => onApply(coupon.couponCode ?? ''),
      ),
    );
  }
}
