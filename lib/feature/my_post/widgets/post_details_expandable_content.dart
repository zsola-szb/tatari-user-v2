import 'package:tatarigigs_user/util/core_export.dart';

class PostDetailsExpandableContent extends StatelessWidget {
 final PostFullDetails postData;
 final String postId;
  const  PostDetailsExpandableContent({super.key, required this.postData, required this.postId}) ;

  @override
  Widget build(BuildContext context) {
    return Center(child: Stack(clipBehavior: Clip.none,alignment: Alignment.topCenter,children: [
      Container(
        padding: const EdgeInsets.all(Dimensions.padding16).copyWith(top: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 1),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20),),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
          const SizedBox(height: Dimensions.padding10),

          PostServiceDetailsCard(postData: postData, postId: postId, showEditButton: false),
        ]),
      ),

      Positioned(top: -15,
        child: Container(height: 20,width: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(150),topRight: Radius.circular(150)),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
          ),
          child: Icon(Icons.keyboard_arrow_up,color: Theme.of(context).colorScheme.primary),
        ),
      ),

      Positioned(top: 2,child: Container(
        height: 5,width: 60,decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
      ))
    ]),
    );
  }
}
