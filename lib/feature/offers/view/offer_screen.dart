import 'package:tatarigigs_user/feature/offers/widget/offers_filter_row.dart';
import 'package:tatarigigs_user/feature/offers/widget/offers_list_body.dart';
import 'package:tatarigigs_user/feature/offers/widget/offers_search_header.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class OfferScreen extends StatefulWidget {
  final bool isFromMenu;

  const OfferScreen({super.key, this.isFromMenu = false});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _searchCollapsed = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCollapsed.dispose();
    super.dispose();
  }

  void _expandSearch() {
    if(_scrollController.hasClients){
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
    Get.find<OffersController>().searchFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backGroundColor,
      appBar: CustomAppBar(
        title: '  ${'offers'.tr}',
        isBackButtonExist: widget.isFromMenu,
        bgColor: context.customThemeColors.backGroundColor,
        actionWidget: OffersCollapsedSearchAction(
          collapsedNotifier: _searchCollapsed,
          onTap: _expandSearch,
        ),
      ),
      floatingActionButton: FloatingViewCartButton(backgroundColor: context.customThemeColors.backGroundColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        top: false,
        child: Column(children: [
          OffersSearchHeader(
            scrollController: _scrollController,
            collapsedNotifier: _searchCollapsed,
          ),

          const OffersFilterRow(),

          Expanded(child: OffersListBody(scrollController: _scrollController)),
        ]),
      ),
    );
  }
}