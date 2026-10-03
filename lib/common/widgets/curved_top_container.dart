import 'package:tatarigigs_user/util/core_export.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';

class CurvedTopContainer extends StatefulWidget {
  static const double defaultRadius = Dimensions.radius20;

  final Widget child;
  final double radius;
  final Color? color;

  final Color? backdropColor;

  final ScrollController? scrollController;

  final double threshold;
  final Duration duration;
  final Curve curve;

  const CurvedTopContainer({
    super.key,
    required this.child,
    this.radius = defaultRadius,
    this.color,
    this.backdropColor,
    this.scrollController,
    this.threshold = CollapseOnScroll.defaultThreshold,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOut,
  });

  @override
  State<CurvedTopContainer> createState() => _CurvedTopContainerState();
}

class _CurvedTopContainerState extends State<CurvedTopContainer> {
  final ValueNotifier<bool> _collapsed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant CurvedTopContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_handleScroll);
      widget.scrollController?.addListener(_handleScroll);
      _handleScroll();
    }
  }

  void _handleScroll() {
    final ScrollController? scrollController = widget.scrollController;
    if(scrollController == null || !scrollController.hasClients) {
      return;
    }
    _collapsed.value = scrollController.position.pixels > widget.threshold;
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_handleScroll);
    _collapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backdropColor ?? context.customThemeColors.backGroundColor,
      child: ValueListenableBuilder<bool>(
        valueListenable: _collapsed,
        child: widget.child,
        builder: (context, collapsed, child) => TweenAnimationBuilder<double>(
          tween: Tween<double>(end: collapsed ? 0 : widget.radius),
          duration: widget.duration,
          curve: widget.curve,
          child: child,
          builder: (context, radius, child) {
            final BorderRadius borderRadius = BorderRadius.vertical(top: Radius.circular(radius));

            return DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color ?? Theme.of(context).scaffoldBackgroundColor,
                borderRadius: borderRadius,
              ),
              child: radius == 0 ? child : ClipRRect(borderRadius: borderRadius, child: child),
            );
          },
        ),
      ),
    );
  }
}
