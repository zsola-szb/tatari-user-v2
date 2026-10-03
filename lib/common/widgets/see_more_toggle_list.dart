import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SeeMoreToggleList extends StatefulWidget {
  final List<Widget> children;
  final int visibleCount;
  const SeeMoreToggleList({super.key, required this.children, this.visibleCount = 5});

  @override
  State<SeeMoreToggleList> createState() => _SeeMoreToggleListState();
}

class _SeeMoreToggleListState extends State<SeeMoreToggleList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bool canExpand = widget.children.length > widget.visibleCount;
    final List<Widget> visibleChildren = _expanded || !canExpand
        ? widget.children
        : widget.children.take(widget.visibleCount).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...visibleChildren,

      if(canExpand) Center(
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_expanded ? 'show_less'.tr : 'see_more'.tr, style: heading.defaultSize.overrideWith(
                color: Theme.of(context).colorScheme.primary,
              )),
              const SizedBox(width: Dimensions.padding6),
              RotatedBox(
                quarterTurns: _expanded ? 2 : 0,
                child: SvgPicture.asset(
                  Images.chevronDownArrowIcon, width: 18, height: 18,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}
