import 'package:tatarigigs_user/helper/analytics/analytics_helper.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

const double _headerCollapsedHeight = 56;
const double _headerExpandedHeight = 184;
const double _headerImageSize = 64;
const double _headerScrollRange = _headerExpandedHeight - _headerCollapsedHeight;
const int _collapsedVariationLimit = 4;
const double _expandDragThreshold = 12;
const Duration _expandDuration = Duration(milliseconds: 300);

double _fadeOut(double progress, double start, double end) {
  if (progress <= start) return 1;
  if (progress >= end) return 0;
  return 1 - ((progress - start) / (end - start));
}

double _fadeIn(double progress, double start, double end) {
  if (progress <= start) return 0;
  if (progress >= end) return 1;
  return (progress - start) / (end - start);
}

class ServiceCenterDialog extends StatefulWidget {
  final Service? service;
  final CartItem? cart;
  final int? cartIndex;
  final bool? isFromDetails;
  final ProviderData? providerData;

  const ServiceCenterDialog({
    super.key,
    required this.service,
    this.cart,
    this.cartIndex,
    this.isFromDetails = false, this.providerData,
  });

  @override
  State<ServiceCenterDialog> createState() => _ServiceCenterDialogState();
}

class _ServiceCenterDialogState extends State<ServiceCenterDialog> with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  late final AnimationController _expandController;
  late final CurvedAnimation _expandAnimation;

  bool _expanded = false;
  double? _collapsedHeight;
  double _overscrollUp = 0;
  double _overscrollDown = 0;

  String get _serviceId => widget.service?.id ?? '';

  @override
  void initState() {
    Get.find<CartController>().prepareVariationSelections(widget.service!);
    Get.find<CartController>().updatePreselectedProvider(null, shouldUpdate: false);
    FocusManager.instance.primaryFocus?.unfocus();
    _expandController = AnimationController(vsync: this, duration: _expandDuration);
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    super.initState();
  }

  @override
  void dispose() {
    _expandAnimation.dispose();
    _expandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final view = View.of(context);
    final double topInset = view.viewPadding.top / view.devicePixelRatio;

    return AnimatedBuilder(
      animation: _expandAnimation,
      child: GetBuilder<CartController>(builder: (cartControllerInit) {
        return GetBuilder<ServiceController>(builder: (serviceController) {
          final List<ZoneWiseVariations>? variations = widget.service!.variationsAppFormat?.zoneWiseVariations;

          if (variations == null) {
            return const Padding(
              padding: EdgeInsets.all(Dimensions.padding20),
              child: _ServiceCenterEmptyState(),
            );
          }

          final List<CartVariationSelection> selections =
              cartControllerInit.variationSelectionsForService(_serviceId);
          final int totalVariations = selections.length;

          return _ServiceCenterBody(
            service: widget.service!,
            providerData: widget.providerData,
            variationSelections: selections,
            visibleCount: _visibleVariationCount(totalVariations),
            alwaysScrollable: _expanded || totalVariations > _collapsedVariationLimit,
            minBodyHeight: screenHeight * 0.15,
            scrollController: _scrollController,
            onScrollNotification: _onScrollNotification,
            onAddToCart: _addToCart,
          );
        });
      }),
      builder: (context, child) {
        final double progress = _expandAnimation.value;
        final double topGap = 80 + (topInset - 80) * progress;
        final double maxCardHeight = screenHeight - topGap;
        final double? cardHeight = (!_expanded || _collapsedHeight == null)
            ? null : _collapsedHeight! + (maxCardHeight - _collapsedHeight!) * progress;

        return Padding(
          padding: EdgeInsets.only(top: topGap),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxCardHeight),
            child: SizedBox(
              height: cardHeight,
              child: Container(
                key: _cardKey,
                width: Dimensions.webMaxWidth,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius20 * (1 - progress))),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  int _visibleVariationCount(int total) =>
      (_expanded || total <= _collapsedVariationLimit) ? total : _collapsedVariationLimit;

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    if (notification is ScrollStartNotification || notification is ScrollEndNotification) {
      _resetOverscroll();
      return false;
    }

    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        _overscrollUp += notification.overscroll;
        _overscrollDown = 0;
      } else {
        _overscrollDown -= notification.overscroll;
        _overscrollUp = 0;
      }
    }

    final ScrollMetrics metrics = notification.metrics;
    if (!_expanded) {
      final bool pulledUp = metrics.pixels > _expandDragThreshold || _overscrollUp > _expandDragThreshold;
      if (pulledUp && _hasHiddenVariations(metrics)) {
        _expand();
      }
    } else {
      final bool pulledDownAtTop = metrics.pixels < -_expandDragThreshold || _overscrollDown > _expandDragThreshold;
      if (pulledDownAtTop) {
        _collapse();
      }
    }
    return false;
  }

  bool _hasHiddenVariations(ScrollMetrics metrics) {
    if (Get.find<CartController>().variationSelectionsForService(_serviceId).length > _collapsedVariationLimit) return true;
    return metrics.maxScrollExtent > _headerScrollRange + 1;
  }

  void _resetOverscroll() {
    _overscrollUp = 0;
    _overscrollDown = 0;
  }

  void _expand() {
    if (_expanded) return;
    final RenderBox? card = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (card != null && card.hasSize) {
      _collapsedHeight = card.size.height;
    }
    _resetOverscroll();
    setState(() => _expanded = true);
    _expandController.forward();
  }

  void _collapse() {
    if (!_expanded) return;
    _resetOverscroll();
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.animateTo(0, duration: _expandDuration, curve: Curves.easeOut);
    }
    _expandController.reverse().whenComplete(() {
      if (!mounted || !_expandController.isDismissed) return;
      setState(() => _expanded = false);
    });
  }

  Future<void> _addToCart(CartController cartController) async {
    await cartController.addSelectionsToCart(
        serviceId: _serviceId,
        providerId: cartController.selectedProvider?.id ?? widget.providerData?.id ?? "");

    try {
      for (CartVariationSelection selection in cartController.variationSelectionsForService(_serviceId)) {
        if (selection.quantity > 0) {
          AnalyticsHelper.logAddToCart(
            itemId: widget.service!.id!,
            itemName: widget.service!.name!,
            price: selection.price,
            quantity: selection.quantity,
            currency: Get.find<SplashController>().configModel.content?.currencyCode ?? '\$'
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Analytics Error: $e");
      }
    }
  }

}

class _ServiceCenterBody extends StatelessWidget {
  final Service service;
  final ProviderData? providerData;
  final List<CartVariationSelection> variationSelections;
  final int visibleCount;
  final bool alwaysScrollable;
  final double minBodyHeight;
  final ScrollController scrollController;
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  final Future<void> Function(CartController cartController) onAddToCart;

  const _ServiceCenterBody({
    required this.service,
    required this.providerData,
    required this.variationSelections,
    required this.visibleCount,
    required this.alwaysScrollable,
    required this.minBodyHeight,
    required this.scrollController,
    required this.onScrollNotification,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: CustomScrollView(
              shrinkWrap: true,
              controller: scrollController,
              physics: alwaysScrollable ? const AlwaysScrollableScrollPhysics() : null,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ServiceCenterHeaderDelegate(service: service),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
                  sliver: SliverMainAxisGroup(slivers: [
                    const SliverToBoxAdapter(child: _AvailableVariationsLabel()),
                    SliverList.separated(
                      itemCount: visibleCount,
                      separatorBuilder: (context, index) => SizedBox(),
                      itemBuilder: (context, index) => _ServiceVariationItem(
                        selection: variationSelections[index],
                        index: index,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
      _ServiceCenterBottomBar(
        service: service,
        providerData: providerData,
        onAddToCart: onAddToCart,
      ),
    ]);
  }
}

class _ServiceCenterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Service service;
  _ServiceCenterHeaderDelegate({required this.service});

  @override
  double get minExtent => _headerCollapsedHeight;
  @override
  double get maxExtent => _headerExpandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return _ServiceCenterHeader(service: service, progress: progress);
  }

  @override
  bool shouldRebuild(covariant _ServiceCenterHeaderDelegate oldDelegate) => oldDelegate.service.id != service.id;
}

class _ServiceCenterHeader extends StatelessWidget {
  final Service service;
  final double progress;
  const _ServiceCenterHeader({required this.service, required this.progress});

  @override
  Widget build(BuildContext context) {
    bool showDiscount = ((service.lowestPrice ?? 0) > (service.discountedLowestPrice ?? 0));

    final double expandedOpacity = _fadeOut(progress, 0, 0.3);
    final double collapsedTitleOpacity = _fadeIn(progress, 0.25, 0.55);
    final double boxedBarOpacity = progress < 0.55
        ? _fadeIn(progress, 0.35, 0.55) : _fadeOut(progress, 0.72, 0.95);
    final double dividerOpacity = _fadeIn(progress, 0.9, 1);
    return Stack(children: [
      Container(
        margin: EdgeInsets.all(Dimensions.padding4 * (1 - progress)),
        decoration: BoxDecoration(
          color: Color.lerp(context.customThemeColors.backGroundColor, Theme.of(context).cardColor, progress),
          borderRadius: BorderRadius.circular(Dimensions.radius16 * (1 - progress)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding20),
        child: Stack(clipBehavior: Clip.none, children: [
          if (expandedOpacity > 0)
            Positioned(
              top: Dimensions.padding6, left: 0, right: 0,
              child: Opacity(
                opacity: expandedOpacity,
                child: const Center(heightFactor: 1, child: _DragHandle()),
              ),
            ),

          if (collapsedTitleOpacity > 0)
            Positioned(
              top: 16, left: 0, right: 56,
              child: Opacity(
                opacity: collapsedTitleOpacity,
                child: Text(service.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: context.heading.extraLarge),
              ),
            ),

          if (expandedOpacity > 0)
            Positioned(
              top: 16, left: 0, right: 0,
              child: Opacity(
                opacity: expandedOpacity,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                    child: CustomImage(image: '${service.thumbnailFullPath}', height: _headerImageSize, width: _headerImageSize),
                  ),
                  const SizedBox(height: Dimensions.padding8),
                  Text(service.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: context.heading.extraLarge),
                  const SizedBox(height: Dimensions.padding4),
                  Row(children: [
                    Image.asset(Images.starIcon, height: 14, width: 14),
                    Gaps.horizontalGapOf(4),
                    Text(service.avgRating?.toStringAsFixed(1) ?? '0.0', style: context.heading.small.medium),
                    Gaps.horizontalGapOf(4),
                    Text('(${service.ratingCount ?? 0})', style: context.heading.small.regular.overrideWith(color: context.customThemeColors.secondaryTextColor)),
                  ]),
                  const SizedBox(height: Dimensions.padding8),
                  _StartsFromRow(service: service, lowestPrice: service.lowestPrice ?? 0, lowestDiscountPrice: service.discountedLowestPrice ?? 0, showDiscount: showDiscount, boxed: false),
                ]),
              ),
            ),

          if (boxedBarOpacity > 0)
            Positioned(
              top: _headerCollapsedHeight, left: 0, right: 0,
              child: Opacity(
                opacity: boxedBarOpacity,
                child: _StartsFromRow(service: service, lowestPrice: service.lowestPrice ?? 0, lowestDiscountPrice: service.discountedLowestPrice ?? 0, showDiscount: showDiscount, boxed: true),
              ),
            ),

          Positioned(
            top: Dimensions.padding6, right: -Dimensions.padding16,
            child: _CloseButton(tintOpacity: collapsedTitleOpacity),
          ),
        ]),
      ),

      if (dividerOpacity > 0)
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Opacity(
            opacity: dividerOpacity,
            child: Divider(height: 1, thickness: 1, color: context.customThemeColors.secondaryBackGroundColor),
          ),
        ),
    ]);
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.padding4,
      width: Dimensions.padding36,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(Dimensions.radius4),
      ),
    );
  }
}

