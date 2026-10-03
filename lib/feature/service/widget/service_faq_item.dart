import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceFaqItem extends StatefulWidget {
  final Faqs faq;
  final bool initiallyExpanded;
  const ServiceFaqItem({super.key, required this.faq, this.initiallyExpanded = false});

  @override
  State<ServiceFaqItem> createState() => _ServiceFaqItemState();
}

class _ServiceFaqItemState extends State<ServiceFaqItem> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.faq.question ?? '',
                    style: _expanded ? context.heading.large.strong : context.heading.defaultSize.medium,
                  ),
                ),
                Gaps.horizontalGapOf(Dimensions.padding10),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(Images.chevronDownArrowIcon,
                    width: 14, height: 14,
                    colorFilter: ColorFilter.mode(Theme.of(context).disabledColor, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: Dimensions.padding6),
                child: Text(
                  widget.faq.answer ?? '',
                  textAlign: TextAlign.justify,
                  style: context.body.defaultSize,
                ),
              ),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}
