import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/feature/area/widget/area_map_view.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceAreaMapScreen extends StatefulWidget {
  const ServiceAreaMapScreen({super.key}) ;

  @override
  State<ServiceAreaMapScreen> createState() => _ServiceAreaMapScreenState();
}

class _ServiceAreaMapScreenState extends State<ServiceAreaMapScreen> {
  @override
  void initState() {
    Get.find<ServiceAreaController>().getZoneList(reload: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      isExit: true,
      child: Scaffold(
        drawer: null,

        endDrawer: null,
        appBar: CustomAppBar(centerTitle: false, title: 'our_services_areas'.tr, showCart: false),
        body: GetBuilder<ServiceAreaController>(builder: (serviceAreaController){
          return  serviceAreaController.zoneList != null ? Column(
            children: [
              Expanded(child: AreaMapViewScreen(zoneList: serviceAreaController.zoneList?? [])),
            ],
          ): Center(child: SizedBox(height : Get.height * 0.9));

        }),
      ),
    );
  }
}
