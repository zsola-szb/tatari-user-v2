import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceTabController extends GetxController with GetTickerProviderStateMixin{
  final ServiceDetailsRepo serviceDetailsRepo;
  ServiceTabController({required this.serviceDetailsRepo});

  final ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {};
  List<String> _sectionOrder = [];

  int _activeSectionIndex = 0;
  int get activeSectionIndex => _activeSectionIndex;

  bool _showPinnedHeader = false;
  bool get showPinnedHeader => _showPinnedHeader;

  bool _suppressSpy = false;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  bool hasVariations(Service? service) => service?.variationsAppFormat?.zoneWiseVariations?.isNotEmpty ?? false;
  bool hasFaqs(Service? service) => service?.faqs?.isNotEmpty ?? false;
  bool hasDescription(Service? service) => service?.description?.trim().isNotEmpty ?? false;

  bool _hasReviews = false;
  bool get hasReviews => _hasReviews;

  void updateHasReviews({required bool hasReviews, Service? service}) {
    if (_hasReviews == hasReviews) {
      return;
    }
    _hasReviews = hasReviews;
    rebuildSectionKeys(service);
    update();
  }

  List<String> _availableSectionIds(Service? service) {
    return [
      if (hasVariations(service)) "variations",
      if (hasDescription(service)) "overview",
      if (hasReviews) "reviews",
      if (hasFaqs(service)) "faqs",
    ];
  }

  String _titleFor(String sectionId) {
    switch (sectionId) {
      case "variations":
        return "service_variation".tr;
      case "faqs":
        return "faqs".tr;
      case "reviews":
        return "reviews".tr;
      case "overview":
      default:
        return "service_overview".tr;
    }
  }

  List<String> sectionTitles(Service? service) => _availableSectionIds(service).map(_titleFor).toList();

  void rebuildSectionKeys(Service? service) {
    final List<String> order = _availableSectionIds(service);
    if (_sectionOrder.join(',') == order.join(',')) {
      return;
    }
    _sectionOrder = order;
    sectionKeys
      ..clear()
      ..addEntries(order.map((id) => MapEntry(id, GlobalKey())));
    _activeSectionIndex = 0;
  }

  void onScroll(double heroHeight, double middlePoint) {
    final bool nextShowPinnedHeader = scrollController.hasClients && scrollController.offset > (heroHeight - 120);
    int nextActiveIndex = _activeSectionIndex;

    if (!_suppressSpy) {
      for (int i = 0; i < _sectionOrder.length; i++) {
        final renderObject = sectionKeys[_sectionOrder[i]]?.currentContext?.findRenderObject();
        if (renderObject is RenderBox && renderObject.attached) {
          final double top = renderObject.localToGlobal(Offset.zero).dy;
          if (top <= middlePoint) {
            nextActiveIndex = i;
          }
        }
      }
      if (scrollController.hasClients &&
          scrollController.position.pixels >= scrollController.position.maxScrollExtent - 10) {
        nextActiveIndex = _sectionOrder.length - 1;
      }
    }

    if (nextShowPinnedHeader != _showPinnedHeader || nextActiveIndex != _activeSectionIndex) {
      _showPinnedHeader = nextShowPinnedHeader;
      _activeSectionIndex = nextActiveIndex;
      update();
    }
  }

  Future<void> scrollToSection(int index, double topThreshold) async {
    if (index < 0 || index >= _sectionOrder.length || !scrollController.hasClients) {
      return;
    }
    _suppressSpy = true;
    _activeSectionIndex = index;
    update();

    final renderObject = sectionKeys[_sectionOrder[index]]?.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final double targetGlobalY = renderObject.localToGlobal(Offset.zero).dy;
      final double targetOffset = scrollController.offset + targetGlobalY - topThreshold;
      await scrollController.animateTo(
        targetOffset.clamp(0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    _suppressSpy = false;
  }

  bool? _isLoading;
  int? _pageSize = 0;
  ReviewContent? reviewContent;
  List<Review>? _reviewList;
  List<Review>? get reviewList => _reviewList;
  bool get isLoading => _isLoading!;
  int? get pageSize => _pageSize!;
  Rating? _rating;
  String? _serviceID;
  int? _offset = 1;
  Rating get rating => _rating!;
  int? get offset => _offset;
  String? get serviceID => _serviceID;


  void updateProviderReviewExpendedStatus({int? index, bool shouldUpdate = true}){
    if(index  !=null){
      final int current = _reviewList?[index].isExpended ?? 0;
      _reviewList?[index].isExpended = current == 1 ? 0 : 1;
      if(shouldUpdate){
        update();
      }
    } else{
      if(_reviewList !=null && reviewList!.isNotEmpty){
        for(int index = 0; index < _reviewList!.length ; index ++){
          _reviewList?[index].isExpended = 0;
        }
      }
    }
  }
}
