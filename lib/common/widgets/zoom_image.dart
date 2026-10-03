import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:photo_view/photo_view.dart';


class ZoomImage extends StatefulWidget {
  final String image;
  final String imagePath;
  final String? createdAt;
  const ZoomImage({super.key, required this.image, required this.imagePath, this.createdAt})
      ;

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  bool isZoomed = false;


  @override
  Widget build(BuildContext context) {


    return CustomPopWidget(
      child: Scaffold(
        appBar: isZoomed ? null : CustomAppBar(title: widget.image, subTitle: widget.createdAt, centerTitle: false,),
        endDrawer: null,
        body: FooterBaseView(
          isScrollView: false,
          child: Center(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(
                initialScale: PhotoViewComputedScale.contained,
      
                scaleStateChangedCallback: (value) {
                  if (value != PhotoViewScaleState.initial) {
                    isZoomed = true;
                  } else {
                    isZoomed = false;
                  }
                  setState(() {});
                },
      
                minScale: PhotoViewComputedScale.contained,
                imageProvider: NetworkImage(widget.imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}