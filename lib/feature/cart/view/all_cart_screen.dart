import 'package:tatarigigs_user/feature/cart/widget/all_cart/all_cart_group_card.dart';
import 'package:tatarigigs_user/feature/cart/widget/all_cart/all_cart_shimmer_view.dart';
import 'package:tatarigigs_user/feature/cart/widget/dialog/clear_cart_bottom_sheet.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class AllCartScreen extends StatefulWidget {
  const AllCartScreen({super.key});

  @override
  State<AllCartScreen> createState() => _AllCartScreenState();
}

class _AllCartScreenState extends State<AllCartScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<AllCartController>().initData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: const _AllCartAppBar(),
      body: SafeArea(
        child: _AllCartBody(scrollController: _scrollController),
      ),
    );
  }
}

class _AllCartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AllCartAppBar();

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, Dimensions.preferredSize);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCartController>(
      builder: (AllCartController controller) => CustomAppBar(
        title: 'all_cart'.tr,
        actionWidget: controller.groups.isEmpty ? null : const _ClearAllAction(),
      ),
    );
  }
}

class _ClearAllAction extends StatelessWidget {
  const _ClearAllAction();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => openClearCartBottomSheet(
          context,
          titleKey: 'clear_all',
          descriptionKey: 'clear_all_carts_confirmation',
          onConfirm: () => Get.find<AllCartController>().clearAll(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.padding16,
            vertical: Dimensions.padding10,
          ),
          child: Text(
            'clear_all'.tr,
            style: context.subHeading.defaultSize.overrideWith(
              color: context.customThemeColors.error,
              fontWeight: AppWeight.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _AllCartBody extends StatelessWidget {
  final ScrollController scrollController;

  const _AllCartBody({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllCartController>(
      builder: (AllCartController controller) {
        if (controller.isLoading) {
          return const AllCartShimmerView();
        }
        if (controller.groups.isEmpty) {
          return NoDataScreen(text: 'cart_is_empty'.tr, type: NoDataType.cart);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshGroups,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: PaginatedListView(
                  scrollController: scrollController,
                  totalSize: controller.totalSize,
                  offset: controller.currentPage,
                  limit: AllCartController.pageLimit,
                  onPaginate: (int offset) async => controller.loadPage(offset),
                  itemView: _AllCartList(controller: controller),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AllCartList extends StatelessWidget {
  final AllCartController controller;

  const _AllCartList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<CartProviderGroup> groups = controller.groups;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int index = 0; index < groups.length; index++) ...<Widget>[
            if (index > 0) const SizedBox(height: Dimensions.padding16),
            AllCartGroupCard(
              group: groups[index],
              isEnabled: !controller.isUpdating,
              onDelete: () => _onDelete(context, groups[index]),
              onViewCart: () => _onViewCart(groups[index]),
              onAddService: () => _onAddService(groups[index]),
            ),
          ],
        ],
      ),
    );
  }

  void _onDelete(BuildContext context, CartProviderGroup group) {
    openClearCartBottomSheet(
      context,
      descriptionKey: 'remove_provider_cart_confirmation',
      onConfirm: () => controller.deleteGroup(group.providerId),
    );
  }

  Future<void> _onViewCart(CartProviderGroup group) async {
    await Get.toNamed(RouteHelper.getCartRoute(providerId: group.providerId));
    await controller.loadIfStale();
  }

  Future<void> _onAddService(CartProviderGroup group) async {
    await Get.toNamed(RouteHelper.getProviderDetails(group.providerId));
    await controller.loadIfStale();
  }
}
