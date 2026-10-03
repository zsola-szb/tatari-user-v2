import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class LoyaltyPointListView extends StatelessWidget {
  final ScrollController scrollController;

  const LoyaltyPointListView({super.key, required this.scrollController}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoyaltyPointController>(builder: (loyaltyPointController){
      List<LoyaltyPointTransactionData> listOfTransaction = loyaltyPointController.listOfTransaction;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radius16), topRight: Radius.circular(Dimensions.radius16)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text('point_history'.tr,style: context.heading.large),
          const SizedBox(height: Dimensions.padding16),

          listOfTransaction.isNotEmpty?
          PaginatedListView(
            scrollController: scrollController,
            totalSize: loyaltyPointController.loyaltyPointModel!.content!.transactions!.total!,
            onPaginate: (int offset) async => await loyaltyPointController.getLoyaltyPointData(
              offset, reload: false,
            ),
            offset: loyaltyPointController.loyaltyPointModel!.content!.transactions?.currentPage,
            itemView: ListView.separated(
              itemCount: listOfTransaction.length,
              separatorBuilder: (context, index) => const Divider(height: Dimensions.padding24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return LoyaltyPointItemView(transactionData: listOfTransaction[index]);
              },
            ),
          ) : NoDataScreen(text: 'no_transaction_yet'.tr,type: NoDataType.transaction),
        ],),
      );
    });
  }
}
