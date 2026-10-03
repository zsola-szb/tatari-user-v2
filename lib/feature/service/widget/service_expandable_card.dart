import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceExpandableCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool? isExpandable;
  const ServiceExpandableCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.initiallyExpanded = true,
    this.isExpandable = true,
  });

  @override
  State<ServiceExpandableCard> createState() => _ServiceExpandableCardState();
}

class _ServiceExpandableCardState extends State<ServiceExpandableCard> {
  late bool _expanded = !_isExpandable || widget.initiallyExpanded;

  bool get _isExpandable => widget.isExpandable ?? true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.customThemeColors.backGroundColor),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _isExpandable ? () => setState(() => _expanded = !_expanded) : null,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: context.heading.extraLarge.strong),
                        if (widget.subtitle != null) ...[
                          Gaps.verticalGapOf(Dimensions.padding4),
                          Text(widget.subtitle!, style: context.body.small),
                        ],
                      ],
                    ),
                  ),
                  if (_isExpandable) ...[
                    Gaps.horizontalGapOf(Dimensions.padding10),
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                      ),
                      child: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: SvgPicture.asset(Images.chevronDownArrowIcon, width: 14, height: 14,
                          colorFilter: ColorFilter.mode(Theme.of(context).disabledColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(Dimensions.padding16, 0, Dimensions.padding16, Dimensions.padding16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widget.children),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
