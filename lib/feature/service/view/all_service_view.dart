import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AllServiceView extends StatefulWidget {
  final String? categorySlug;
  const AllServiceView({super.key, this.categorySlug});

  @override
  State<AllServiceView> createState() => _AllServiceViewState();
}

class _AllServiceViewState extends State<AllServiceView> {

  final ScrollController _scrollController = ScrollController();
  int _availableServiceCount = 0;

  @override
  void initState() {
    super.initState();
    _availableServiceCount = Get.find<LocationController>().getUserAddress()?.availableServiceCountInZone ?? 0;
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
        appBar: CustomAppBar(title: 'available_service'.tr, showCart: true),
        drawer: null,
        endDrawer: null,
        body: _availableServiceCount > 0 ? AllServiceListView(
          categorySlug: widget.categorySlug ?? '',
          scrollController: _scrollController,
        ) : FooterBaseView(
          child: Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              height: MediaQuery.of(context).size.height * .6,
              child: const ServiceNotAvailableScreen(),
            ),
          ),
        ),
      ),
    );
  }
}