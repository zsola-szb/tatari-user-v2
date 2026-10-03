import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ServiceHeroHeader extends StatelessWidget {
  final Service service;
  final double height;
  const ServiceHeroHeader({super.key, required this.service, required this.height});

  static double coverHeight(BuildContext context) {
    final double contentWidth = MediaQuery.sizeOf(context).width > Dimensions.webMaxWidth
        ? Dimensions.webMaxWidth : MediaQuery.sizeOf(context).width;
    return contentWidth * 0.55 + MediaQuery.of(context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top + Dimensions.padding10;

    return ClipRRect(
      borderRadius: BorderRadius.all(const Radius.circular(Dimensions.radius8)),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImage(image: service.coverImageFullPath ?? ""),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),

            Positioned(
              top: topInset,
              left: Dimensions.padding16,
              child: ServiceFloatingCircleButton(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, size: 20, color: context.customThemeColors.textColor),
              ),
            ),

            Positioned(
              top: topInset,
              right: Dimensions.padding16,
              child: ServiceFloatingCircleButton(
                child: FavoriteIconWidget(
                  serviceId: service.id,
                  value: service.isFavorite,
                  size: 40,
                  iconSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
