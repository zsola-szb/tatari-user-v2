import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AutoCollapsingQuantityStepper extends StatefulWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Duration idleTimeout;
  final Duration animationDuration;
  final bool useDeleteIconAtMinimum;
  final bool isLoading;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AutoCollapsingQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.idleTimeout = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 250),
    this.useDeleteIconAtMinimum = true,
    this.isLoading = false,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AutoCollapsingQuantityStepper> createState() => _AutoCollapsingQuantityStepperState();
}

enum _StepperAction { increment, decrement }

class _AutoCollapsingQuantityStepperState extends State<AutoCollapsingQuantityStepper>
    with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;
  late final Animation<double> _revealAnimation;
  Timer? _idleTimer;
  _StepperAction? _pendingAction;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _revealAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant AutoCollapsingQuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      _pendingAction = null;
      _restartIdleTimer();
    }
    if (widget.quantity <= 0) {
      _idleTimer?.cancel();
      if (_animationController.value != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _animationController.value = 0;
          }
        });
      }
    } else if (widget.quantity != oldWidget.quantity) {
      _revealControls();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _revealControls() {
    _animationController.forward();
    _restartIdleTimer();
  }

  void _restartIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(widget.idleTimeout, () {
      if (mounted && !widget.isLoading) {
        _animationController.reverse();
      }
    });
  }

  void _onIncrement() {
    if (widget.isLoading) {
      return;
    }
    _pendingAction = _StepperAction.increment;
    _revealControls();
    widget.onIncrement();
  }

  void _onDecrement() {
    if (widget.isLoading) {
      return;
    }
    _pendingAction = _StepperAction.decrement;
    _revealControls();
    widget.onDecrement();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = widget.backgroundColor ?? Theme.of(context).disabledColor.withValues(alpha: 0.1);
    final Color foreground = widget.foregroundColor ?? context.customThemeColors.textColor;

    if (widget.quantity <= 0) {
      return InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        onTap: widget.isLoading ? null : _onIncrement,
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(Dimensions.radius8)),
          child: widget.isLoading
              ? _StepperLoader(size: 20, color: foreground)
              : Icon(Icons.add, size: 20, color: foreground),
        ),
      );
    }

    return Container(
      height: widget.size,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(Dimensions.radius8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RevealableStepperControl(
            animation: _revealAnimation,
            alignment: Alignment.centerRight,
            onTap: _onDecrement,
            icon: widget.useDeleteIconAtMinimum && widget.quantity == 1 ? Icons.delete_outline : Icons.remove,
            color: foreground,
            isLoading: widget.isLoading && _pendingAction == _StepperAction.decrement,
          ),
          InkWell(
            onTap: _revealControls,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: widget.size),
              child: Center(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding4),
                  child: Text('${widget.quantity}', style: context.heading.defaultSize.strong),
                ),
              ),
            ),
          ),
          _RevealableStepperControl(
            animation: _revealAnimation,
            alignment: Alignment.centerLeft,
            onTap: _onIncrement,
            icon: Icons.add,
            color: foreground,
            isLoading: widget.isLoading && _pendingAction != _StepperAction.decrement,
          ),
        ],
      ),
    );
  }
}

class _RevealableStepperControl extends StatelessWidget {
  final Animation<double> animation;
  final AlignmentGeometry alignment;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final bool isLoading;

  const _RevealableStepperControl({
    required this.animation,
    required this.alignment,
    required this.onTap,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.horizontal,
      alignment: alignment,
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.padding6),
            child: isLoading
                ? _StepperLoader(size: 18, color: color)
                : Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

class _StepperLoader extends StatelessWidget {
  final double size;
  final Color color;

  const _StepperLoader({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding2),
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      ),
    );
  }
}
