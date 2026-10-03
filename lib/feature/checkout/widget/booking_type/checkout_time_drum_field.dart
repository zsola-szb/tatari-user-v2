import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CheckoutTimeDrumField extends StatefulWidget {
  final String label;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay> onChanged;

  const CheckoutTimeDrumField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialTime,
  });

  @override
  State<CheckoutTimeDrumField> createState() => _CheckoutTimeDrumFieldState();
}

class _CheckoutTimeDrumFieldState extends State<CheckoutTimeDrumField> {
  late int _hour;
  late int _minute;
  late bool _isPM;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    final TimeOfDay source = widget.initialTime ?? TimeOfDay.now();
    final int hour12 = source.hour % 12;
    _hour = hour12 == 0 ? 12 : hour12;
    _minute = source.minute;
    _isPM = source.hour >= 12;
    _hourController = FixedExtentScrollController(initialItem: _hour - 1);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(TimeOfDay(hour: _isPM ? (_hour % 12) + 12 : _hour % 12, minute: _minute));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding16,
        vertical: Dimensions.padding4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30)),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.label,
              style: context.subHeading.defaultSize.medium,
            ),
          ),
          _TimeDrum(
            controller: _hourController,
            itemCount: 12,
            selectedIndex: _hour - 1,
            labelBuilder: (int i) => (i + 1).toString().padLeft(2, '0'),
            onChanged: (int i) {
              setState(() => _hour = i + 1);
              _emit();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
            child: Text(':', style: context.heading.extraLarge),
          ),
          _TimeDrum(
            controller: _minuteController,
            itemCount: 60,
            selectedIndex: _minute,
            labelBuilder: (int i) => i.toString().padLeft(2, '0'),
            onChanged: (int i) {
              setState(() => _minute = i);
              _emit();
            },
          ),
          const SizedBox(width: Dimensions.padding10),
          _AmPmToggle(
            isPM: _isPM,
            onChanged: (bool isPM) {
              setState(() => _isPM = isPM);
              _emit();
            },
          ),
        ],
      ),
    );
  }
}

class _TimeDrum extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedIndex;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onChanged;

  const _TimeDrum({
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 90,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 30,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (BuildContext context, int index) => Center(
            child: Text(
              labelBuilder(index),
              style: index == selectedIndex ? context.heading.extraLarge : context.body.small,
            ),
          ),
        ),
      ),
    );
  }
}

class _AmPmToggle extends StatelessWidget {
  final bool isPM;
  final ValueChanged<bool> onChanged;

  const _AmPmToggle({required this.isPM, required this.onChanged});

  static const Duration _duration = Duration(milliseconds: 250);
  static const double _segmentWidth = 45;
  static const double _segmentHeight = 40;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: SizedBox(
        width: _segmentWidth * 2,
        height: _segmentHeight,
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: _duration,
              curve: Curves.easeOutCubic,
              left: isPM ? _segmentWidth : 0,
              top: 0,
              child: Container(
                width: _segmentWidth,
                height: _segmentHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(Dimensions.radius8),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                _PeriodButton(
                  label: 'am'.tr,
                  isSelected: !isPM,
                  onTap: () => onChanged(false),
                ),
                _PeriodButton(
                  label: 'pm'.tr,
                  isSelected: isPM,
                  onTap: () => onChanged(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: _AmPmToggle._segmentWidth,
        height: _AmPmToggle._segmentHeight,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: _AmPmToggle._duration,
            curve: Curves.easeOutCubic,
            style: context.heading.small.copyWith(color: isSelected ? Colors.white : context.customThemeColors.textColor),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