class _StartsFromRow extends StatelessWidget {
  final Service service;
  final double lowestPrice;
  final double lowestDiscountPrice;
  final bool showDiscount;
  final bool boxed;

  const _StartsFromRow({
    required this.service,
    required this.lowestPrice,
    required this.lowestDiscountPrice,
    required this.showDiscount,
    required this.boxed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('starts_from'.tr, style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
          const SizedBox(height: Dimensions.padding2),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                PriceConverter.convertPrice(showDiscount ? lowestDiscountPrice : lowestPrice),
                style: context.heading.extraOverLarge,
              ),
            ),
            if (showDiscount) ...[
              Gaps.horizontalGapOf(6),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  PriceConverter.convertPrice(lowestPrice),
                  style: context.body.defaultSize.medium.copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
            ],
          ]),
        ]),
      ),
      InkWell(
        onTap: () {
          Get.back();
          Get.toNamed(RouteHelper.getServiceRoute(service.slug ?? ''));
        },
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('view_details'.tr, style: context.heading.defaultSize.overrideWith(color: Theme.of(context).colorScheme.primary, fontWeight: AppWeight.strong)),
          Icon(Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.primary),
        ]),
      ),
    ]);

    if (!boxed) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding8),
      decoration: BoxDecoration(
        color: context.customThemeColors.secondaryBackGroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      child: content,
    );
  }
}

