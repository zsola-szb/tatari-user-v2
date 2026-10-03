import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget? child;
  const NoInternetScreen({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.noInternet, width: 150, height: 150),
            Text('oops'.tr, style: context.heading.extraLarge.copyWith(
              fontSize: 30,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            const SizedBox(height: Dimensions.padding6),
            Text(
              'no_internet_connection'.tr,
              textAlign: TextAlign.center,
              style: context.subHeading.defaultSize,
            ),
            const SizedBox(height: 40),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                onPressed: () async {
                  List<ConnectivityResult> result = await Connectivity().checkConnectivity();
                  if( result.first != ConnectivityResult.none) {
                    Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (_) => child!));
                  }
                },
                buttonText: 'retry'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
