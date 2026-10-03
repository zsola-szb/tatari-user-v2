import 'package:tatarigigs_user/util/core_export.dart';

class CheckoutSegmentedTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CheckoutSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.padding4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        children: List<Widget>.generate(
          labels.length,
          (int index) => Expanded(
            child: _SegmentTabButton(
              label: labels[index],
              isSelected: index == selectedIndex,
              onTap: () => onChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isSelected
              ? context.heading.defaultSize.copyWith(color: Theme.of(context).cardColor).strong
              : context.body.defaultSize.strong,
        ),
      ),
    );
  }
}
