import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function()? onRemovePressed;
  final Function()? onEditPressed;
  final Function()? onTap;
  final String? selectedUserAddressId;
  final Color? backgroundColor;
  final bool? isShowOnlyEdit;
  const AddressWidget({super.key, required this.address, required this.fromAddress, this.onRemovePressed, this.onEditPressed, this.backgroundColor,
    this.onTap, this.fromCheckout = false, this.selectedUserAddressId , this.isShowOnlyEdit = false});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            top:  Dimensions.padding16,
            bottom:  Dimensions.padding16,
            left: Dimensions.padding10,
            right: Dimensions.padding10,
          ),
          decoration: BoxDecoration(
            color:  selectedUserAddressId != null && selectedUserAddressId != address.id
                ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5)  : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(Dimensions.radius8),
            border:  selectedUserAddressId != null && selectedUserAddressId == address.id  ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)) : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.center,children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(children: [
                    if(selectedUserAddressId != null && selectedUserAddressId == address.id)
                    Stack(alignment: Alignment.center,children: [
                      Icon(Icons.circle_outlined , color: Theme.of(context).colorScheme.primary,),
                       Icon(Icons.circle, size: 10, color: Theme.of(context).colorScheme.primary,),
                    ]) ,

                    Icon(
                      _getAddressIcon(address.addressLabel?.toLowerCase() ?? ''),
                      color: Theme.of(context).colorScheme.primary,
                      size: Dimensions.padding20,
                    ),
                    const SizedBox(width: Dimensions.padding6),

                    Text((address.addressLabel != null ? address.addressLabel.toString().toLowerCase() : 'others').tr, style: context.subHeading.large.overrideWith(
                      fontWeight: AppWeight.medium,
                      color: selectedUserAddressId != null && selectedUserAddressId != address.id ? Theme.of(context).hintColor: null,
                    ),),
                  ]),

                  const SizedBox(height: Dimensions.padding6,),
                  Text(address.address??"",
                    style: context.body.extraSmall,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),
            ),
            Row(children: [
              fromAddress ?  selectedUserAddressId != null && selectedUserAddressId == address.id ? const SizedBox() : IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                onPressed: onEditPressed,
              )
                  : isShowOnlyEdit == false ?  const SizedBox() : IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                onPressed: onEditPressed,
              ),

              if(address.id != null)
                fromAddress ? selectedUserAddressId != null && selectedUserAddressId == address.id ? const SizedBox() :
                IconButton(icon: const Icon(Icons.delete, color: Colors.red, size:  25),
                    onPressed: onRemovePressed) : const SizedBox(),
            ],)
          ]),
        ),
      ),
    );
  }
}

IconData _getAddressIcon(String addressLevel) {
  switch (addressLevel) {
    case 'home':
      return Icons.home;
    case 'office':
      return Icons.work;
    default:
      return Icons.widgets;
  }
}