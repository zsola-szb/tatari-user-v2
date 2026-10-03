import 'package:tatarigigs_user/util/core_export.dart';

class FooterBaseView extends StatelessWidget {
  final Widget child;
  final bool isScrollView;
  final ScrollController? scrollController;
  final ScrollPhysics?physics;
  final bool isCenter;
  final bool? bottomPadding;
  const FooterBaseView({
    super.key,
    required this.child,
    this.isScrollView = true,
    this.isCenter = false,
    this.scrollController,
    this.bottomPadding = true, this.physics
  }) ;

  @override
  Widget build(BuildContext context) {
    if(isCenter){
      return isScrollView ? Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: _widget(context),
        ),
      ) : _widget(context);
    }

    return isScrollView ? SingleChildScrollView(
      controller: scrollController,
      physics: physics ?? const ClampingScrollPhysics(),
      child: _widget(context),
    ) : _widget(context);
  }

  Widget _widget(BuildContext context) {
    return child;
  }
}