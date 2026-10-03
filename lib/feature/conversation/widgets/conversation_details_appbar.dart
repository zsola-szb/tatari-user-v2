import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ConversationDetailsAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? name;
  final String? image;
  final String? phone;
  final String fromNotification;
  const ConversationDetailsAppBar({super.key, this.name, this.image, this.phone, this.fromNotification =""}) ;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: context.customThemeColors.secondaryBackGroundColor
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImage(image: image),
            ),
          ),
          const SizedBox(width: Dimensions.padding10),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(name?.tr ?? "", style: context.heading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),

              if(phone != "" && Get.find<SplashController>().configModel.content?.phoneNumberVisibility == 1) Padding(padding: const EdgeInsets.only(top: 3),
                child: Text(phone ?? "", style: context.subHeading.defaultSize, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),

            ]),
          ),
        ],
      ),
      leading: IconButton(onPressed: () {
        if(fromNotification == "fromNotification"){
          Get.offNamed(RouteHelper.getInboxScreenRoute(fromNotification: fromNotification));
        }else{
          Get.back();
        }
      },
        icon: Icon(Icons.arrow_back_ios, color:context.customThemeColors.textColor, size: 20),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 55);
}
