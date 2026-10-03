import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class ServiceDetailsController extends GetxController implements GetxService{
  final ServiceDetailsRepo serviceDetailsRepo;
  ServiceDetailsController({required this.serviceDetailsRepo});

  Service? _service;
  bool? _isLoading;
  Service? get service => _service;
  bool get isLoading => _isLoading!;

  List<Service> _relatedServices = <Service>[];
  List<Service> get relatedServices => _relatedServices;

  List<ProviderData> _serviceProviders = <ProviderData>[];
  List<ProviderData> get serviceProviders => _serviceProviders;


  ///discount and discount type based on category discount and service discount
  double? _serviceDiscount = 0.0;
  double get serviceDiscount => _serviceDiscount!;

  String? _discountType;
  String get discountType => _discountType!;


  Future<void> getServiceDetails(String slug, {String fromPage = ""}) async {
    _service = null;
    _relatedServices = <Service>[];
    _serviceProviders = <ProviderData>[];

    Response response = await serviceDetailsRepo.getServiceDetails(slug, fromPage);
    if (response.body['response_code'] == 'default_200') {
      final ServiceDetailsItemModel? details = ServiceDetailsModel.fromJson(response.body).service;
      final Service service = details?.toService(fallbackSlug: slug) ?? Service();

      _service = service;
      _relatedServices = details?.toRelatedServiceList() ?? <Service>[];
      _serviceProviders = details?.serviceProviders ?? <ProviderData>[];

      Get.find<CartController>().prepareVariationSelections(service);
      Get.find<ServiceTabController>().rebuildSectionKeys(service);

    } else {
      _service = Service();
      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
    }
    _isLoading = false;
    update();
  }


  void updateProviderIsFavoriteValue(int status, String providerId) {
    final int index = _serviceProviders.indexWhere((ProviderData provider) => provider.id == providerId);
    if (index > -1) {
      _serviceProviders[index].isFavorite = status;
      update();
    }
  }


}