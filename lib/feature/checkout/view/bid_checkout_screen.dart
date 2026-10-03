import 'package:tatarigigs_user/feature/checkout/widget/booking_type/instant_service_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/checkout_bottom_bar.dart';
import 'package:tatarigigs_user/feature/checkout/widget/checkout_shimmer_view.dart';
import 'package:tatarigigs_user/feature/checkout/widget/common/checkout_section_card.dart';
import 'package:tatarigigs_user/feature/checkout/widget/location/get_service_at_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/checkout/widget/payment/payment_method_section.dart';
import 'package:tatarigigs_user/feature/checkout/widget/summary/billing_summary_section.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BidCheckoutScreen extends StatefulWidget {
  final String postId;
  final String providerId;
  final String bidId;
  final double amount;

  const BidCheckoutScreen({
    super.key,
    required this.postId,
    required this.providerId,
    required this.bidId,
    required this.amount,
  });

  @override
  State<BidCheckoutScreen> createState() => _BidCheckoutScreenState();
}

class _BidCheckoutScreenState extends State<BidCheckoutScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CheckoutController>().initData(
      flow: CheckoutFlow.bid,
      postId: widget.postId,
      providerId: widget.providerId,
      bidId: widget.bidId,
      bidAmount: widget.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: SafeArea(
        child: GetBuilder<CheckoutController>(
          builder: (CheckoutController controller) {
            if (controller.isPageLoading) {
              return const CheckoutShimmerView(showBookingTypeTabs: false);
            }

            final CheckoutTotals totals = controller.displayTotals;

            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Column(
                          children: <Widget>[
                            _BidServiceCard(details: controller.postDetails),
                            const SizedBox(height: Dimensions.padding16),
                            const InstantServiceSection(),
                            const SizedBox(height: Dimensions.padding16),
                            const GetServiceAtSection(),
                            const SizedBox(height: Dimensions.padding16),
                            const PaymentMethodSection(),
                            const SizedBox(height: Dimensions.padding16),
                            const BillingSummarySection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                CheckoutBottomBar(
                  total: totals.dueAmount,
                  originalTotal: totals.originalTotal,
                  showStrikethrough: totals.hasDiscount,
                  isLoading: controller.isLoading,
                  canConfirm: widget.amount > 0,
                  onConfirm: () => controller.submitBooking(
                    onPaymentMethodMissing: () => CheckoutPaymentMethodSheet.open(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BidServiceCard extends StatelessWidget {
  final BidPostDetailsContent? details;

  const _BidServiceCard({required this.details});

  @override
  Widget build(BuildContext context) {
    final BidPostDetailsContent? post = details;
    if (post == null) {
      return const SizedBox();
    }

    final String description = post.serviceDescription ?? '';
    final String serviceName = post.serviceName?.trim() ?? '';
    final String title = serviceName.isNotEmpty
        ? serviceName
        : (BusinessModelHelper.isOpenMarket ? (post.categoryName ?? 'service'.tr) : 'service'.tr);

    return CheckoutSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.heading.large,
          ),
          if (description.isNotEmpty) ...<Widget>[
            const SizedBox(height: Dimensions.padding6),
            Text(description, style: context.body.small),
          ],
          if (post.hasAdditionalInstruction) ...<Widget>[
            const SizedBox(height: Dimensions.padding16),
            Text(
              'additional_instruction'.tr,
              style: context.heading.defaultSize,
            ),
            const SizedBox(height: Dimensions.padding6),
            ...?post.additionInstructions?.map(
              (AdditionInstructions instruction) => Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.padding4),
                child: Text(
                  '•  ${instruction.details ?? ''}',
                  style: context.body.small,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
