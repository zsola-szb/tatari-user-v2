import 'package:tatarigigs_user/util/core_export.dart';

class ServiceAnimatedScaleButton extends StatefulWidget {
  final Widget child;
  const ServiceAnimatedScaleButton({super.key, required this.child});

  @override
  State<ServiceAnimatedScaleButton> createState() => _ServiceAnimatedScaleButtonState();
}

class _ServiceAnimatedScaleButtonState extends State<ServiceAnimatedScaleButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    reverseDuration: const Duration(milliseconds: 250),
    lowerBound: 0.95,
    upperBound: 1.0,
    value: 1.0,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.animateTo(0.95, curve: Curves.easeOut),
      onTapUp: (_) => _controller.animateTo(1.0, curve: Curves.easeOutBack),
      onTapCancel: () => _controller.animateTo(1.0, curve: Curves.easeOutBack),
      child: ScaleTransition(scale: _controller, child: widget.child),
    );
  }
}
