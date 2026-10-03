import 'package:get/get.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class ProfileHeader extends GetView<UserController> {
  final UserInfoModel? userInfoModel;
   const ProfileHeader({super.key,required this.userInfoModel}) ;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return GetBuilder<UserController>(builder: (userController){
      return Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20, horizontal: Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(Dimensions.radius20), bottomLeft: Radius.circular(Dimensions.radius20)),
        ),
        child: Column(children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(150.0)),
                child: CustomImage(
                  width: 84.0,
                  height: 84.0,
                  image: userController.userInfoModel?.imageFullPath ?? "",
                ),
              ),

              if(userController.userInfoModel?.subscribedPlan != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ]
                  ),
                  child: Image.asset(Images.premiumIcon, height: 16, width: 16, color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.padding12),

          if(!isLoggedIn)...[
            Text('guest_user'.tr, style: context.heading.large),
            const SizedBox(height: Dimensions.padding6),

            CustomButton(
              width: Get.width * 0.6,
              height: 40,
              buttonText: 'login_to_continue'.tr,
              onPressed: (){
                Get.bottomSheet(const LoginOrSignupBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true);
              },
            )
          ],

          if( isLoggedIn && userInfoModel?.fName != null && userInfoModel?.lName != null )
            Text("${userInfoModel?.fName!} ${userInfoModel?.lName!}", style: context.heading.large, textAlign: TextAlign.center),

          if(isLoggedIn && userInfoModel?.createdAt != null) ...[
            const SizedBox(height: Dimensions.padding4),
            Text(
              '${'joined_at'.tr} ${DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(userInfoModel!.createdAt!))}',
              style: context.body.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
            ),
          ],

          if(isLoggedIn)
          const SizedBox(height: Dimensions.padding16),

          isLoggedIn ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(userInfoModel?.bookingsCount != null)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
                      decoration: BoxDecoration(
                        color: context.customThemeColors.secondaryBackGroundColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                      ),
                      child: ColumnText(
                        amount: (userInfoModel?.bookingsCount ?? 0).toString(),
                        title: 'bookings'.tr,
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.padding12),
                    decoration: BoxDecoration(
                      color: context.customThemeColors.secondaryBackGroundColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius12),
                    ),
                    child: ColumnText(
                      accountAgo: Get.find<UserController>().createdAccountAgo.tr,
                      amount: PriceConverter.convertPrice(userInfoModel?.totalBookingAmount ?? 0),
                      title: 'booking_placed'.tr,
                    ),
                  ),
                ),
              ],
            ),
          ) : const SizedBox(),
        ]),
      );
    });
  }
}
