import 'dart:math' as math;
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ProviderVerifiedAvatar extends StatefulWidget {
  final String? imageUrl;
  final bool isVerified;
  final double size;
  final Duration interval;

  const ProviderVerifiedAvatar({
    super.key,
    this.imageUrl,
    this.isVerified = false,
    this.size = 20,
    this.interval = const Duration(seconds: 2),
  });

  @override
  State<ProviderVerifiedAvatar> createState() => _ProviderVerifiedAvatarState();
}

class _ProviderVerifiedAvatarState extends State<ProviderVerifiedAvatar> {
  final math.Random _random = math.Random();
  Timer? _timer;
  bool _showBadge = false;
  Duration _switchDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ProviderVerifiedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVerified != widget.isVerified || oldWidget.interval != widget.interval) {
      _timer?.cancel();
      _showBadge = false;
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    if (!widget.isVerified) return;
    _scheduleNext();
  }

  void _scheduleNext() {
    final int baseMs = math.max(1, widget.interval.inMilliseconds);
    final int halfBaseMs = (baseMs * 0.5).round();
    final Duration nextDelay = Duration(milliseconds: halfBaseMs + _random.nextInt(baseMs));

    _timer = Timer(nextDelay, () {
      if (!mounted) return;
      setState(() {
        _switchDuration = Duration(milliseconds: 200 + _random.nextInt(1000));
        _showBadge = !_showBadge;
      });
      _scheduleNext();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVerified) {
      return SizedBox(
        height: widget.size, width: widget.size,
        child: _ProviderAvatarImage(imageUrl: widget.imageUrl, size: widget.size),
      );
    }

    return SizedBox(
      height: widget.size, width: widget.size,
      child: AnimatedSwitcher(
        duration: _switchDuration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => _FlipTransition(animation: animation, child: child),
        child: _showBadge ? _VerifiedBadge(key: const ValueKey('badge'), size: widget.size)
            : _ProviderAvatarImage(key: const ValueKey('avatar'), imageUrl: widget.imageUrl, size: widget.size),
      ),
    );
  }
}

class _ProviderAvatarImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const _ProviderAvatarImage({super.key, this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CustomImage(
        image: imageUrl,
        placeholder: Images.userPlaceHolder,
        height: size, width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final double size;

  const _VerifiedBadge({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Images.verifiedProvider, height: size - 3, width: size - 3);
  }
}


class _FlipTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _FlipTransition({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    final Animation<double> rotation = Tween<double>(begin: math.pi / 2, end: 0).animate(animation);

    return AnimatedBuilder(
      animation: rotation,
      child: child,
      builder: (context, rotatingChild) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotation.value),
        child: Opacity(opacity: animation.value, child: rotatingChild),
      ),
    );
  }
}
