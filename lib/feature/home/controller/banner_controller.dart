import 'package:tatarigigs_user/api/local/cache_response.dart';
import 'package:tatarigigs_user/helper/data_sync_helper.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({required this.bannerRepo});

  List<BannerModel>? _banners;
  List<BannerModel>? get banners => _banners;

  int? _currentIndex = 0;
  int? get currentIndex => _currentIndex;

  bool _isLaunchingLink = false;

  Future<void> getBannerList(bool reload) async {


    if(_banners == null || reload){
      DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=> bannerRepo.getBannerList<CacheResponseData>( source: DataSourceEnum.local),
        fetchFromClient: ()=> bannerRepo.getBannerList(source: DataSourceEnum.client),
        onResponse: (data, source) {
          _banners = PaginatedEnvelope.rowsOf(data)
              .map((Map<String, dynamic> banner) => BannerModel.fromJson(banner)).toList();
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

  Future<void> navigateFromBanner(BannerModel banner) async {
    final String slug = banner.slug ?? '';

    switch (banner.resourceType) {
      case 'category':
        if (slug.isEmpty) {
          customSnackBar('something_went_wrong'.tr);
          return;
        }
        Get.toNamed(RouteHelper.getCategoryProductRoute(slug, banner.categoryName ?? ''));
        break;

      case 'service':
        if (slug.isEmpty) {
          customSnackBar('something_went_wrong'.tr);
          return;
        }
        Get.toNamed(RouteHelper.getServiceRoute(slug));
        break;

      case 'link':
        await _openExternalLink(banner.redirectLink);
        break;

      default:
    }
  }

  Future<void> _openExternalLink(String? redirectLink) async {
    if (_isLaunchingLink) {
      return;
    }
    _isLaunchingLink = true;

    try {
      final Uri? link = Uri.tryParse(redirectLink ?? '');
      if (link == null || !link.hasScheme || !await canLaunchUrl(link)) {
        customSnackBar('something_went_wrong'.tr);
        return;
      }
      await launchUrl(link);
    } finally {
      _isLaunchingLink = false;
    }
  }
}
