import 'package:tatarigigs_user/util/core_export.dart';

class OfflineMethodCard extends StatelessWidget {
  final CheckoutOfflineMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const OfflineMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final List<CheckoutOfflinePaymentInformation> details = method.paymentInformation ?? <CheckoutOfflinePaymentInformation>[];

    return CustomInkWell(
      radius: Dimensions.radius12,
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: Dimensions.padding10),
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Theme.of(context).hintColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          border: Border.all(
            color: isSelected ? primary : Theme.of(context).hintColor.withValues(alpha: 0.30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    method.methodName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.heading.defaultSize,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 18, color: primary),
              ],
            ),
            const SizedBox(height: Dimensions.padding10),
            ...details.map(
              (CheckoutOfflinePaymentInformation info) => Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.padding4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(info.title ?? '', style: context.subHeading.small),
                    const SizedBox(width: Dimensions.padding6),

                    Expanded(
                      child: Text(': ${info.data ?? ''}', style: context.body.small),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
