import '../../service/model/service_model.dart';

class CategoryModelItem {
  final String title;
  final String categoryId;
  final bool isPopularSection;

  final List<Service> serviceList = <Service>[];

  bool isLoading = false;
  bool hasLoaded = false;
  int loadedPage = 0;
  int totalSize = 0;

  CategoryModelItem({
    required this.title,
    this.categoryId = '',
    this.isPopularSection = false,
  });

  bool get hasMore => hasLoaded && serviceList.length < totalSize;

  bool get isEmptyAfterLoad => hasLoaded && serviceList.isEmpty;
}
