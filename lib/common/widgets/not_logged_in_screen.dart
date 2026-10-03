import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class NotLoggedInScreen extends StatelessWidget {
  final String redirectUrl;
  final String appbarTitle;
  const NotLoggedInScreen({super.key, required this.redirectUrl, required this.appbarTitle}) ;

  @override
  Widget build(BuildContext context) {
    return CustomPopWidget(
      child: Scaffold(
        endDrawer: null,
      
        appBar: CustomAppBar(title: appbarTitle.tr,),
        body: FooterBaseView(
          isCenter: true,
          child: Padding(
              padding: const EdgeInsets.all(Dimensions.padding20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(Images.guest,
                  width: MediaQuery.of(context).size.height*0.25,
                  height: MediaQuery.of(context).size.height*0.25,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),
                Text('sorry'.tr,
                  style: context.heading.small.copyWith(fontSize: MediaQuery.of(context).size.height * 0.023, color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),
                Text('you_are_not_logged_in'.tr,
                  style: context.body.defaultSize.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.04),
                SizedBox(width: 200,
                  child: CustomButton(buttonText: 'login_to_continue'.tr, height: 40, onPressed: () {
                    Get.bottomSheet(LoginOrSignupBottomSheet(redirectUrl: redirectUrl), backgroundColor: Colors.transparent, isScrollControlled: true);
                  }),
                ),
      
                SizedBox(height: Get.height*0.1,)
      
              ]),
            ),
        ),
      ),
    );
  }
}
