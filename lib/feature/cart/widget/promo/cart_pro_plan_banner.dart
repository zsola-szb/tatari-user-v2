import 'package:tatarigigs_user/feature/subscription/widget/pro_plan_sheet.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class CartProPlanBanner extends StatelessWidget {
  const CartProPlanBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(Dimensions.padding12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[primary, Color.lerp(primary, Colors.black, 0.18) ?? primary],
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Image.asset(Images.premiumIcon, height: 18, width: 18),
          ),
          const SizedBox(width: Dimensions.padding10),

          Expanded(
            child: Text.rich(
              TextSpan(
                text: '${'enjoy_extra_saving_on_every'.tr} ',
                style: context.body.small.overrideWith(color: Colors.white),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'pro_plan'.tr,
                    style: context.heading.small.overrideWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Dimensions.padding10),

          InkWell(
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            onTap: (){
              if(Get.find<AuthController>().isLoggedIn()){
                openProPlanSheet(context);
              }else{
                Get.bottomSheet(const LoginOrSignupBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.padding12,
                vertical: Dimensions.padding8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius8),
              ),
              child: Text('enrol_now'.tr,
                style: context.heading.small.overrideWith(color: primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
