import 'package:tatarigigs_user/feature/booking/widget/common/booking_bottom_sheet.dart';
import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/booking_bottom_bar.dart';
import 'package:tatarigigs_user/feature/booking/widget/booking_shimmer_view.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_party_tile.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_billing_summary_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_chat_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_otp_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_payment_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_photo_evidence_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_schedule_location_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_service_info_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_summary_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_tab_bar.dart';
import 'package:tatarigigs_user/feature/booking/widget/rebook/booking_rebook_flow.dart';
import 'package:tatarigigs_user/feature/booking/widget/status/booking_history_timeline.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String? bookingId;
  final String? subBookingId;
  final String? phone;
  final String? fromPage;
  final String? token;

  const BookingDetailsScreen({
    super.key,
    this.bookingId,
    this.subBookingId,
    this.phone,
    this.fromPage,
    this.token,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BookingDetailsController>().initData(
      bookingId: widget.bookingId,
      subBookingId: widget.subBookingId,
      phone: widget.phone,
      token: widget.token,
    );
  }


  void _requestBack() {
    Navigator.maybePop(context);
  }

  void _onPopInvoked() {
    if (widget.fromPage == 'fromNotification') {
      Get.offAllNamed<void>(RouteHelper.getInitialRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      isNavigationOnOnPop: widget.fromPage == 'fromNotification',
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'booking_details'.tr,
          onBackPressed: _requestBack,
          actionWidget: GetBuilder<BookingDetailsController>(
            builder: (BookingDetailsController controller) {
              if (controller.booking?.status == BookingStatus.pending || controller.booking?.status == BookingStatus.completed) {
                return IconButton(
                  onPressed: controller.downloadInvoice,
                  icon: Icon(Icons.file_download_outlined, color: Get.isDarkMode ? Colors.white : Colors.black),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
        body: GetBuilder<BookingDetailsController>(
          builder: (BookingDetailsController controller) {
            final BookingDetailModel? booking = controller.booking;

            if (controller.isLoading) {
              return const BookingDetailsShimmerView();
            }
            if (booking == null) {
              return NoDataScreen(text: 'no_data_found'.tr, type: NoDataType.bookings);
            }

            return Column(
              children: <Widget>[
                BookingDetailsTabBar(
                  labelKeys: BookingDetailsTab.values
                      .map((BookingDetailsTab tab) => tab.labelKey).toList(growable: false),
                  selectedIndex: controller.detailsTab.index,
                  onSelected: (int index) => controller.selectDetailsTab(BookingDetailsTab.values[index]),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.reloadBooking,
                    child: controller.detailsTab == BookingDetailsTab.details
                        ? BookingDetailsTabView(booking: booking, controller: controller) : BookingStatusTabView(booking: booking),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: GetBuilder<BookingDetailsController>(
          builder: (BookingDetailsController controller) {
            final BookingDetailModel? booking = controller.booking;
            if (booking == null || !Get.find<AuthController>().isLoggedIn()) {
              return const SizedBox.shrink();
            }
            return BookingActionBar(booking: booking, controller: controller);
          },
        ),
      ),
    );
  }
}

class BookingDetailsTabView extends StatefulWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;

  const BookingDetailsTabView({super.key, required this.booking, required this.controller});

  @override
  State<BookingDetailsTabView> createState() => _BookingDetailsTabViewState();
}

class _BookingDetailsTabViewState extends State<BookingDetailsTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final BookingDetailModel booking = widget.booking;
    final BookingDetailsController controller = widget.controller;
    final BookingProviderModel? provider = booking.provider;
    final BookingServicemanModel? serviceman = controller.hasServiceman ? booking.serviceman : null;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: BookingSummaryCard(booking: booking, onSeeMore: _scrollToBottom),
              ),
              if (controller.showOtp) ...<Widget>[
                const SizedBox(height: Dimensions.padding12),
                BookingOtpCard(otp: booking.otp ?? ''),
              ],
              const SizedBox(height: Dimensions.padding16),
              BookingScheduleLocationCard(
                booking: booking,
                controller: controller,
                servicemanTile: serviceman == null
                    ? null
                    : BookingPartyTile(
                        name: serviceman.user.fullName,
                        subtitle: 'assigned_service_man'.tr,
                        imageUrl: serviceman.user.profileImageFullPath,
                        phone: serviceman.user.phone,
                        onChat: controller.canContact ? () => BookingChatSheet.open(booking) : null,
                        background: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                providerTile: provider == null
                    ? null
                    : BookingPartyTile(
                        name: provider.companyName,
                        imageUrl: provider.logoFullPath,
                        rating: provider.hasRating ? provider.avgRating : null,
                        ratingCount: provider.ratingCount,
                        isVerified: provider.isVerified,
                        phone: provider.companyPhone,
                        onChat: controller.canContact ? () => BookingChatSheet.open(booking) : null,
                      ),
              ),
              const SizedBox(height: Dimensions.padding6),
              BookingPaymentCard(booking: booking, controller: controller),
              const SizedBox(height: Dimensions.padding6),
              BookingServiceInfoSection(services: booking.services, controller: controller),
              const SizedBox(height: Dimensions.padding6),
              BookingBillingSummarySection(booking: booking, controller: controller),
              if (controller.hasEvidencePhotos) ...<Widget>[
                const SizedBox(height: Dimensions.padding6),
                BookingPhotoEvidenceSection(photos: booking.evidencePhotos),
              ],
              const SizedBox(height: Dimensions.padding12),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingStatusTabView extends StatelessWidget {
  final BookingDetailModel booking;

  const BookingStatusTabView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: Dimensions.padding16),
        child: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - Dimensions.padding16,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                      child: BookingSummaryCard(booking: booking, isCompact: true),
                    ),
                    const SizedBox(height: Dimensions.padding12),
                    Expanded(child: BookingHistoryTimeline(entries: booking.timeline)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingActionBar extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;

  const BookingActionBar({super.key, required this.booking, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<BookingBarAction> actions = <BookingBarAction>[];

    if (controller.canReview) {
      actions.add(BookingBarAction(
        label: 'review'.tr,
        onTap: () => showModalBottomSheet<void>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext _) => ReviewRecommendationDialog(id: booking.id),
        ),
      ));
    }

    if (controller.canRebook) {
      actions.add(BookingBarAction(
        label: 'rebook'.tr,
        isPrimary: true,
        onTap: () => BookingRebookFlow.start(
          context,
          bookingId: booking.id,
          subCategoryId: booking.subCategoryId,
        ),
      ));
    }

    if (actions.isEmpty && controller.canCancel) {
      actions.add(BookingBarAction(
        label: 'cancel_booking'.tr,
        isLoading: controller.isCancelling,
        onTap: () => _confirmCancel(context),
      ));
    }

    return BookingBottomBar(actions: actions);
  }

  void _confirmCancel(BuildContext context) {
    final bool isRepeatParent = booking.kind.isRepeatParent;
    showBookingBottomSheet<void>(
      ConfirmationBottomsheet(
        icon: Images.warning,
        title: isRepeatParent ? 'are_you_sure_to_cancel_this_full_booking'.tr : 'are_you_sure_to_cancel_your_order'.tr,
        description: isRepeatParent ? 'once_cancel_full_booking'.tr : 'your_order_will_be_cancel'.tr,
        noButtonText: 'yes_cancel'.tr,
        noButtonColor: Theme.of(context).colorScheme.primary,
        noTextColor: Colors.white,
        yesButtonText: 'not_now'.tr,
        yesButtonColor: Theme.of(context).colorScheme.error,
        yesTextColor: Colors.white,
        onYesPressed: () => Get.back<void>(),
        onNoPressed: () {
          Get.back<void>();
          controller.cancelBooking();
        },
      ),
    );
  }
}
