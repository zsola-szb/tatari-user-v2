import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry padding;

  const BookingExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
    this.padding = const EdgeInsets.all(Dimensions.padding16),
  });

  @override
  State<BookingExpandableSection> createState() => _BookingExpandableSectionState();
}

class _BookingExpandableSectionState extends State<BookingExpandableSection> {
  late bool _isExpanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    return BookingSectionCard(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.title, style: context.heading.large),
                ),
                BookingDisclosureChevron(isExpanded: _isExpanded),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: Dimensions.padding16),
              child: SizedBox(width: double.infinity, child: widget.child),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class BookingInlineDisclosure extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const BookingInlineDisclosure({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<BookingInlineDisclosure> createState() => _BookingInlineDisclosureState();
}

class _BookingInlineDisclosureState extends State<BookingInlineDisclosure> {
  late bool _isExpanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _isExpanded = !_isExpanded);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding12,
        vertical: Dimensions.padding8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _toggle,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.title, style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium)),
                ),
                RotatedBox(
                  quarterTurns: _isExpanded ? 2 : 0,
                  child: SvgPicture.asset(
                    Images.chevronDownArrowIcon, width: 15, height: 15,
                    colorFilter: ColorFilter.mode(context.customThemeColors.secondaryTextColor, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: Dimensions.padding8),
              child: SizedBox(width: double.infinity, child: widget.child),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class BookingDisclosureChevron extends StatelessWidget {
  final bool isExpanded;

  const BookingDisclosureChevron({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
      ),
      child: RotatedBox(
        quarterTurns: isExpanded ? 2 : 0,
        child: SvgPicture.asset(
          Images.chevronDownArrowIcon, width: 12, height: 12,
          colorFilter: ColorFilter.mode(context.customThemeColors.secondaryTextColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
