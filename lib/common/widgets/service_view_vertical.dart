import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ServiceViewVertical extends GetView<ServiceController> {
  final List<Service>? service;
  final EdgeInsetsGeometry? padding;
  final bool? isScrollable;
  final int? shimmerLength;
  final String? noDataText;
  final String? type;
  final NoDataType? noDataType;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final String? fromPage;

  final Function(String type)? onVegFilterTap;
  const ServiceViewVertical( {super.key, this.fromPage="", required this.service, this.isScrollable = false, this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(Dimensions.padding10), this.noDataText, this.type, this.onVegFilterTap, this.noDataType, this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 1;

    isNull = service == null;
    if(!isNull){
      length = service!.length;
    }

    return LayoutBuilder(builder: (context, constraints) {

      final int crossAxisCount = ResponsiveHelper.isTab(context) ? 3 : 2;
      final double itemWidth = (constraints.maxWidth - (padding?.horizontal ?? 0) - (Dimensions.padding16 * (crossAxisCount - 1))) / crossAxisCount;
      final double itemHeight = ServiceWidgetVertical.heightFor(context, itemWidth);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isNull == false &&  length != 0 ?
          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.padding16,
              mainAxisSpacing:  Dimensions.padding16,
              mainAxisExtent: itemHeight ,
              crossAxisCount: crossAxisCount ),
            physics: isScrollable! ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            shrinkWrap: isScrollable! ? false : true,
            itemCount: service!.length,
            padding: padding,
            itemBuilder: (context, index) {
              return ServiceWidgetVertical(service: service![index], fromType: '',fromPage: fromPage??"", signInShakeKey: signInShakeKey,);
            },
          ) : length == 0 ? Center(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.55,
              child: noDataType == NoDataType.offers ? NoDataScreen(
                  text: "no_offer_found".tr,
                  type:  NoDataType.offers,
                ) : ServiceNotAvailableScreen(fromPage: fromPage ?? "",),
            ),
          ) : GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.padding16,
              mainAxisSpacing:  Dimensions.padding16,
              mainAxisExtent: itemHeight ,
              crossAxisCount: crossAxisCount,
            ),
            physics: isScrollable! ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            shrinkWrap: isScrollable! ? false : true,
            itemCount: shimmerLength,
            padding: padding,
            itemBuilder: (context, index) {
              return ServiceShimmer(isEnabled: true, hasDivider: index != shimmerLength! - 1);
            },
          ),
        ],
      );
    });
  }
}