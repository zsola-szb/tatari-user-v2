import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:skeletonizer/skeletonizer.dart';


class HtmlViewerScreen extends StatefulWidget {
  final HtmlType? type;
  final String? pageKey;
  const HtmlViewerScreen({super.key, required this.type, this.pageKey});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<HtmlViewController>().getPagesContent(widget.pageKey ?? widget.type?.value ?? '');
  }

  @override
  Widget build(BuildContext context) {
    String? data;
    String? image;

    return  GetBuilder<HtmlViewController>(
        builder: (htmlViewController){
          data = htmlViewController.pageDetailsModel?.content ?? '';

          image = htmlViewController.pageDetailsModel?.image;

          return CustomPopWidget(
            child: Scaffold(
              backgroundColor: context.customThemeColors.backGroundColor,
              appBar: CustomAppBar(title: htmlViewController.pageDetailsModel?.title ?? ''),
              body: Skeletonizer(
                enabled: htmlViewController.pageDetailsModel == null,
                child: SingleChildScrollView(
                  child: Column(children: [
                  if( (data?.isNotEmpty ?? false) || (htmlViewController.pageDetailsModel == null))...[
                    const SizedBox(height: Dimensions.padding16),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.padding10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radius6),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: (MediaQuery.sizeOf(context).width / 7),
                                width: double.infinity,
                                child: CustomImage(
                                  fit: BoxFit.cover,
                                  image: image ?? "",
                                  placeholder: Images.businessPagePlaceholder,
                                  placeHolderBoxFit: BoxFit.fill,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),

                    Container(
                      padding:  const EdgeInsets.all(Dimensions.padding16),
                      margin: EdgeInsets.only(top: Dimensions.padding20),
                      decoration: BoxDecoration(
                        color:  Theme.of(context).cardColor,
                      ),
                      child: Column(
                        children: [
                          Html(
                            data: data,
                            style: {
                              "p": Style(
                                fontSize: FontSize.medium,
                              ),

                            },
                          ),
                        ],
                      ),
                    )
                  ]
                  else
                    NoDataScreen(text: 'no_data_found'.tr),
                ]),
                ),
              ),
              floatingActionButton: Get.find<AuthController>().isLoggedIn() ? GetBuilder<ConversationController>(builder: (conversationController){
                return FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  hoverColor:Colors.black26,
                  onPressed: conversationController.isLoading ? null : (){
                    String userId = Get.find<SplashController>().configModel.content!.adminDetails!.id!;
                    String phone = Get.find<SplashController>().configModel.content?.businessPhone??"";
                    String name = "admin";
                    String image = "${Get.find<SplashController>().configModel.content?.faviconFullPath}";
                    Get.find<ConversationController>().createChannel(userId, "",name: name,image: image,fromBookingDetailsPage: false,phone: phone);
                  },
                  child: Center(child: conversationController.isLoading ? const SizedBox(
                    height: 25, width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ) : Image.asset(Images.adminChat,scale: 2.8,)),
                );

              }) : null,
            ),
          );
      }
    );
  }
}
