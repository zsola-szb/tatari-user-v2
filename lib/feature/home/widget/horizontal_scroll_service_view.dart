import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class HorizontalScrollServiceView extends GetView<ServiceController> {
  final String? fromPage;
  final List<Service>? serviceList;
  const HorizontalScrollServiceView({super.key, required this.fromPage,required this.serviceList});
  @override
  Widget build(BuildContext context) {

    ScrollController scrollController = ScrollController();
    if(serviceList != null && serviceList!.isEmpty){
      return const SizedBox();
    }else{
      if(serviceList!= null){
        final double itemWidth = ResponsiveHelper.isTab(context)? 250 : Get.width / 2.3;

        return Column(
          children: [
            const SizedBox(height: Dimensions.padding10),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimensions.padding16,
                Dimensions.padding10,
                Dimensions.padding16,
                Dimensions.padding6,
              ),
              child: TitleWidget(
                title: fromPage!,
                isShowSeeAllButton: false,
              ),
            ),

            SizedBox(
              height: ServiceWidgetVertical.heightFor(context, itemWidth) + (Dimensions.padding12),
              child:ListView.builder(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: Dimensions.padding16,bottom: Dimensions.padding6,top: Dimensions.padding6),
                itemCount: serviceList!.length > 10 ? 10 : serviceList!.length,
                itemBuilder: (context, index){
                  return Padding(padding: const EdgeInsets.only(right: Dimensions.padding16),
                    child: SizedBox(
                      width: itemWidth,
                      child: ServiceWidgetVertical(service: serviceList![index], fromType: '',fromPage: fromPage??""),
                    ),
                  );
                },
              ) ,
            ),
            const SizedBox(height: Dimensions.padding16),

            Divider(color: Theme.of(context).hintColor.withValues(alpha: 0.2), thickness: Dimensions.padding6)
          ],
        );
      }
      else{
        return const PopularServiceShimmer(enabled: true,);
      }
    }
  }
}


class PopularServiceShimmer extends StatelessWidget {
  final bool enabled;
  const PopularServiceShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: Dimensions.padding10,left: Dimensions.padding10,top: Dimensions.padding10,),
        itemCount: 10,
        itemBuilder: (context, index){
          return Container(
            height: 80, width: ResponsiveHelper.isTab(context)? 250 : Get.width / 2.3,
            margin: const EdgeInsets.only(right: Dimensions.padding10,bottom: 10,top: 10),
            padding: const EdgeInsets.all(Dimensions.padding6),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius6),
              boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius6),
                      color: Theme.of(context).shadowColor
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.padding6),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 15, width: 100, color: Theme.of(context).shadowColor),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 130, color: Theme.of(context).shadowColor),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 130, color: Theme.of(context).shadowColor),

                    ]),
                  ),
                ),

              ]),
            ),
          );
        },
      ),
    );
  }
}

