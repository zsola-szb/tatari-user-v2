import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/area/widget/area_top_widget.dart';
import 'package:tatarigigs_user/feature/area/widget/area_view_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceAreaScreen extends StatefulWidget {
  const ServiceAreaScreen({super.key}) ;

  @override
  State<ServiceAreaScreen> createState() => _ServiceAreaScreenState();
}

class _ServiceAreaScreenState extends State<ServiceAreaScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<ServiceAreaController>().getZoneList(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      isExit: true,
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar: CustomAppBar(centerTitle: false, title: 'our_services_areas'.tr,showCart: false),
        body: GetBuilder<ServiceAreaController>(builder: (serviceAreaController){
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Column( children: [

              const AreaTopWidget(),

              const AreaViewWidget(),

              const SizedBox(height: 100)
            ]),
          );
        }),


        bottomSheet: SizedBox( height: 80,
          child: Center(
            child: Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: CustomButton(
                radius: Dimensions.radius8,
                buttonText: 'view_on_map'.tr,
                onPressed: () {
                  Get.toNamed(RouteHelper.getServiceAreaMap());
                },
              ),
            ),
          ),
        ),


      ),
    );
  }
}
