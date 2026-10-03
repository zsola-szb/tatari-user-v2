import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';


class CouponScreen extends StatefulWidget {
  final bool fromCheckout;
  const CouponScreen({super.key, required this.fromCheckout}) ;

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> with TickerProviderStateMixin{
  TabController? _couponTabController;


  @override
  initState() {
    _couponTabController = TabController(vsync: this, length: 2, initialIndex: 0);
    Get.find<CouponController>().getCouponList();
    _couponTabController?.addListener(() {
      Get.find<CouponController>().updateTabBar(
        _couponTabController?.index == 0 ?  CouponTabState.currentCoupon : CouponTabState.usedCoupon,
      );
    });

    Get.find<CouponController>().updateSelectedCouponIndex(index: -1, shouldUpdate: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(title: "voucher".tr, centerTitle: true,),
        body: GetBuilder<CouponController>(
            builder: (couponController){
              List<CouponModel>? activeCouponList = couponController.activeCouponList;
              List<CouponModel>? expiredCouponList = couponController.expiredCouponList;
              return ((activeCouponList != null && activeCouponList.isEmpty) && (expiredCouponList != null && expiredCouponList.isEmpty)) ?
              NoDataScreen(text: "no_coupon_found".tr,type: NoDataType.coupon) :
              (activeCouponList != null && expiredCouponList!=null) ?
              Column(children: [

                Container(
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _couponTabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 2.5,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).hintColor,
                    labelStyle: context.heading.small,
                    unselectedLabelStyle: context.subHeading.small,
                    tabs: [
                      Tab(text: '${'current_voucher'.tr} (${activeCouponList.length})'),
                      Tab(text: '${'used_voucher'.tr} (${expiredCouponList.length})'),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _couponTabController,
                      children: [
                    _CouponList(couponList: activeCouponList, fromCheckout: widget.fromCheckout),
                    _CouponList(couponList: expiredCouponList, isExpired: true, fromCheckout: widget.fromCheckout),
                  ]),
                ),
              ],) : const Center(child: CircularProgressIndicator());
            }

        ),
      ),
    );
  }
}

class _CouponList extends StatelessWidget {
  final List<CouponModel> couponList;
  final bool isExpired;
  final bool fromCheckout;
  const _CouponList({required this.couponList, required this.fromCheckout, this.isExpired = false});

  @override
  Widget build(BuildContext context) {
    return couponList.isNotEmpty ?
    ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding8),
      itemBuilder: (context, index) {
        return CouponCardWidget(
          isExpired: isExpired,
          couponModel: couponList[index],
          index: index,
          fromCheckout: fromCheckout,
        );
      },
      itemCount: couponList.length,
    ) : Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.padding16),
        child: Text(
          isExpired ? 'no_expired_coupon_found'.tr : 'no_active_coupon_found'.tr,
          style: context.body.defaultSize,
        ),
      ),
    );
  }
}
