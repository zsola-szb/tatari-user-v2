import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class VerticalScrollableTabBarStatus {
  static bool isOnTap = false;
  static int isOnTapIndex = 0;

  static void setIndex(int index) {
    VerticalScrollableTabBarStatus.isOnTap = true;
    VerticalScrollableTabBarStatus.isOnTapIndex = index;
  }
}

enum VerticalScrollPosition { begin, middle, end }

class VerticalScrollableTabView extends StatefulWidget {

  final TabController _tabController;
  final List<dynamic> _listItemData;
  final Widget Function(dynamic aaa, int index) _eachItemChild;
  final VerticalScrollPosition _verticalScrollPosition;
  final List<Widget> _slivers;
  final List<Widget> _trailingSlivers;
  final AutoScrollController? _scrollController;
  final ScrollPhysics? _physics;
  final void Function(List<int> visibleIndexes, bool isNearBottom)? _onVisibleItemsChanged;

  const VerticalScrollableTabView({super.key,
    required this._tabController,
    required this._listItemData,
    required this._eachItemChild,
    this._verticalScrollPosition = VerticalScrollPosition.begin,
    required this._slivers,
    this._trailingSlivers = const [],
    this._scrollController,
    this._physics,
    this._onVisibleItemsChanged,
  });

  @override
  VerticalScrollableTabViewState createState() => VerticalScrollableTabViewState();
}

class VerticalScrollableTabViewState extends State<VerticalScrollableTabView> with SingleTickerProviderStateMixin {

  static const double _paginationTriggerOffset = 300;
  late AutoScrollController scrollController;
  bool _ownsScrollController = false;
  bool pauseRectGetterIndex = false;
  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemsKeys = {};

  @override
  void initState() {
    widget._tabController.addListener(() {
      if (VerticalScrollableTabBarStatus.isOnTap) {
        animateAndScrollTo(VerticalScrollableTabBarStatus.isOnTapIndex);
        VerticalScrollableTabBarStatus.isOnTap = false;
      }
    });
    _ownsScrollController = widget._scrollController == null;
    scrollController = widget._scrollController ?? AutoScrollController();
    super.initState();
    _reportVisibleItemsAfterFrame();
  }

  @override
  void didUpdateWidget(covariant VerticalScrollableTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reportVisibleItemsAfterFrame();
  }

  void _reportVisibleItemsAfterFrame() {
    if (widget._onVisibleItemsChanged == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _reportVisibleItems();
      }
    });
  }

  void _reportVisibleItems() {
    final void Function(List<int>, bool)? onVisibleItemsChanged = widget._onVisibleItemsChanged;
    if (onVisibleItemsChanged == null) {
      return;
    }

    final List<int> visibleItems = getVisibleItemsIndex();
    if (visibleItems.isEmpty) {
      return;
    }

    final ScrollPosition? position = scrollController.hasClients ? scrollController.position : null;
    final bool isNearBottom = position != null
        && position.maxScrollExtent > 0
        && position.pixels >= position.maxScrollExtent - _paginationTriggerOffset;

    onVisibleItemsChanged(visibleItems, isNearBottom);
  }

  @override
  void dispose() {
    if(_ownsScrollController) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RectGetter(
      key: listViewKey,

      child: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: CustomScrollView(
          controller: scrollController,
          physics: widget._physics,
          slivers: [...widget._slivers, buildVerticalSliverList(), ...widget._trailingSlivers],
        ),
      ),
    );
  }


  SliverList buildVerticalSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(List.generate(
        widget._listItemData.length,
            (index) {

          itemsKeys[index] = RectGetter.createGlobalKey();
          return buildItem(index);
        },
      )),
    );
  }

  Widget buildItem(int index) {
    dynamic category = widget._listItemData[index];
    return RectGetter(

      key: itemsKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: widget._eachItemChild(category, index),
      ),
    );
  }

  void animateAndScrollTo(int index) async {
    pauseRectGetterIndex = true;
    widget._tabController.animateTo(index);
    switch (widget._verticalScrollPosition) {
      case VerticalScrollPosition.begin:
        scrollController
            .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
            .then((value) => pauseRectGetterIndex = false);
        break;
      case VerticalScrollPosition.middle:
        scrollController
            .scrollToIndex(index, preferPosition: AutoScrollPosition.middle)
            .then((value) => pauseRectGetterIndex = false);
        break;
      case VerticalScrollPosition.end:
        scrollController
            .scrollToIndex(index, preferPosition: AutoScrollPosition.end)
            .then((value) => pauseRectGetterIndex = false);
        break;
    }
  }

  bool onScrollNotification(ScrollNotification notification) {

    List<int> visibleItems = getVisibleItemsIndex();
    _reportVisibleItems();
    if(notification is UserScrollNotification){

      if(Get.find<ProviderBookingController>().categoryItemList.length == 2){
        if(notification.metrics.pixels <= 5){
          if(visibleItems.isNotEmpty) widget._tabController.animateTo(visibleItems[0]);
        }else{
          if(visibleItems.length > 1) {
            widget._tabController.animateTo(visibleItems[1]);
          } else if(visibleItems.isNotEmpty){
            widget._tabController.animateTo(visibleItems[0]);
          }
        }
      }
      else if(Get.find<ProviderBookingController>().categoryItemList.length > 2){
          double previousPixels = (notification.metrics).pixels;


          WidgetsBinding.instance.addPostFrameCallback((_) {
            double currentPixels = (notification.metrics).pixels;
            if(currentPixels <= 5){
              if(visibleItems.isNotEmpty) widget._tabController.animateTo(visibleItems[0]);
            }else{
              if (currentPixels < previousPixels) {
                if(visibleItems.isNotEmpty) widget._tabController.animateTo(visibleItems[0]);
              } else {
                if(visibleItems.length > 1){
                  widget._tabController.animateTo(visibleItems[1]);
                }
                else if(visibleItems.isNotEmpty) {
                  widget._tabController.animateTo(visibleItems[0]);
                }
              }
            }


          });

      }

    }


    return false;
  }

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;


    bool isHoriontalScroll = false;
    itemsKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;

      switch (isHoriontalScroll) {
        case true:
          if (itemRect.left > rect.right) return;
          if (itemRect.right < rect.left) return;
          break;
        default:
          if (itemRect.top > rect.bottom) return;
          if (itemRect.bottom <
              rect.top +
                  MediaQuery.of(context).viewPadding.top +
                  kToolbarHeight+200) {
            return;
          }
      }

      items.add(index);
    });
    return items;
  }
}
