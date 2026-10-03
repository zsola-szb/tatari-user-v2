import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServicePinnedHeader extends StatelessWidget {
  final Service service;
  final ServiceTabController tabController;
  final double topThreshold;
  const ServicePinnedHeader({super.key, required this.service, required this.tabController, required this.topThreshold});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceTabController>(
      builder: (controller) {
        final List<String> titles = controller.sectionTitles(service);

        return Container(
          decoration: BoxDecoration(color: context.customThemeColors.backGroundColor, boxShadow: cardShadow),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
                  child: Row(
                    children: [
                      _PinnedCircleButton(
                        onTap: () => Get.back(),
                        child: Icon(Icons.arrow_back, size: 20, color: context.customThemeColors.textColor),
                      ),
                      Gaps.horizontalGapOf(Dimensions.padding16),
                      Expanded(
                        child: Text(
                          service.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.heading.extraLarge.strong,
                        ),
                      ),
                      Gaps.horizontalGapOf(Dimensions.padding10),
                      _PinnedCircleButton(
                        child: FavoriteIconWidget(
                          serviceId: service.id,
                          value: service.isFavorite,
                          size: 40,
                          iconSize: 20,
                        ),
                      ),
                      Gaps.horizontalGapOf(Dimensions.padding10),
                      _PinnedCircleButton(
                        onTap: () => Get.toNamed(RouteHelper.getCartEntryRoute()),
                        child: CartWidget(color: context.customThemeColors.textColor, size: 20),
                      ),
                    ],
                  ),
                ),

                _ServiceTabStrip(
                  titles: titles,
                  activeIndex: controller.activeSectionIndex,
                  onTabSelected: (index) => controller.scrollToSection(index, topThreshold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServiceTabStrip extends StatefulWidget {
  final List<String> titles;
  final int activeIndex;
  final ValueChanged<int> onTabSelected;
  const _ServiceTabStrip({required this.titles, required this.activeIndex, required this.onTabSelected});

  @override
  State<_ServiceTabStrip> createState() => _ServiceTabStripState();
}

class _ServiceTabStripState extends State<_ServiceTabStrip> {
  late List<GlobalKey> _tabKeys = List<GlobalKey>.generate(widget.titles.length, (_) => GlobalKey());

  @override
  void didUpdateWidget(_ServiceTabStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titles.length != widget.titles.length) {
      _tabKeys = List<GlobalKey>.generate(widget.titles.length, (_) => GlobalKey());
    }
    if (oldWidget.activeIndex != widget.activeIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureActiveTabVisible());
    }
  }

  void _ensureActiveTabVisible() {
    if (!mounted || widget.activeIndex < 0 || widget.activeIndex >= _tabKeys.length) {
      return;
    }
    final BuildContext? ctx = _tabKeys[widget.activeIndex].currentContext;
    if (ctx == null) {
      return;
    }
    Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut, alignment: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
        itemCount: widget.titles.length,
        separatorBuilder: (_, _) => Gaps.horizontalGapOf(Dimensions.padding20),
        itemBuilder: (context, index) {
          final bool isSelected = index == widget.activeIndex;
          return InkWell(
            key: _tabKeys[index],
            onTap: () => widget.onTabSelected(index),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.padding6),
                    child: Text(
                      widget.titles[index],
                      style: isSelected
                          ? heading.large.strong.overrideWith(color: Theme.of(context).primaryColor)
                          : heading.large.strong.overrideWith(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.55)),
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(Dimensions.radius4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PinnedCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _PinnedCircleButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.customThemeColors.secondaryBackGroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius8)),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius8)),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: child),
        ),
      ),
    );
  }
}
