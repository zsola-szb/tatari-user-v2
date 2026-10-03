import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BackToTopButton extends StatefulWidget {
  static const double threshold = 400;

  static const double gap = Dimensions.padding12;

  static const double _tapInset = Dimensions.padding8;

  final ScrollController scrollController;

  final double Function()? topResolver;

  const BackToTopButton({super.key, required this.scrollController, this.topResolver});

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
  final ValueNotifier<bool> _visible = ValueNotifier(false);
  final ValueNotifier<double> _top = ValueNotifier(BackToTopButton.gap);

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant BackToTopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_handleScroll);
      widget.scrollController.addListener(_handleScroll);
    }
  }

  void _handleScroll() {
    if(!widget.scrollController.hasClients) {
      return;
    }

    final bool visible = widget.scrollController.position.pixels > BackToTopButton.threshold;
    if(visible) {
      _top.value = widget.topResolver?.call() ?? BackToTopButton.gap;
    }
    _visible.value = visible;
  }

  void _scrollToTop() {
    if(!widget.scrollController.hasClients) {
      return;
    }
    widget.scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    _visible.dispose();
    _top.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _top,
      child: BackToTopPill(onTap: _scrollToTop),
      builder: (context, top, pill) => ValueListenableBuilder<bool>(
        valueListenable: _visible,
        child: pill,
        builder: (context, visible, pill) => AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          top: top - BackToTopButton._tapInset,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedSlide(
              offset: visible ? Offset.zero : const Offset(0, -0.6),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: pill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackToTopPill extends StatelessWidget {
  final VoidCallback onTap;
  const BackToTopPill({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.padding10, 0, Dimensions.padding10, Dimensions.padding10),
        child: CustomInkWell(
          radius: 99,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(Dimensions.padding10, Dimensions.padding6, Dimensions.padding6, Dimensions.padding6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Theme.of(context).cardColor, width: 0.2),
                boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('back_to_top'.tr, style: context.heading.small.overrideWith(color: Get.isDarkMode ? context.customThemeColors.textColor : Theme.of(context).cardColor)),
                const SizedBox(width: Dimensions.padding8),
                Icon(Icons.arrow_upward_outlined, size: 16, color: Get.isDarkMode ? context.customThemeColors.textColor : Theme.of(context).cardColor),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}