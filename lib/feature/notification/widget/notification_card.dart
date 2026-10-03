import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;
  const NotificationCard({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = notification.isRead == false;

    return CustomInkWell(
      radius: Dimensions.radius16,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.padding12),
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50)
              ),
              padding: EdgeInsets.all(Dimensions.padding6),
              child: Icon(Icons.warning_rounded, color: Theme.of(context).colorScheme.tertiary),
            ),
            const SizedBox(width: Dimensions.padding8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title?.trim() ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: isUnread
                              ? context.heading.defaultSize
                              : context.subHeading.defaultSize.overrideWith(
                                  color: context.customThemeColors.secondaryTextColor,
                                  fontWeight: AppWeight.medium,
                                ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.padding12),
                      if (notification.createdAt != null)
                        Text(
                          DateConverter.convertStringTimeToDate(DateConverter.dateTimeStringToDate(notification.createdAt!)),
                          style: isUnread ? context.body.small.overrideWith(color: context.customThemeColors.textColor) : context.body.small,
                        ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.padding6),
                  Text(
                    notification.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.body.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
