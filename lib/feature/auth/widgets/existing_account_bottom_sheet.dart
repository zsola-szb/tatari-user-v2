import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ExistingAccountBottomSheet extends StatefulWidget {
  final UserInfoModel userInfoModel;
  final String socialLoginMedium;
  final String ? redirectUrl;

  const ExistingAccountBottomSheet({
    super.key,
    required this.userInfoModel,
    required this.socialLoginMedium,
    this.redirectUrl
  });


  @override
  State<ExistingAccountBottomSheet> createState() => _ExistingAccountBottomSheetState();
}

class _ExistingAccountBottomSheetState extends State<ExistingAccountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return pointerInterceptor();
  }

  Padding pointerInterceptor(){
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: GetBuilder<AuthController>(builder: (authProvider){
          return Container(
            width: Dimensions.webMaxWidth,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              const SizedBox(height: Dimensions.padding20),
              Container(
                height: 5, width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                    color: Theme.of(context).hintColor.withValues(alpha: 0.50)
                ),
              ),

              const SizedBox(height: Dimensions.padding20 * 1.5),

              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImage(
                  image: widget.userInfoModel.imageFullPath ?? "",
                  fit: BoxFit.cover, height: 100, width: 100,
                ),
              ),
              const SizedBox(height: Dimensions.padding10),

              Text("${widget.userInfoModel.fName} ${widget.userInfoModel.lName}",
                style: context.subHeading.defaultSize,
              ),
              const SizedBox(height: Dimensions.padding24),

              Text('is_it_you'.tr,
                style: context.heading.large.overrideWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: Dimensions.padding10),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.height * 0.02,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children:[

                    TextSpan(
                      text: 'it_looks_like_the_email'.tr,
                      style: context.body.defaultSize,
                    ),

                    TextSpan(
                      text: ' ${StringParser.obfuscateMiddle(widget.userInfoModel.email??"")} ',
                      style: context.heading.defaultSize.overrideWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                      ),
                    ),

                    TextSpan(
                      text: 'already_used_existing_account'.tr,
                      style: context.body.defaultSize.copyWith(height: 1.2),
                    ),

                  ],),),
              ),
              SizedBox(height: size.height * 0.05),

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Row(children: [
                  Expanded(flex: 5, child: CustomButton(
                    backgroundColor: Theme.of(context).hintColor,
                    isLoading: authProvider.isLoading,
                    buttonText: 'no'.tr,
                    onPressed: (){
                      Navigator.pop(context);
                      authProvider.existingAccountCheck(
                        email: widget.userInfoModel.email!,
                        userResponse: 0,
                        medium: widget.socialLoginMedium,
                        redirectUrl: widget.redirectUrl,
                      );
                    },
                  ),),

                  Expanded(child: Container()),

                  Expanded(flex: 5,child: CustomButton(
                    isLoading: authProvider.isLoading,
                    buttonText : 'yes_its_me'.tr,
                    onPressed: (){
                      Navigator.pop(context);

                      authProvider.existingAccountCheck(
                        email: widget.userInfoModel.email!,
                        userResponse: 1,
                        medium: widget.socialLoginMedium,
                        redirectUrl: widget.redirectUrl,
                      );
                    },
                  ),),
                ],),
              ),
              SizedBox(height: Dimensions.padding20),


            ],),
          );
        }),
    );
  }
}