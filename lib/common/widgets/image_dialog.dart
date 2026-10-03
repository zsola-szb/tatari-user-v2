import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? subTitle;
  const ImageDialog({super.key, required this.imageUrl,this.title,this.subTitle}) ;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      title:  Align(alignment: Alignment.topRight,
        child: IconButton(icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Padding(
              padding:  const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
              child: Column(
                children: [
                  title!=null?Text(title!,style: context.subHeading.defaultSize.overrideWith(
                    fontWeight: AppWeight.medium,
                    color: Theme.of(context). textTheme.bodyLarge!.color!.withValues(alpha: 0.7),
                  )): const SizedBox.shrink(),

                  SizedBox(height: title!=null? Dimensions.padding16:0,),

                  Container(
                   // width: Get.width * 0.6,
                    constraints: BoxConstraints(maxHeight: 300, maxWidth: Get.width * 0.7),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withValues(alpha: 0.20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomImage(image: imageUrl),
                    ),
                  ),

                  SizedBox(height: subTitle!=null? Dimensions.padding16:0,),
                  subTitle!=null?Text(subTitle!,style: context.body.defaultSize,textAlign: TextAlign.justify,):const SizedBox.shrink(),

                  const SizedBox(height: Dimensions.padding16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
