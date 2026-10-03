import 'package:tatarigigs_user/common/widgets/custom_pop_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';


class ProviderOfferListScreen extends StatefulWidget {
  final String? postId;
  final String? status;
  const ProviderOfferListScreen({super.key, this.postId, this.status}) ;

  @override
  State<ProviderOfferListScreen> createState() => _ProviderOfferListScreenState();
}

class _ProviderOfferListScreenState extends State<ProviderOfferListScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CreatePostController>().getProvidersOfferList(1,widget.postId??"",reload: true);
    Get.find<CreatePostController>().getPostDetails(widget.postId??"");
  }
  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();

    return CustomPopWidget(
      child: Scaffold(
        backgroundColor: context.customThemeColors.backGroundColor,
        appBar:  CustomAppBar(title: 'custom_service_details'.tr),
        body: GetBuilder<CreatePostController>(
          builder: (createPostController){

          if(widget.postId == null){
            return NoDataScreen(text: "no_data_found".tr, type: NoDataType.bookings,);
          }

          if(createPostController.providerOfferModel == null || createPostController.isLoadingPostDetails || createPostController.postDetails == null){
            return const Center(child: CircularProgressIndicator());
          }

          bool hasOffers = createPostController.listOfProviderOffer != null && createPostController.listOfProviderOffer!.isNotEmpty;

          if(!hasOffers){
            return Column(children: [
              const Expanded(child: NoProviderBidsView()),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.padding16).copyWith(top: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
                ),
                child: SafeArea(top: false, child: PostServiceDetailsCard(postData: createPostController.postDetails!, postId: widget.postId!)),
              ),
            ]);
          }

          return ExpandableBottomSheet(
            background: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(constraints: BoxConstraints(minHeight: Get.height * 0.6),
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20),
                      child: PaginatedListView(
                        scrollController: scrollController,
                        totalSize: createPostController.providerOfferModel!.totalSize,
                        onPaginate: (int offset) async => await createPostController.getProvidersOfferList(offset, widget.postId ?? "", reload: false),
                        offset: createPostController.providerOfferModel!.offset,
                        itemView: ListView.builder(
                          itemCount: createPostController.listOfProviderOffer?.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                            left: Dimensions.padding16,
                            right: Dimensions.padding16,
                            bottom: 100,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return AcceptProviderRequestView(
                              providerOfferData: createPostController.listOfProviderOffer![index],
                              postId: widget.postId!,
                              length: createPostController.listOfProviderOffer?.length ?? 0,
                            );
                          },),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            persistentContentHeight: 170,
            expandableContent: PostDetailsExpandableContent(postData: createPostController.postDetails!, postId: widget.postId!,),
          );
        }),
      ),
    );
  }
}
