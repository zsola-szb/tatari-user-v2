import 'package:tatarigigs_user/common/widgets/base_bottomsheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingChatSheet extends StatelessWidget {
  final BookingDetailModel booking;
  const BookingChatSheet({super.key, required this.booking});
  static void open(BookingDetailModel booking) {
    final bool hasProvider = (booking.provider?.userId ?? '').isNotEmpty;
    final bool hasServiceman = (booking.serviceman?.userId ?? '').isNotEmpty;

    if (!hasProvider && !hasServiceman) {
      customSnackBar('provider_or_service_man_assigned'.tr, type: ToasterMessageType.info);
      return;
    }
    if (hasProvider && !hasServiceman) {
      _chatWithProvider(booking);
      return;
    }
    if (!hasProvider && hasServiceman) {
      _chatWithServiceman(booking);
      return;
    }

    Get.bottomSheet(
      BookingChatSheet(booking: booking),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  static void _chatWithProvider(BookingDetailModel booking) {
    final BookingProviderModel provider = booking.provider!;
    if (!provider.canChat) {
      customSnackBar('this_provider_have_not_permission_to_chat'.tr, showDefaultSnackBar: false);
      return;
    }
    Get.find<ConversationController>().createChannel(
      provider.userId,
      booking.id,
      name: provider.companyName,
      image: provider.logoFullPath ?? '',
      phone: provider.companyPhone ?? '',
      userType: 'provider',
      fromBookingDetailsPage: true,
    );
  }

  static void _chatWithServiceman(BookingDetailModel booking) {
    final BookingServicemanModel serviceman = booking.serviceman!;
    Get.find<ConversationController>().createChannel(
      serviceman.userId,
      booking.id,
      name: serviceman.user.fullName,
      image: serviceman.user.profileImageFullPath ?? '',
      phone: serviceman.user.phone ?? '',
      fromBookingDetailsPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('create_channel_with_provider'.tr, style: context.heading.large),
          const SizedBox(height: Dimensions.padding20),
          Row(
            children: <Widget>[
              Expanded(
                child: _ChatTarget(
                  label: 'provider'.tr,
                  onTap: () {
                    Get.back<void>();
                    _chatWithProvider(booking);
                  },
                ),
              ),
              const SizedBox(width: Dimensions.padding12),
              Expanded(
                child: _ChatTarget(
                  label: 'service_man'.tr,
                  onTap: () {
                    Get.back<void>();
                    _chatWithServiceman(booking);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding16),
        ],
      ),
    );
  }
}

class _ChatTarget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ChatTarget({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius8),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(Dimensions.radius8),
        ),
        child: Text(label, style: context.heading.defaultSize),
      ),
    );
  }
}
