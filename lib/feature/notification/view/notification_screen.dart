import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/common/widgets/image_dialog.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/feature/notification/widget/notification_shimmer.dart';
import 'package:tatarigigs_user/feature/notification/widget/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: 'notification'.tr, isBackButtonExist: true),
        body: GetBuilder<NotificationController>(
          initState: (state) => Get.find<NotificationController>().getNotifications(1),
          builder: (controller) {
            return FooterBaseView(
              isScrollView: true,
              scrollController: _scrollController,
              isCenter: controller.notificationList.isEmpty,
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: controller.notificationModel == null
                    ? const NotificationShimmer()
                    : controller.dateList.isEmpty
                        ? NoDataScreen(text: 'no_notification_found'.tr, type: NoDataType.notification)
                        : PaginatedListView(
                            scrollController: _scrollController,
                            totalSize: controller.notificationModel!.totalSize!,
                            onPaginate: (int offset) async => await controller.getNotifications(
                              offset,
                              reload: false,
                            ),
                            offset: controller.offset,
                            itemView: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.dateList.length,
                              itemBuilder: (context, index0) {
                                final List<NotificationData> notificationsForDate =
                                    List<NotificationData>.from(controller.notificationList[index0] as List);
                                if (notificationsForDate.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                final String? firstCreatedAt = notificationsForDate.first.createdAt;
                                final DateTime? date =
                                    firstCreatedAt != null ? DateConverter.dateTimeStringToDate(firstCreatedAt) : null;
                                final DateTime today = DateTime.now();
                                final int? differenceInDays = date != null
                                    ? DateTime(today.year, today.month, today.day)
                                        .difference(DateTime(date.year, date.month, date.day))
                                        .inDays
                                    : null;
                                final String? dateLabel = differenceInDays == null
                                    ? null
                                    : differenceInDays == 0
                                        ? 'today'.tr
                                        : differenceInDays == 1
                                            ? 'yesterday'.tr
                                            : DateConverter.dateStringMonthYear(date!);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (dateLabel != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
                                        child: Row(
                                          children: [
                                            Expanded(child: Divider(color: Theme.of(context).cardColor, thickness: 3)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12),
                                              child: Text(dateLabel, style: context.subHeading.large),
                                            ),
                                            Expanded(child: Divider(color: Theme.of(context).cardColor, thickness: 3)),
                                          ],
                                        ),
                                      ),
                                    ...notificationsForDate.map(
                                      (notification) => NotificationCard(
                                        notification: notification,
                                        onTap: () {
                                          controller.markNotificationAsRead(notification);
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => ImageDialog(
                                              imageUrl: notification.imageFullPath ?? '',
                                              title: notification.title?.trim() ?? '',
                                              subTitle: notification.description ?? '',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }
}
