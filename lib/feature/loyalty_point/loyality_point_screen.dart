import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointScreen extends StatelessWidget {
  final String? fromNotification;
  const LoyaltyPointScreen({super.key, this.fromNotification}) ;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return GetBuilder<SplashController>(
        builder: (splashController) {
          if(splashController.currentDataSource == DataSourceEnum.client && splashController.configModel.content?.loyaltyPointStatus == 0){
            Future.delayed(const Duration(microseconds: 100)).then((value) {
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            });
          }
          return CustomPopWidget(
            child: Scaffold(
              backgroundColor: context.customThemeColors.backGroundColor,
              appBar: CustomAppBar(
                title: 'loyalty_point'.tr,
                actionWidget: InkWell(
                  onTap: (){
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      transitionDuration: const Duration(milliseconds: 500),
                      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                      barrierColor: Colors.black.withValues(alpha: 0.5),
                      pageBuilder: (context, _, a) {
                        return const LoyaltyPointUsesManualDialog();
                      },
                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ).drive(Tween<Offset>(
                            begin: const Offset(0, -1.0),
                            end: Offset.zero,
                          )),
                          child: child,
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,0, 15, 0),
                    child: Image.asset(Images.info,width: 20,height: 20),
                  ),
                ),
                onBackPressed: (){
                  if(fromNotification == "fromNotification"){
                    Get.offAllNamed(RouteHelper.getMainRoute("home"));
                  }else{
                    Get.back();
                  }
                },
                bgColor: Theme.of(context).cardColor,
              ),
              body: GetBuilder<LoyaltyPointController>(initState: (_){
                Get.find<LoyaltyPointController>().getLoyaltyPointData(1);
              },
                  builder: (loyaltyPointController){
                    return loyaltyPointController.loyaltyPointModel !=null ? Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                      const LoyaltyPointTopCard(),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: LoyaltyPointListView(scrollController: scrollController),
                        ),
                      ),
                    ]) :
                    Center(child: SizedBox(
                      height: Get.height * 0.85,
                      child: const Center(child: CircularProgressIndicator()),
                    ));
                  }),
            ),
          );
        }
    );
  }
}
