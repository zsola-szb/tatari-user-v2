import 'package:tatarigigs_user/feature/auth/controller/auth_controller.dart';
import 'package:tatarigigs_user/feature/auth/widgets/login_or_signup_bottom_sheet.dart';
import 'package:tatarigigs_user/feature/profile/controller/user_controller.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/helper/route_helper.dart';
import 'package:tatarigigs_user/util/dimensions.dart';
import 'package:tatarigigs_user/util/images.dart';
import 'package:tatarigigs_user/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderPremiumTagWidget extends StatelessWidget {
  const ProviderPremiumTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController){
      final bool isSubscribed = userController.userInfoModel?.subscribedPlan != null;
      return Container(
        padding: const EdgeInsets.all(Dimensions.padding10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha:0.10),
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Row(spacing: Dimensions.padding10, children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: context.customThemeColors.warning),
            padding: const EdgeInsets.all(Dimensions.padding8),
            child: Image.asset(Images.premiumIcon, height: 14, width: 14),
          ),

          Expanded(
            child: RichText(text: TextSpan(text: isSubscribed ? 'book_now_to_enjoy_exclusive_offer'.tr : 'enjoy_extra_saving_on_every'.tr, children: [
              TextSpan(text: ' ${'pro_plan'.tr}', style: context.heading.small)
            ], style: context.body.small)),
          ),

          if(!isSubscribed)
            InkWell(
              borderRadius: BorderRadius.circular(Dimensions.radius6),
              onTap: (){
                if(Get.find<AuthController>().isLoggedIn()) {
                  Get.toNamed(RouteHelper.getSubscriptionRoute());
                }else{
                  Get.bottomSheet(const LoginOrSignupBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding12, vertical: Dimensions.padding8),              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radius6),
              ),
                child: Text('enroll_now'.tr, style: context.subHeading.small.overrideWith(fontWeight: AppWeight.medium, color: Colors.white)),
              ),
            ),
        ]),
      );
    });
  }
}
