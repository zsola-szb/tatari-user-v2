import 'package:tatarigigs_user/util/core_export.dart';

class AvatarStack extends StatelessWidget {
  final List<String> imageUrls;
  final int maxVisible;
  final double size;
  final double overlap;
  final int? totalCount;

  const AvatarStack({
    super.key,
    required this.imageUrls,
    this.maxVisible = 3,
    this.size = 32,
    this.overlap = 10,
    this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    final int visible = imageUrls.length < maxVisible ? imageUrls.length : maxVisible;
    final int extra = (totalCount ?? imageUrls.length) - visible;
    final double width = size + (visible - 1) * (size - overlap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: width,
          height: size,
          child: Stack(
            children: List<Widget>.generate(
              visible,
              (int index) => Positioned(
                left: index * (size - overlap),
                child: _AvatarTile(size: size, imageUrl: imageUrls[index]),
              ),
            ),
          ),
        ),
        if (extra > 0) ...<Widget>[
          const SizedBox(width: Dimensions.padding6),
          Text('+$extra', style: context.subHeading.small.medium),
        ],
      ],
    );
  }
}

class _AvatarTile extends StatelessWidget {
  final double size;
  final String imageUrl;

  const _AvatarTile({required this.size, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.20), width: 0.5),
      ),
      child: ClipOval(
        child: imageUrl.isEmpty
            ? Image.asset(Images.placeholder, fit: BoxFit.cover)
            : CustomImage(image: imageUrl, fit: BoxFit.cover, placeholder: Images.placeholder),
      ),
    );
  }
}
