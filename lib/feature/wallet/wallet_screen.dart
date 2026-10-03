import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  final String? status;
  final String? token;
  final String? fromNotification;
  const WalletScreen({super.key, required this.status, this.token, this.fromNotification}) ;
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final tooltipController = JustTheController();

  @override
  void initState() {
    super.initState();

    Get.find<WalletController>().getWalletTransactionData(1);
    Get.find<WalletController>().getBonusList(false);
    Get.find<WalletController>().insertFilterList();


    Future.delayed(const Duration(seconds: 1)).then((value){
      if(widget.status != null && widget.status!.contains("success") && Get.find<WalletController>().getWalletAccessToken() != widget.token){
        customSnackBar("message", customWidget: Row(children: [
          const SizedBox(width: Dimensions.padding16,),
          const Icon(Icons.check_circle, color: Colors.white70,),
          const SizedBox(width: Dimensions.padding16,),
          Text("fund_added_successfully".tr, style: Get.context!.subHeading.defaultSize.overrideWith(color: Colors.white70),)
        ]), borderRadius: Dimensions.radiusFull
        );
      }
    }).then((value) {
      Get.find<WalletController>().setWalletAccessToken(widget.token ?? "");
    });

  }
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GetBuilder<SplashController>(
      builder: (splashController) {
        if(splashController.currentDataSource == DataSourceEnum.client && splashController.configModel.content?.walletStatus == 0){
          Future.delayed(const Duration(microseconds: 100)).then((value) {
            Get.offAllNamed(RouteHelper.getMainRoute("home"));

          });
        }
        return Scaffold(
          backgroundColor: context.customThemeColors.backGroundColor,
          appBar: CustomAppBar(title: 'my_wallet'.tr, actionWidget: InkWell(
            onTap: () {
              showGeneralDialog(
                context: context, barrierDismissible: true, transitionDuration: const Duration(milliseconds: 500),
                barrierLabel: MaterialLocalizations.of(context).dialogLabel, barrierColor: Colors.black.withValues(alpha: 0.5),
                pageBuilder: (context, _, a) {
                  return const WalletUsesManualDialog();
                },
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition( position: CurvedAnimation(parent: animation, curve: Curves.easeOut,
                    ).drive(Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero,)),
                    child: child,
                  );
                },
              );
            },
            child: Padding( padding: const EdgeInsets.fromLTRB(15,0, 15, 0),
              child: Image.asset(Images.info, width: 20, height: 20),
            ),
          ),
            onBackPressed: (){
              if(widget.fromNotification == "fromNotification"){
                Get.offAllNamed(RouteHelper.getMainRoute("home"));
              }else{
                Get.back();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              Get.find<WalletController>().insertFilterList();
              Get.find<WalletController>().getWalletTransactionData(1, reload: true);
            },
            child: GetBuilder<WalletController>(
              builder: (walletController){
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(children: [
                    WalletTopCard(tooltipController: tooltipController),
                    const WalletPromotionalBannerView(),
                    const SizedBox(height: Dimensions.padding16),

                    WalletListView(scrollController: scrollController),
                  ],),
                );
            }),
          ),
        );
      }
    );
  }
}
