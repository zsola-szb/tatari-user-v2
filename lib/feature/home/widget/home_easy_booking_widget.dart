import 'package:tatarigigs_user/feature/booking/widget/rebook/rebook_icon_button.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeEasyBookingWidget extends StatelessWidget {
  const HomeEasyBookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.find<AuthController>().isLoggedIn()) {
      return const SizedBox.shrink();
    }

    return GetBuilder<BookingRebookController>(builder: (rebookController) {
      if (rebookController.easyRebookPage == null) {
        return const HomeRebookingShimmer();
      }

      final List<EasyRebookItem> bookings = rebookController.rebookableBookings;

      if (bookings.isEmpty) {
        return const SizedBox.shrink();
      }
      final bool showSeeAll = bookings.length > 4;

      return Container(
        color: context.customThemeColors.backGroundColor,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.padding16, Dimensions.padding24, Dimensions.padding16, 0),
            child: TitleWidget(
              title: 'recent_bookings',
              isShowSeeAllButton: false,
            ),
          ),
          const SizedBox(height: Dimensions.padding10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            child: Row(children: [

              ...List.generate(bookings.length, (index) => Padding(
                padding: EdgeInsets.only(right: !showSeeAll && index == bookings.length - 1 ? 0 : Dimensions.padding12),
                child: _HomeBookingCard(booking: bookings[index], index: index),
              )),

              if (showSeeAll) SeeAllCircularButton(
                onTap: () => Get.toNamed(RouteHelper.getBookingListRoute(initialTab: 'completed')),
              ),
            ]),
          ),
          const SizedBox(height: Dimensions.padding32),
        ]),
      );
    });
  }
}

class _HomeBookingCard extends StatelessWidget {
  final EasyRebookItem booking;
  final int index;
  const _HomeBookingCard({required this.booking, required this.index});

  static const double _cardWidth = 280;
  static const double _cardPadding = 12;
  static const double _avatarSize = 40;

  @override
  Widget build(BuildContext context) {
    final double avgRating = booking.provider?.avgRating ?? 4.5;
    final int ratingCount = booking.provider?.ratingCount ?? 100;

    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: () {
        if (booking.isRepeat) {
          Get.toNamed(RouteHelper.getRepeatBookingDetailsRoute(bookingId: booking.id));
        } else {
          Get.toNamed(RouteHelper.getBookingDetailsRoute(bookingId: booking.id));
        }
      },
      child: Container(
        width: _cardWidth,
        padding: const EdgeInsets.all(_cardPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _OverlappingServiceThumbnails(services: booking.services, totalCount: booking.serviceCount),
            const Spacer(),

            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                DateConverter.dateStringMonthYear(booking.placedAt),
                style: context.body.small,
              ),
              const SizedBox(height: 2),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(PriceConverter.convertPrice(booking.totalAmount), style: context.heading.large,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ]),
          const SizedBox(height: Dimensions.padding10),

          Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: 0.15)),
          const SizedBox(height: Dimensions.padding10),

          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ClipOval(child: CustomImage(
              image: booking.provider?.logoFullPath,
              height: _avatarSize, width: _avatarSize,
              fit: BoxFit.cover,
              placeholder: Images.userPlaceHolder,
            )),
            const SizedBox(width: Dimensions.padding8),

            Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(
                  booking.provider?.companyName ?? '',
                  style: context.heading.defaultSize,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),

                if(booking.provider?.isVerified ?? false) ...[
                  const SizedBox(width: Dimensions.padding6),
                  SvgPicture.asset(Images.verifiedProvider, width: 16, height: 16),
                ],
              ]),
              const SizedBox(height: 2),

              Directionality(textDirection: TextDirection.ltr, child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Images.starIcon, height: 14, width: 14),
                const SizedBox(width: Dimensions.padding4),
                Text(avgRating.toStringAsFixed(1), style: context.subHeading.small),
                const SizedBox(width: Dimensions.padding4),
                Text('($ratingCount)', style: context.body.small),
              ])),
            ])),
            const SizedBox(width: Dimensions.padding8),

            RebookIconButton(
              bookingId: booking.id,
              subCategoryId: booking.subCategoryId,
              index: index,
            ),
          ]),
        ]),
      ),
    );
  }
}

class _OverlappingServiceThumbnails extends StatelessWidget {
  final List<EasyRebookService> services;
  final int totalCount;
  const _OverlappingServiceThumbnails({required this.services, required this.totalCount});

  static const int _maxVisible = 3;
  static const double _size = 40;
  static const double _overlap = 14;

  @override
  Widget build(BuildContext context) {
    final int visible = services.length.clamp(0, _maxVisible);
    final int extra = totalCount - visible;
    final double width = visible == 0 ? 0 : _size + (visible - 1) * (_size - _overlap);

    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: width, height: _size,
        child: Stack(children: List.generate(visible, (i) => Positioned(
          left: i * (_size - _overlap),
          child: Container(
            width: _size, height: _size,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius8),
              child: CustomImage(
                image: services[i].imageFullPath,
                placeholder: Images.placeholder,
                height: _size, width: _size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )),),
      ),
      if(extra > 0) ...[
        const SizedBox(width: Dimensions.padding8),
        Text('$extra+', style: context.heading.defaultSize),
      ],
    ]);
  }
}

class HomeRebookingShimmer extends StatelessWidget {
  const HomeRebookingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: Column(children: [
        const SizedBox(height: Dimensions.padding20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 20, width: 120, color: Theme.of(context).shadowColor),

              Container(height: 15, width: 50, color: Theme.of(context).shadowColor),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.padding10),

        SizedBox(
          height: 172,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: Dimensions.padding12),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                  border: Border.all(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                    ),
                    const Spacer(),

                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(height: 10, width: 70, color: Theme.of(context).shadowColor),
                      const SizedBox(height: 6),

                      Container(height: 16, width: 90, color: Theme.of(context).shadowColor),
                    ]),
                  ]),
                  const SizedBox(height: Dimensions.padding10),

                  Divider(height: 1, color: Theme.of(context).shadowColor.withValues(alpha: 0.5)),
                  const SizedBox(height: Dimensions.padding10),

                  Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                    ),
                    const SizedBox(width: Dimensions.padding8),

                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(height: 12, width: 120, color: Theme.of(context).shadowColor),
                        const SizedBox(height: 6),

                        Container(height: 10, width: 70, color: Theme.of(context).shadowColor),
                      ],
                    )),
                    const SizedBox(width: Dimensions.padding8),

                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius12),
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ]),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
