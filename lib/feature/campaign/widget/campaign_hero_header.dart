import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CampaignHeroHeader extends StatelessWidget {
  final String coverImage;
  final double height;
  const CampaignHeroHeader({super.key, required this.coverImage, required this.height});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = !ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context);

    return ClipRRect(
      borderRadius: BorderRadius.all(isDesktop ? const Radius.circular(Dimensions.radius8) : Radius.zero),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomImage(image: coverImage, placeholder: Images.placeholder),

            PositionedDirectional(
              top: MediaQuery.of(context).padding.top + Dimensions.padding16,
              start: Dimensions.padding16,
              child: ServiceFloatingCircleButton(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, size: 20, color: context.customThemeColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
