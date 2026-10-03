import 'package:tatarigigs_user/util/core_export.dart';


class MyMarker extends StatelessWidget {
  final GlobalKey globalKeyMyWidget;
  final ZoneModel zone;
  const MyMarker(this.globalKeyMyWidget, {super.key, required this.zone});


  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Column(
        children: [

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radius6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding6),
            child: Text(zone.name ?? "", style: context.subHeading.small.copyWith(
              fontWeight: AppWeight.medium,
              color: Colors.black,
              fontSize: ResponsiveHelper.isMobile(context) ? 20 : Dimensions.fontSizeSmall,
            ),),
          ),

          const SizedBox(height: Dimensions.padding6-2,),

          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [

              Image.asset(Images.marker,
                width: ResponsiveHelper.isMobile(context)? 50 : 25, fit: BoxFit.fitWidth,
              ),

            ],
          ),
        ],
      ),
    );
  }
}