import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FavoriteIconWidget extends StatefulWidget {
  final int? value;
  final String? serviceId;
  final String? providerId;
  final bool ? showDialog;
  final int? index;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final bool isTap;
  final double? size;
  final double? iconSize;
  const FavoriteIconWidget({super.key,  this.value, this.serviceId, this.providerId, this.signInShakeKey, this.showDialog, this.index,  this.isTap = true, this.size, this.iconSize}) ;

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.value ?? 0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant FavoriteIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.serviceId != widget.serviceId ||
        oldWidget.providerId != widget.providerId) {
      _isFavorite = widget.value ?? 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _toggleFavorite() async {
    int? updatedStatus;

    if(widget.providerId !=null){
      updatedStatus = await Get.find<ProviderBookingController>().updateIsFavoriteStatus(providerId: widget.providerId!, index: widget.index);
    }else if(widget.serviceId != null){
      updatedStatus = await Get.find<ServiceController>().updateIsFavoriteStatus(
        serviceId: widget.serviceId!,
        currentStatus: _isFavorite,
      );
    }

    if(updatedStatus == null || !mounted){
      return;
    }

    final int status = updatedStatus;
    setState(() => _isFavorite = status);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.padding16),
      onTap: widget.isTap ? (){

        _controller.reverse().then((value) => _controller.forward());

        if(Get.find<AuthController>().isLoggedIn()){
         if(widget.showDialog == true){
           showModalBottomSheet(
             context: context,
             useRootNavigator: true,
             isScrollControlled: true,
             builder: (context) => FavoriteItemRemoveDialog(
               providerId : widget.providerId,
               serviceId: widget.serviceId,
             ),
             backgroundColor: Colors.transparent,
           );
         }else{
           _toggleFavorite();
         }
        }else{
          widget.signInShakeKey?.currentState?.shake();

          customSnackBar(
            type: ToasterMessageType.info,
            "please_login_to_add_favorite_list".tr,
            customWidget: Row(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                child: Row(children: [
                  const Icon(Icons.info, color:  Colors.blueAccent, size: 20),
                  const SizedBox(width: Dimensions.padding10),
                  Flexible(
                    child: Text("please_login_to_add_favorite_list".tr,
                      style: context.subHeading.small.overrideWith(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.padding20),
                ]),
              ),

              InkWell(
                onTap : () => Get.toNamed(RouteHelper.getSignInRoute(redirectUrl: Get.currentRoute)),
                child: Text('sign_in'.tr, style: context.subHeading.small.copyWith(color: Colors.white, decoration: TextDecoration.underline)),
              ),
            ],),
          );
        }
      } : null,
      child: SizedBox(
        width: widget.size ?? Dimensions.padding16 * 2 + 23,
        height: widget.size ?? Dimensions.padding16 * 2 + 23,
        child: Center(
          child: ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: SvgPicture.asset(_isFavorite == 1 && Get.find<AuthController>().isLoggedIn() ? Images.favorite : Images.unFavorite, width: widget.iconSize ?? 23,),
          ),
        ),
      ),
    );
  }
}
