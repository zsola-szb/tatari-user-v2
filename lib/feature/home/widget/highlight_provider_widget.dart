import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class HighlightProviderWidget extends StatelessWidget {
  const HighlightProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    const double detailsPanelHeight = 160;
    const double viewportFraction = 0.9;
    const double itemGap = Dimensions.padding8;
    final double cardWidth = (width * viewportFraction) - (itemGap * 2);
    final double cardAspectRatio = width / ((cardWidth * 9 / 16) + detailsPanelHeight);

    return GetBuilder<AdvertisementController>(builder: (advertisementController){
      return advertisementController.advertisementList != null &&  advertisementController.advertisementList!.isNotEmpty ? Container(
        padding: const EdgeInsets.all(Dimensions.padding16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: Get.isDarkMode ? 0.2 : 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('highlight_for_you'.tr, style: context.heading.extraLarge),
                      const SizedBox(height: Dimensions.padding6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10, vertical: Dimensions.padding2),
                        decoration: BoxDecoration(
                          color: context.customThemeColors.secondaryTextColor.withValues(alpha:0.15),
                          borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                        ),
                        child: Text('sponsored'.tr, style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor)),
                      ),
                    ],
                  ),
                ),

                SvgPicture.asset(Images.awesomeImage, width: 40, height: 40),
              ],
            ),

            const SizedBox(height: Dimensions.padding16,),

            CarouselSlider.builder(
              key: ValueKey(advertisementController.advertisementList!.length),
              options: CarouselOptions(
                enableInfiniteScroll:advertisementController.advertisementList!.length > 1,
                autoPlay: advertisementController.autoPlay,
                enlargeCenterPage: false,
                aspectRatio: cardAspectRatio,
                viewportFraction: viewportFraction,
                padEnds: false,
                disableCenter: true,
                onPageChanged: (index, reason) {

                  advertisementController.setCurrentIndex(index, true);

                  if(advertisementController.advertisementList?[index].type == "video_promotion"){
                    advertisementController.updateAutoPlayStatus(status: false);
                  }else{
                    advertisementController.updateAutoPlayStatus(status: true);
                  }
                },
              ),
              itemCount: advertisementController.advertisementList?.length,
              itemBuilder: (context, index, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: itemGap),
                  child: advertisementController.advertisementList?[index].type == "video_promotion" ? AdvertisementVideoPromotionWidget(
                    advertisement :advertisementController.advertisementList![index],
                  ) : AdvertisementProfilePromotionWidget(advertisement : advertisementController.advertisementList![index],index: index,),
                );
              },
            ),

          ],
        ),
      ): advertisementController.advertisementList == null ?
      const AdvertisementShimmer() : const SizedBox();
    });
  }
}

