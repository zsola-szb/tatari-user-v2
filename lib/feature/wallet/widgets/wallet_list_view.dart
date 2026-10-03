import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class WalletListView extends StatelessWidget {
  final ScrollController scrollController;

  const WalletListView({super.key, required this.scrollController}) ;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WalletController>(builder: (walletController){

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.radius16), topLeft: Radius.circular(Dimensions.radius16)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          Text('wallet_history'.tr, style: context.heading.large),

          const SizedBox(height: Dimensions.padding10),

          const WalletFilterTabBar(),

          const SizedBox(height: Dimensions.padding8),

          walletController.listOfTransaction != null && walletController.listOfTransaction!.isNotEmpty ?
          PaginatedListView(
            scrollController: scrollController,
            totalSize: walletController.walletTransactionModel!.content!.transactions!.total!,
            onPaginate: (int offset) async => await walletController.getWalletTransactionData(
              offset, reload: false, type: walletController.selectedWalletFilter?.value ?? ""
            ),
            offset: walletController.walletTransactionModel!.content!.transactions?.currentPage,

            itemView: ListView.separated(
              itemCount: walletController.listOfTransaction?.length ?? 0,
              separatorBuilder: (context, index) => const Divider(height: Dimensions.padding24),
              itemBuilder: (context,index){
                return WalletListItem( transactionData: walletController.listOfTransaction![index],);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),

          ): walletController.listOfTransaction == null ? const WalletShimmer() :

          NoDataScreen(text: 'no_transaction_yet'.tr,type: NoDataType.transaction),
        ],),
      );
    });
  }
}
