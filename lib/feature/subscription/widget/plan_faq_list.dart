import 'package:tatarigigs_user/feature/subscription/model/subscription_model.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PlanFaqList extends StatelessWidget {
  final List<Faqs> faqs;

  const PlanFaqList({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('frequently_asked_questions'.tr, style: context.heading.defaultSize),
        const SizedBox(height: Dimensions.padding4),

        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).hintColor.withValues(alpha: 0.15),
          ),
          itemBuilder: (BuildContext context, int index) => _PlanFaqTile(faq: faqs[index]),
        ),
      ],
    );
  }
}

class _PlanFaqTile extends StatefulWidget {
  final Faqs faq;

  const _PlanFaqTile({required this.faq});

  @override
  State<_PlanFaqTile> createState() => _PlanFaqTileState();
}

class _PlanFaqTileState extends State<_PlanFaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text(widget.faq.question ?? '', style: context.subHeading.defaultSize)),
                const SizedBox(width: Dimensions.padding10),

                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    Images.chevronDownArrowIcon,
                    height: 14, width: 14,
                    colorFilter: ColorFilter.mode(Theme.of(context).disabledColor, BlendMode.srcIn),
                  ),
                ),
              ],
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: Dimensions.padding6),
                child: Text(widget.faq.answer ?? '', style: context.body.small),
              ),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }
}
