import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/cart/widget/cart_bottom_bar.dart';
import 'package:tatarigigs_user/feature/cart/widget/cart_shimmer_view.dart';
import 'package:tatarigigs_user/feature/cart/widget/dialog/clear_cart_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/cart/widget/items/cart_items_section.dart';
import 'package:tatarigigs_user/feature/cart/widget/promo/cart_pro_plan_banner.dart';
import 'package:tatarigigs_user/feature/cart/widget/provider/cart_provider_card.dart';
import 'package:tatarigigs_user/feature/cart/widget/provider/cart_provider_picker_sheet.dart';
import 'package:tatarigigs_user/feature/cart/widget/suggestion/customers_also_take_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final bool fromNav;
  final String providerId;

  const CartScreen({super.key, required this.fromNav, this.providerId = ''});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    Get.find<CartController>().clearProviderScope(notify: false);
    super.dispose();
  }

  Future<void> _load() async {
    final CartController controller = Get.find<CartController>();
    await controller.initData(providerId: widget.providerId);

    if (!mounted) {
      return;
    }

    final String? maximumMessage = controller.maximumOrderMessage;
    final String? minimumMessage = controller.minimumOrderMessage;
    if (minimumMessage != null) {
      customSnackBar(minimumMessage, type: ToasterMessageType.info);
    } else if (maximumMessage != null) {
      customSnackBar(maximumMessage, type: ToasterMessageType.info);
    }

    if (controller.hasProviderUnavailability && Get.currentRoute.contains(RouteHelper.cart)) {
      openCartProviderPickerSheet(context, controller.visibleCart.subCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: _CartAppBar(fromNav: widget.fromNav),
        body: SafeArea(
          child: GetBuilder<CartController>(
            builder: (CartController controller) {
              if (controller.isLoading) {
                return const CartShimmerView();
              }
              if (controller.visibleCart.isEmpty) {
                return NoDataScreen(text: 'cart_is_empty'.tr, type: NoDataType.cart);
              }
              return _CartBody(controller: controller);
            },
          ),
        ),
      ),
    );
  }
}

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool fromNav;

  const _CartAppBar({required this.fromNav});

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, Dimensions.preferredSize);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (CartController controller) {
        final int count = controller.visibleCart.serviceCount;

        return CustomAppBar(
          title: 'your_cart'.tr,
          subTitle: count > 0 ? '$count ${'service_added'.tr}' : null,
          isBackButtonExist: !fromNav,
          onBackPressed: () {
            if (Navigator.canPop(context)) {
              Get.back();
            } else {
              Get.offAllNamed(RouteHelper.getMainRoute('home'));
            }
          },
          actionWidget: controller.visibleCart.isEmpty
              ? null
              : IconButton(
                  onPressed: () => openClearCartBottomSheet(context),
                  icon: SvgPicture.asset(Images.deleteOutlinedIcon, height: 28, width: 28),
                ),
        );
      },
    );
  }
}

class _CartBody extends StatelessWidget {
  final CartController controller;

  const _CartBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.padding16),
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (controller.showProviderCard) ...<Widget>[
                      const CartProviderCard(),
                      const SizedBox(height: Dimensions.padding16),
                    ],

                    const CartItemsSection(),

                    if (controller.showProBanner) ...<Widget>[
                      const SizedBox(height: Dimensions.padding16),
                      const CartProPlanBanner(),
                    ],

                    const SizedBox(height: Dimensions.padding16),
                    const CustomersAlsoTakeSection(),
                  ],
                ),
              ),
            ),
          ),
        ),

        CartBottomBar(onConfirm: () => _onConfirm(controller)),
      ],
    );
  }

  void _onConfirm(CartController controller) {
    final String? blockedMessage = controller.checkoutBlockedMessage;
    if (blockedMessage != null) {
      customSnackBar(blockedMessage, type: ToasterMessageType.info);
      return;
    }

    final String? maximumMessage = controller.maximumOrderMessage;
    if (maximumMessage != null) {
      customSnackBar(maximumMessage, type: ToasterMessageType.info);
    }

    Get.toNamed(RouteHelper.getCheckoutRoute());
  }
}
