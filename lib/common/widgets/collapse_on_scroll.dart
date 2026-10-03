import 'package:tatarigigs_user/util/core_export.dart';

class CollapseOnScroll extends StatefulWidget {
  static const double defaultThreshold = 8;

  final ScrollController? scrollController;

  final ValueNotifier<bool>? collapsedNotifier;

  final double threshold;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const CollapseOnScroll({
    super.key,
    required this.child,
    this.scrollController,
    this.collapsedNotifier,
    this.threshold = defaultThreshold,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOut,
  });

  @override
  State<CollapseOnScroll> createState() => _CollapseOnScrollState();
}

class _CollapseOnScrollState extends State<CollapseOnScroll> {
  late final ValueNotifier<bool> _collapsed;

  late final bool _ownsCollapsed;

  @override
  void initState() {
    super.initState();
    final ValueNotifier<bool>? provided = widget.collapsedNotifier;
    _ownsCollapsed = provided == null;
    _collapsed = provided ?? ValueNotifier<bool>(false);
    widget.scrollController?.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant CollapseOnScroll oldWidget) {
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
    if(_ownsCollapsed){
      _collapsed.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _collapsed,
      child: widget.child,
      builder: (context, collapsed, child) => ClipRect(
        child: AnimatedAlign(
          alignment: Alignment.topCenter,
          heightFactor: collapsed ? 0 : 1,
          duration: widget.duration,
          curve: widget.curve,
          child: AnimatedOpacity(
            opacity: collapsed ? 0 : 1,
            duration: widget.duration,
            curve: widget.curve,
            child: IgnorePointer(ignoring: collapsed, child: child),
          ),
        ),
      ),
    );
  }
}