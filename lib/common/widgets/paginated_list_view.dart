import 'package:get/get.dart';
import 'package:tatarigigs_user/util/core_export.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final Widget itemView;
  final bool showBottomSheet;
  final double bottomPadding;
  final int? limit;

  const PaginatedListView({
    super.key, required this.scrollController, required this.onPaginate, required this.totalSize, this.showBottomSheet = false,
    required this.offset, required this.itemView, this.bottomPadding = Dimensions.padding24 * 2, this.limit = 10,
  }) ;

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _offset;
  List<int>? _offsetList;
  bool _isLoading = false;
  bool showBottomSheet = false;

  @override
  void initState() {
    super.initState();
    _offset = 1;
    _offsetList = [1];
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent && widget.totalSize != null && !_isLoading) {
        if(mounted) {
          _paginate();
        }
      }
    });
  }
  void _paginate() async {


    int pageSize = (widget.totalSize! / (widget.limit ?? 10)).ceil();




    if (_offset < pageSize && !_offsetList!.contains(_offset+1)) {

      setState(() {
        _offset = _offset + 1;
        _offsetList!.add(_offset);
        _isLoading = true;
      });

      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if(pageSize != 0 && _offset>=pageSize-1  &&  widget.showBottomSheet &&  Get.find<SplashController>().configModel.content?.biddingStatus==1 ){
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: Get.context!,
          builder: (BuildContext context){
        return const BottomCreatePostDialog();
      });
      Get.find<CreatePostController>().resetCreatePostValue();
    }
  }


  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset!;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList!.add(index);
      }
    }

    return Column(children: [
      widget.itemView,

      if(_isLoading)
        const SizedBox(height: Dimensions.padding16),

      Center(child: Padding(
        padding: _isLoading ? const EdgeInsets.all(Dimensions.padding10) : EdgeInsets.zero,
        child: _isLoading ? CustomLoaderWidget(color: Theme.of(context).colorScheme.primary) : const SizedBox(),
      )),

       SizedBox(height: widget.bottomPadding ),
    ]);
  }
}