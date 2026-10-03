import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BookingBarAction {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;

  const BookingBarAction({
    required this.label,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
  });
}

class BookingBottomBar extends StatelessWidget {
  final List<BookingBarAction> actions;

  const BookingBottomBar({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.padding16,
        Dimensions.padding12,
        Dimensions.padding16,
        Dimensions.padding16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: Theme.of(context).brightness == Brightness.light ? cardShadow : null,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List<Widget>.generate(actions.length * 2 - 1, (int index) {
            if (index.isOdd) {
              return const SizedBox(width: Dimensions.padding12);
            }
            return Expanded(child: _BarButton(action: actions[index ~/ 2]));
          }),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final BookingBarAction action;

  const _BarButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = action.isPrimary;
    final Color background =
        isPrimary ? Theme.of(context).colorScheme.primary : Theme.of(context).hintColor.withValues(alpha: 0.10);
    final Color foreground = isPrimary ? Colors.white : context.customThemeColors.textColor;

    return InkWell(
      onTap: action.isLoading ? null : action.onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: action.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foreground),
                ),
              )
            : Text(action.label, style: context.heading.defaultSize.copyWith(color: foreground)),
      ),
    );
  }
}
