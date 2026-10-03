import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/booking_shimmer_view.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_party_tile.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_chat_sheet.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_photo_evidence_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_schedule_location_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_service_info_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_summary_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/details/booking_tab_bar.dart';
import 'package:tatarigigs_user/feature/booking/widget/repeat/next_service_card.dart';
import 'package:tatarigigs_user/feature/booking/widget/repeat/repeat_billing_summary_section.dart';
import 'package:tatarigigs_user/feature/booking/widget/repeat/service_log_section.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class RepeatBookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  final String? fromPage;

  const RepeatBookingDetailsScreen({super.key, required this.bookingId, this.fromPage});

  @override
  State<RepeatBookingDetailsScreen> createState() => _RepeatBookingDetailsScreenState();
}

class _RepeatBookingDetailsScreenState extends State<RepeatBookingDetailsScreen> {
  BookingDetailModel? _parentSnapshot;

  @override
  void initState() {
    super.initState();
    Get.find<BookingDetailsController>().initData(bookingId: widget.bookingId);
  }

  void _reloadParent() {
    final BookingDetailsController controller = Get.find<BookingDetailsController>();
    final BookingDetailModel? snapshot = _parentSnapshot;
    if (snapshot != null) {
      controller.restoreBooking(snapshot);
    }
    controller.loadBooking(bookingId: widget.bookingId, showLoader: false);
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
                  icon: const Icon(Icons.file_download_outlined, color: Colors.black),
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
            if (booking.id == widget.bookingId) {
              _parentSnapshot = booking;
            }

            return Column(
              children: <Widget>[
                BookingDetailsTabBar(
                  labelKeys: RepeatBookingTab.values.map((RepeatBookingTab tab) => tab.labelKey).toList(growable: false),
                  selectedIndex: controller.repeatTab.index,
                  onSelected: (int index) =>
                      controller.selectRepeatTab(RepeatBookingTab.values[index]),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.reloadBooking,
                    child: controller.repeatTab == RepeatBookingTab.details
                        ? _RepeatDetailsTabView(booking: booking, controller: controller, onReload: _reloadParent) : _ServiceLogTabView(booking: booking, controller: controller, onReload: _reloadParent),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: GetBuilder<BookingDetailsController>(
          builder: (BookingDetailsController controller) {
            final BookingDetailModel? booking = controller.booking;
            if (booking == null) {
              return const SizedBox.shrink();
            }
            return BookingActionBar(booking: booking, controller: controller);
          },
        ),
      ),
    );
  }
}

class _RepeatDetailsTabView extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;
  final VoidCallback onReload;

  const _RepeatDetailsTabView({required this.booking, required this.controller, required this.onReload});

  @override
  Widget build(BuildContext context) {
    final BookingRepeatChild? nextService = controller.nextRepeatService;
    final BookingProviderModel? provider = booking.provider;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(
            children: <Widget>[
              if (nextService != null) ...<Widget>[
                const SizedBox(height: Dimensions.padding12),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: Dimensions.padding16),
                  child: NextServiceCard(child: nextService, onReturn: onReload),
                ),
                const SizedBox(height: Dimensions.padding12),
              ],
              const SizedBox(height: Dimensions.padding12),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: Dimensions.padding16),
                child: BookingSummaryCard(booking: booking),
              ),
              const SizedBox(height: Dimensions.padding12),
              BookingScheduleLocationCard(
                booking: booking,
                controller: controller,
                providerTile: provider == null ? null
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
              BookingServiceInfoSection(services: booking.services, controller: controller),
              const SizedBox(height: Dimensions.padding6),
              RepeatBillingSummarySection(booking: booking, controller: controller),
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

class _ServiceLogTabView extends StatelessWidget {
  final BookingDetailModel booking;
  final BookingDetailsController controller;
  final VoidCallback onReload;

  const _ServiceLogTabView({required this.booking, required this.controller, required this.onReload});

  @override
  Widget build(BuildContext context) {
    final BookingRepeatSchedule schedule = booking.repeat;
    final BookingRepeatChild? nextService = controller.nextRepeatService;
    final List<BookingRepeatChild> upcoming = controller.upcomingRepeatServices;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.padding16),
      child: Center(
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: Column(
            children: <Widget>[
              if (nextService != null) ...<Widget>[
                NextServiceCard(child: nextService, onReturn: onReload),
                const SizedBox(height: Dimensions.padding12),
              ],
              ServiceLogSection(
                group: RepeatServiceGroup.upcoming,
                children: upcoming,
                onReload: onReload,
              ),
              if (upcoming.isNotEmpty) const SizedBox(height: Dimensions.padding12),
              ServiceLogSection(
                group: RepeatServiceGroup.alreadyProvided,
                children: schedule.alreadyProvided,
                onReload: onReload,
              ),
              const SizedBox(height: Dimensions.padding24),
            ],
          ),
        ),
      ),
    );
  }
}
