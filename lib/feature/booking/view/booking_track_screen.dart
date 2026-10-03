import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingTrackScreen extends StatefulWidget {
  const BookingTrackScreen({super.key});

  @override
  State<BookingTrackScreen> createState() => _BookingTrackScreenState();
}

class _BookingTrackScreenState extends State<BookingTrackScreen> {
  late String _countryDialCode = CountryCode.fromCountryCode(
    Get.find<SplashController>().configModel.content?.countryCode ?? 'BD',
  ).dialCode!;

  @override
  void initState() {
    super.initState();
    Get.find<BookingDetailsController>().resetTracking(notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'track_booking'.tr,
          centerTitle: false,
          isBackButtonExist: false,
          // actionWidget: GetBuilder<BookingDetailsController>(
          //   builder: (BookingDetailsController controller) => TextButton(
          //     onPressed: controller.resetTracking,
          //     child: Text('reset'.tr, style: context.heading.defaultSize),
          //   ),
          // ),
        ),
        body: GetBuilder<BookingDetailsController>(
          builder: (BookingDetailsController controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.padding16),
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Column(
                    children: <Widget>[
                      BookingSectionCard(
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                              isFromOfflinePayment: true,
                              hintText: 'booking_id'.tr,
                              controller: controller.bookingIdController,
                              isShowBorder: true,
                              inputType: TextInputType.text,
                              prefixIcon: Images.trackService,
                            ),
                            const SizedBox(height: Dimensions.padding16),
                            CustomTextField(
                              isFromOfflinePayment: true,
                              hintText: 'phone_number'.tr,
                              controller: controller.phoneController,
                              isShowBorder: true,
                              inputType: TextInputType.phone,
                              countryDialCode: _countryDialCode,
                              onCountryChanged: (CountryCode code) =>
                                  _countryDialCode = code.dialCode ?? _countryDialCode,
                            ),
                            const SizedBox(height: Dimensions.padding20),
                            CustomButton(
                              buttonText: 'track_booking'.tr,
                              radius: Dimensions.radius8,
                              isLoading: controller.isTracking,
                              onPressed: () => _track(controller),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.05),
                      if (!controller.isTracking) _TrackResult(controller: controller),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _track(BookingDetailsController controller) async {
    final String readableId = controller.bookingIdController.text.trim();
    final String phoneInput = controller.phoneController.text.trim();

    if (readableId.isEmpty) {
      customSnackBar('please_enter_booking_id'.tr, type: ToasterMessageType.info);
      return;
    }
    if (phoneInput.isEmpty) {
      customSnackBar('please_enter_phone_number'.tr, type: ToasterMessageType.info);
      return;
    }

    final String validated = PhoneVerificationHelper.isPhoneValid(
      _countryDialCode + phoneInput,
      fromAuthPage: true,
    );
    if (validated.isEmpty) {
      customSnackBar('phone_number_with_valid_country_code'.tr, type: ToasterMessageType.info);
      return;
    }

    final String phone = _countryDialCode + validated;
    final bool found = await controller.loadTrackedBooking(readableId: readableId, phone: phone);

    if (found) {
      Get.toNamed<void>(RouteHelper.getBookingDetailsRoute(
        bookingId: readableId,
        phone: phone,
        fromPage: 'track-booking',
      ));
    }
  }
}

class _TrackResult extends StatelessWidget {
  final BookingDetailsController controller;

  const _TrackResult({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.trackAttempted) {
      return NoDataScreen(
        text: 'enter_your_service_id_phone_number_to_get_service_updates'.tr,
        type: NoDataType.service,
      );
    }
    if (controller.booking == null) {
      return NoDataScreen(text: 'no_booking_found'.tr, type: NoDataType.bookings);
    }
    return const SizedBox.shrink();
  }
}