class _AvailableVariationsLabel extends StatelessWidget {
  const _AvailableVariationsLabel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text('available_variations'.tr, style: context.subHeading.large),
        const SizedBox(height: Dimensions.padding8),
        Divider(height: 1, color: context.customThemeColors.secondaryBackGroundColor),
      ]),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final double tintOpacity;
  const _CloseButton({this.tintOpacity = 1});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      onTap: () => Get.back(),
      child: Container(
        height: 36, width: 36, alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.1 * tintOpacity),
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Icon(Icons.close, color: context.customThemeColors.textColor, size: 20),
      ),
    );
  }
}

class _ServiceCenterEmptyState extends StatelessWidget {
  const _ServiceCenterEmptyState();

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(top: 0, right: -Dimensions.padding16, child: const _CloseButton()),
      SizedBox(
        height: Get.height / 7,
        child: Center(child: Text('no_variation_is_available'.tr, style: context.heading.large)),
      ),
    ]);
  }
}

class _ServiceVariationItem extends StatelessWidget {
  final CartVariationSelection selection;
  final int index;
  const _ServiceVariationItem({required this.selection, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool showDiscountedPrice = (selection.price > (selection.discountedPrice ?? 0));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selection.variantName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.heading.large.strong,
                ),
                Gaps.verticalGapOf(Dimensions.padding4),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Text(
                        showDiscountedPrice
                            ? PriceConverter.convertPrice((selection.discountedPrice ?? 0).toDouble(), isShowLongPrice: true)
                            : PriceConverter.convertPrice(selection.price.toDouble(), isShowLongPrice: true),
                        style: context.heading.defaultSize.medium,
                      ),
                      if (showDiscountedPrice) ...[
                        Gaps.horizontalGapOf(Dimensions.padding6),
                        Text(
                          PriceConverter.convertPrice(selection.price.toDouble(), isShowLongPrice: true),
                          style: context.subHeading.small.copyWith(color: context.customThemeColors.secondaryTextColor, decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.padding10),
          _QuantityStepper(selection: selection, index: index),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final CartVariationSelection selection;
  final int index;
  const _QuantityStepper({required this.selection, required this.index});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return AutoCollapsingQuantityStepper(
      quantity: selection.quantity,
      onIncrement: () => cartController.changeSelectionQuantity(selection.serviceId, index, true),
      onDecrement: () => cartController.changeSelectionQuantity(selection.serviceId, index, false),
    );
  }
}

class _ServiceCenterBottomBar extends StatelessWidget {
  final Service service;
  final ProviderData? providerData;
  final Future<void> Function(CartController cartController) onAddToCart;

  const _ServiceCenterBottomBar({required this.service, required this.providerData, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      final String serviceId = service.id ?? '';
      final bool isCartEmpty = !cartController.hasSelectedQuantityForService(serviceId);

      return Container(
        padding: const EdgeInsets.fromLTRB(Dimensions.padding20, Dimensions.padding12, Dimensions.padding20, Dimensions.padding20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(top: BorderSide(color: context.customThemeColors.secondaryBackGroundColor)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(
              TextSpan(
                text: '${'total'.tr} ',
                style: context.heading.large,
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(PriceConverter.convertPrice(cartController.selectionTotalForService(serviceId)), style: context.heading.extraOverLarge),
            ),
          ]),
          const SizedBox(height: Dimensions.padding12),
          Row(spacing: Dimensions.padding10, children: [
            // if (Get.find<SplashController>().configModel.content?.directProviderBooking == 1 &&
            //     (providerData != null || cartController.selectedProvider != null))
            //   SelectedProviderChip(providerData: providerData ?? cartController.selectedProvider),

            if (Get.find<SplashController>().configModel.content?.biddingStatus == 1)
              ServiceBiddingButton(
                service: service,
                isDisabled: cartController.isCartUpdatingForService(serviceId),
              ),

            Expanded(
              child: CustomButton(
                height: 45,
                isLoading: cartController.isCartUpdatingForService(serviceId),
                onPressed: isCartEmpty ? null : () => onAddToCart(cartController),
                backgroundColor: isCartEmpty ? Theme.of(context).disabledColor.withValues(alpha: 0.12) : null,
                textColor: isCartEmpty ? context.customThemeColors.textColor : null,
                buttonText: cartController.itemsForService(serviceId).isNotEmpty
                    ? 'update_cart'.tr : 'add_to_cart'.tr,
              ),
            ),
          ]),
        ]),
      );
    });
  }
}

