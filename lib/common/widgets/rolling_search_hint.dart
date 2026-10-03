import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RollingSearchHint extends StatefulWidget {
  final List<String> words;
  final Duration interval;
  final Duration transitionDuration;

  const RollingSearchHint({
    super.key, required this.words, this.interval = const Duration(milliseconds: 2500),
    this.transitionDuration = const Duration(milliseconds: 450)});

  @override
  State<RollingSearchHint> createState() => _RollingSearchHintState();
}

class _RollingSearchHintState extends State<RollingSearchHint> {
  int _wordIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void didUpdateWidget(covariant RollingSearchHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.words, widget.words)) {
      _wordIndex = widget.words.isEmpty ? 0 : _wordIndex % widget.words.length;
      _restartTimer();
    }
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = null;
    if (widget.words.length <= 1) {
      return;
    }
    _timer = Timer.periodic(widget.interval, (_) {
      if (mounted) {
        setState(() => _wordIndex = (_wordIndex + 1) % widget.words.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = widget.words.isEmpty ? const _StaticSearchHint()
        : _RollingHintRow(
            currentWord: widget.words[_wordIndex % widget.words.length], transitionDuration: widget.transitionDuration);

    return Semantics(
      label: 'search_services'.tr,
      child: ExcludeSemantics(child: content),
    );
  }
}

class _StaticSearchHint extends StatelessWidget {
  const _StaticSearchHint();

  @override
  Widget build(BuildContext context) => Text(
    'search_for_services'.tr,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: context.body.defaultSize,
  );
}

class _RollingHintRow extends StatelessWidget {
  final String currentWord;
  final Duration transitionDuration;

  const _RollingHintRow({required this.currentWord, required this.transitionDuration});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('${'search_for'.tr} ', style: context.body.defaultSize),

      Flexible(
        child: ClipRect(
          child: AnimatedSwitcher(
            duration: transitionDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: AlignmentDirectional.centerStart,
              children: <Widget>[
                ...previousChildren,
                currentChild ?? const SizedBox.shrink(),
              ],
            ),
            transitionBuilder: (child, animation) {
              final bool isIncoming = child.key == ValueKey<String>(currentWord);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, isIncoming ? 1 : -1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: Text(
              "'$currentWord'",
              key: ValueKey<String>(currentWord),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.body.defaultSize.medium.overrideWith(color: context.customThemeColors.textColor),
            ),
          ),
        ),
      ),
    ]);
  }
}
