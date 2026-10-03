import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/helper/data_sync_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignRepo campaignRepo;
  CampaignController({required this.campaignRepo});

  List<CampaignData>? _campaignList ;
  int? _currentIndex = 0;

  List<CampaignData>? get campaignList => _campaignList;
  int? get currentIndex => _currentIndex;

  Future<void> getCampaignList(bool reload) async {
    if(_campaignList == null || reload){

      DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=>campaignRepo.getCampaignList<CacheResponseData>( source: DataSourceEnum.local),
        fetchFromClient: ()=> campaignRepo.getCampaignList(source: DataSourceEnum.client),
        onResponse: (data, source) {
          _campaignList = CampaignModel.fromJson(data).campaigns;
          update();
        },
      );
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void navigateFromCampaign(CampaignData campaign) {
    final String? campaignId = campaign.id;
    if(campaignId == null){
      return;
    }
    Get.toNamed(RouteHelper.getCampaignDetailsRoute(campaignId), arguments: campaign);
  }
}