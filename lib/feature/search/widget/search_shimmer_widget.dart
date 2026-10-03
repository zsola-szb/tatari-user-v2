import 'package:tatarigigs_user/util/core_export.dart';

class SearchShimmerWidget extends StatelessWidget {
  const SearchShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(children: [

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding16),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                Container(height: 20, width: 30, decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius6),
                ),),
                const SizedBox(width: Dimensions.padding10),
                Container(height: 20, width: 90,  decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius6),
                ),),
              ]),
            ),
          ),

          const SizedBox(height: Dimensions.padding16,),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Container(height: 25, width: 80, decoration: BoxDecoration(
                      color:  Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius6),
                    ),),
                  ),

                ],
              ),

              Row(children: [
                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 40, width: 40, decoration: BoxDecoration(
                    color:  Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius6),
                  ),),
                ),

                const SizedBox(width: Dimensions.padding16,),

                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 40, width: 40, decoration: BoxDecoration(
                    color:  Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius6),
                  ),),
                ),

              ],)
            ],),
          ),

          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.padding16,
              mainAxisSpacing:  Dimensions.padding16,
              mainAxisExtent: 240,
              crossAxisCount: ResponsiveHelper.isTab(context) ? 3 : 2,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap:  true, itemCount: 15,
            padding: const EdgeInsets.all(Dimensions.padding16),
            itemBuilder: (context, index) {
              return const ServiceShimmer(isEnabled: true, hasDivider: true,);
            },
          )
        ],),
      ),
    );
  }
}
