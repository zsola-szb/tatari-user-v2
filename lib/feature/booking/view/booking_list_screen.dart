import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/booking/widget/booking_shimmer_view.dart';
import 'package:tatarigigs_user/feature/booking/widget/list/booking_date_header.dart';
import 'package:tatarigigs_user/feature/booking/widget/list/booking_list_row.dart';
import 'package:tatarigigs_user/feature/booking/widget/list/booking_list_tabs.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingListScreen extends StatefulWidget {
  final bool isFromMenu;
  final String? initialTab;

  const BookingListScreen({super.key, this.isFromMenu = false, this.initialTab});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<BookingListController>().initData(
      initialTab: BookingListTab.fromApi(widget.initialTab),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(
          title: 'my_bookings'.tr,
          isBackButtonExist: widget.isFromMenu,
          actionWidget: const BookingListFilterMenu(),
        ),
        body: Column(
          children: <Widget>[
            const BookingListTabs(),
            Expanded(
              child: GetBuilder<BookingListController>(
                builder: (BookingListController controller) {
                  if (controller.isLoading) {
                    return const BookingListShimmerView();
                  }
                  if (controller.isEmpty) {
                    return _EmptyBookingList(controller: controller);
                  }
                  return _BookingListBody(
                    controller: controller,
                    scrollController: _scrollController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingListBody extends StatelessWidget {
  final BookingListController controller;
  final ScrollController scrollController;

  const _BookingListBody({required this.controller, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshCurrentTab,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: PaginatedListView(
              key: ValueKey<String>('${controller.selectedTab}-${controller.serviceType}'),
              scrollController: scrollController,
              totalSize: controller.totalSize,
              offset: controller.page.currentPage,
              onPaginate: (int offset) async => controller.loadBookings(offset: offset, isPagination: true),
              itemView: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Column(
                  children: _rows(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _rows(BuildContext context) {
    final List<Widget> children = <Widget>[];
    int rowIndex = 0;

    for (final BookingListSection section in controller.sections) {
      children.add(BookingDateHeader(section: section));

      for (int index = 0; index < section.bookings.length; index++) {
        if (index > 0) {
          children.add(Divider(height: 1, thickness: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.20)));
        }
        children.add(BookingListRow(booking: section.bookings[index], index: rowIndex));
        rowIndex++;
      }
    }
    return children;
  }
}

class _EmptyBookingList extends StatelessWidget {
  final BookingListController controller;

  const _EmptyBookingList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshCurrentTab,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: Get.height * 0.65,
          child: NoDataScreen(
            text: 'no_booking_request_available'.tr,
            type: NoDataType.bookings,
          ),
        ),
      ),
    );
  }
}