class _AdvertisementDetails extends StatelessWidget {
  final Advertisement advertisement;
  const _AdvertisementDetails({required this.advertisement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(advertisement.title ?? "",
            style: context.heading.large,
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.padding4),
          Text(
            advertisement.description ?? "",
            style: context.subHeading.small.overrideWith(color: context.customThemeColors.secondaryTextColor),
            maxLines: 2, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.padding10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              advertisement.showRating || advertisement.showReview ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(advertisement.showRating)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.star, color: Theme.of(context).colorScheme.secondary, size: 16),
                      const SizedBox(width: Dimensions.padding4),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          advertisement.providerData?.rating?.toStringAsFixed(1) ?? '',
                          style: context.heading.small.overrideWith(color: context.customThemeColors.textColor)
                        ),
                      ),
                    ]),
                  if(advertisement.showReview)
                    Text('${advertisement.providerData?.ratingCount ?? 0}+ ${'review'.tr}', style: context.body.small),
                ],
              ) : const SizedBox(),
              const SizedBox(width: Dimensions.padding16),

              if((advertisement.providerData?.serviceImages ?? []).isNotEmpty)
              _AdvertisementAvatarCluster(services: advertisement.providerData?.serviceImages ?? []),
              const Spacer(),

              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getProviderDetails(advertisement.providerId ?? '')),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(Dimensions.radius8),
                  ),
                  child: Text('book_now'.tr, style: context.subHeading.small.overrideWith(color: Colors.white, fontWeight: AppWeight.medium)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdvertisementAvatarCluster extends StatelessWidget {
  const _AdvertisementAvatarCluster({required this.services});
  final List<String> services;
  final double _avatarSize = 28;
  final double _overlapOffset = 16;

  @override
  Widget build(BuildContext context) {
    final int serviceLength = services.length;
    final int avatarLength = services.length > 2 ? 2 : serviceLength;
    return SizedBox(
      height: _avatarSize,
      width: _avatarSize + (avatarLength * _overlapOffset),
      child: Stack(
        children: [
          for (int i = 0; i < avatarLength; i++)
            Positioned(
              left: i * _overlapOffset,
              child: _AvatarCircle(child: CustomImage(image: services[i], height: _avatarSize, width: _avatarSize, fit: BoxFit.cover)),
            ),

          if(services.length > 2)
          Positioned(
            left: avatarLength * _overlapOffset,
            child: _AvatarCircle(
              backgroundColor: Theme.of(context).shadowColor,
              child: Center(child: Text('+${services.length - avatarLength}',  style: context.body.small)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const _AvatarCircle({required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
      ),
      child: ClipOval(child: SizedBox.expand(child: child)),
    );
  }
}

class AdvertisementVideoPromotionWidget extends StatefulWidget {
  final Advertisement advertisement;
  const AdvertisementVideoPromotionWidget({super.key, required this.advertisement});

  @override
  State<AdvertisementVideoPromotionWidget> createState() => _AdvertisementVideoPromotionWidgetState();
}

class _AdvertisementVideoPromotionWidgetState extends State<AdvertisementVideoPromotionWidget> {


  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    videoPlayerController.addListener(() {

      if(videoPlayerController.value.duration == videoPlayerController.value.position ){
        Get.find<AdvertisementController>().updateAutoPlayStatus(status:  true, shouldUpdate: true);
      }
    });
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        widget.advertisement.promotionalVideoFullPath ?? ""
    ));

    await Future.wait([
      videoPlayerController.initialize(),

    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {

    videoPlayerController.setVolume(1);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
      customControls: const _VideoPromotionControls(),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    final String? providerId = widget.advertisement.providerData?.id ?? widget.advertisement.providerId;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio:  16/9,
            child: Stack(
              alignment: Alignment.center,
              children: [

                Positioned.fill(child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Get.isDarkMode ? Colors.grey.shade700 : Colors.white, // Color at the beginning
                      Get.isDarkMode ? Theme.of(context).cardColor : Colors.cyan.shade50, // Color in the middle
                      Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
                    ]),
                  ),
                )),
                _chewieController !=null &&  _chewieController!.videoPlayerController.value.isInitialized ?
                Stack(
                  children: [
                    Chewie(controller: _chewieController!),
                  ],
                ) : const CircularProgressIndicator(),

                Align(
                  alignment: favButtonAlignment(),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.padding10),
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                      clipBehavior: Clip.antiAlias,
                      child: FavoriteIconWidget(
                        value: widget.advertisement.providerData?.isFavorite,
                        providerId: providerId,
                        isTap: providerId != null,
                        size: 28,
                        iconSize: 14,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          _AdvertisementDetails(advertisement: widget.advertisement),
        ],
      ),
    );
  }
}

class _VideoPromotionControls extends StatefulWidget {
  const _VideoPromotionControls();

  @override
  State<_VideoPromotionControls> createState() => _VideoPromotionControlsState();
}

class _VideoPromotionControlsState extends State<_VideoPromotionControls> {

  late VideoPlayerController _videoPlayerController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _videoPlayerController = ChewieController.of(context).videoPlayerController;
    _videoPlayerController.addListener(_onVideoPlayerUpdate);
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoPlayerUpdate);
    super.dispose();
  }

  void _onVideoPlayerUpdate() {
    if(mounted) {
      setState(() {});
    }
  }

  void _togglePlayPause() {
    if(_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  String _formatDuration(Duration duration) {
    final String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {

    final bool isPlaying = _videoPlayerController.value.isPlaying;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _togglePlayPause,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(Dimensions.padding10),
                decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),

        Positioned(
          left: Dimensions.padding32, right: Dimensions.padding32, bottom: Dimensions.padding8,
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                Text(_formatDuration(_videoPlayerController.value.position), style: const TextStyle(color: Colors.white, fontSize: 11)),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding8),
                    child: MaterialVideoProgressBar(
                      _videoPlayerController,
                      barHeight: 3, handleHeight: 5,
                      colors: ChewieProgressColors(
                        playedColor: Theme.of(context).colorScheme.primary,
                        bufferedColor: Colors.white54,
                        backgroundColor: Colors.white24,
                        handleColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                Text(_formatDuration(_videoPlayerController.value.duration), style: const TextStyle(color: Colors.white, fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdvertisementProfilePromotionWidget extends StatelessWidget {
  final Advertisement advertisement;
  final int index;
  const AdvertisementProfilePromotionWidget({super.key, required this.advertisement, required this.index});

  @override
  Widget build(BuildContext context) {

    final String? providerId = advertisement.providerData?.id ?? advertisement.providerId;

    return GetBuilder<AdvertisementController>(builder: (advertisementController){

      return InkWell(
        onTap: () => Get.toNamed(RouteHelper.getProviderDetails(advertisement.providerId ?? '')),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radius16),
            boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: Stack(
                  children: [
                    CustomImage(
                      height: double.infinity, width: double.infinity,
                      image:  advertisement.providerCoverImageFullPath ?? "",
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: favButtonAlignment(),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.padding10),
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                          clipBehavior: Clip.antiAlias,
                          child: FavoriteIconWidget(
                            value: advertisement.providerData?.isFavorite,
                            providerId: providerId,
                            isTap: providerId != null,
                            size: 28,
                            iconSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _AdvertisementDetails(advertisement: advertisement),
            ],
          ),
        ),
      );
    });
  }
}


class AdvertisementShimmer extends StatelessWidget {
  const AdvertisementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: Get.isDarkMode ? 0.2 : 0.1),
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 20, width: 180,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).shadowColor),
            ),
            const SizedBox(height: Dimensions.padding10),
            Container(height: 20, width: 90,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusFull), color: Theme.of(context).shadowColor),
            ),

            const SizedBox(height: Dimensions.padding16),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16/9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radius16),
                          topRight: Radius.circular(Dimensions.radius16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.padding16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 17, width: double.infinity, color: Theme.of(context).shadowColor),
                        const SizedBox(height: Dimensions.padding10),
                        Container(height: 12, width: 150, color: Theme.of(context).shadowColor),
                        const SizedBox(height: Dimensions.padding16),
                        Container(height: 34, width: double.infinity, color: Theme.of(context).shadowColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.padding10),
          ],
        ),
      ),
    );
  }
}