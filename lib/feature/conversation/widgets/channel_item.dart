import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ChannelItem extends StatelessWidget {
  final ChannelData channelData;
  final bool isAdmin;

  const ChannelItem({super.key, required this.channelData, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final ConversationUserModel? counterpart = _counterpart;
    if (counterpart == null) return const SizedBox();

    final ConversationUserModel? customer = _customer;
    final bool isUnread = (customer?.isRead ?? 1) == 0;
    final String imageUrl = _imageUrl(counterpart.user);
    final String preview = _lastMessagePreview();

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.padding10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        boxShadow: Get.isDarkMode ? null : cardShadow,
      ),
      child: CustomInkWell(
        radius: Dimensions.radius12,
        onTap: () => _openConversation(counterpart, imageUrl),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.padding12),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                child: CustomImage(
                  height: 44,
                  width: 44,
                  image: imageUrl,
                  placeholder: isAdmin ? Images.adminPlaceHolder : Images.userPlaceHolder,
                ),
              ),
              const SizedBox(width: Dimensions.padding12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _displayName(counterpart.user),
                            style: isUnread
                                ? context.heading.large
                                : context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            DateConverter.relativeTimeFromNow(_lastActivityAt(counterpart)),
                            style: context.body.small,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.padding6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            preview.capitalizeFirst ?? '',
                            style: isUnread
                                ? context.body.small.overrideWith(
                                    color: context.customThemeColors.textColor,
                                    fontWeight: AppWeight.medium,
                                  )
                                : context.body.small,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.padding8),
                        _ChannelTrailing(
                          isUnread: isUnread,
                          unreadCount: customer?.totalUnreadCount ?? 0,
                          isSeenByCounterpart: (counterpart.isRead ?? 0) == 1 && _isLastMessageMine,
                          counterpartImage: imageUrl,
                          isAdmin: isAdmin,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ConversationUserModel? get _customer {
    final List<ConversationUserModel>? users = channelData.channelUsers;
    if (users == null || users.length < 2) return null;
    return users.first.user?.userType == 'customer' ? users.first : users[1];
  }

  ConversationUserModel? get _counterpart {
    final List<ConversationUserModel>? users = channelData.channelUsers;
    if (users == null || users.length < 2) return null;
    return users.first.user?.userType == 'customer' ? users[1] : users.first;
  }

  bool get _isLastMessageMine {
    final UserInfoModel? user = Get.find<UserController>().userInfoModel;
    return channelData.lastMessageSentUser == '${user?.fName} ${user?.lName}';
  }

  DateTime? _lastActivityAt(ConversationUserModel counterpart) {
    final String? updatedAt = counterpart.updatedAt ?? channelData.createdAt;
    return updatedAt == null ? null : DateConverter.isoUtcStringToLocalDate(updatedAt);
  }

  String _displayName(ConversationUser? user) {
    if (isAdmin) return 'admin'.tr;
    if (user?.userType == 'provider-admin') return user?.provider?.name ?? '';
    return '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
  }

  String _imageUrl(ConversationUser? user) {
    if (user?.userType == 'super-admin') {
      return Get.find<SplashController>().configModel.content?.logoFullPath ?? '';
    }
    if (user?.userType == 'provider-admin') return user?.provider?.logoFullPath ?? '';
    return user?.profileImageFullPath ?? '';
  }

  String _lastMessagePreview() {
    final String? message = channelData.lastSentMessage;
    if (message != null) return _isLastMessageMine ? "${'you'.tr}: $message" : message;

    final String? attachmentType = channelData.lastSentAttachmentType;
    if (attachmentType == null) return '';

    final bool isPhoto = attachmentType == 'png' || attachmentType == 'jpg';
    final int fileCount = channelData.lastSentFileCount ?? 0;

    if (fileCount > 1) {
      final String unit = (isPhoto ? 'photos' : 'attachments').tr;
      return _isLastMessageMine ? "${'you_sent'.tr} $fileCount $unit" : "${'sent'.tr} $fileCount $unit";
    }
    if (_isLastMessageMine) return (isPhoto ? 'you_sent_a_photo' : 'you_sent_an_attachment').tr;
    return (isPhoto ? 'sent_a_photo' : 'sent_an_attachment').tr;
  }

  void _openConversation(ConversationUserModel counterpart, String imageUrl) {
    Get.find<ConversationController>().resetImageFile();
    Get.toNamed(RouteHelper.getChatScreenRoute(
      counterpart.channelId ?? '',
      _displayName(counterpart.user),
      imageUrl,
      counterpart.user?.phone ?? '',
      counterpart.user?.userType ?? '',
    ));
  }
}

class _ChannelTrailing extends StatelessWidget {
  final bool isUnread;
  final int unreadCount;
  final bool isSeenByCounterpart;
  final String counterpartImage;
  final bool isAdmin;

  const _ChannelTrailing({
    required this.isUnread,
    required this.unreadCount,
    required this.isSeenByCounterpart,
    required this.counterpartImage,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    if (unreadCount > 0) {
      return Container(
        height: 18,
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 18),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Text(
          unreadCount > 99 ? '99+' : '$unreadCount',
          style: context.body.extraSmall.overrideWith(color: Colors.white, fontWeight: AppWeight.strong),
        ),
      );
    }

    if (!isSeenByCounterpart) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      child: CustomImage(
        height: 16,
        width: 16,
        image: counterpartImage,
        placeholder: isAdmin ? Images.adminPlaceHolder : Images.userPlaceHolder,
      ),
    );
  }
}
