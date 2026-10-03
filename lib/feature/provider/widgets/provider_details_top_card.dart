import 'package:tatarigigs_user/feature/provider/widgets/easy_booking_card_widget.dart';
import 'package:tatarigigs_user/feature/provider/widgets/provider_premium_tag_widget.dart';
import 'package:tatarigigs_user/helper/extension_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProviderDetailsTopCard extends StatelessWidget {
  final String providerId;
  final Color? color;
  const ProviderDetailsTopCard({
    super.key,
    required this.providerId,
    this.color,
  });

  static const double avatarDiameter = 90;
  static const double _avatarOverlapBelowSeam = avatarDiameter / 2;
  static const double _pillOverhang = 10;
  static const double cardTopClearance = _avatarOverlapBelowSeam + _pillOverhang + Dimensions.padding12;

  static const double _cardCoverOverlap = Dimensions.radius28;

  static double coverHeight(BuildContext context) => context.width / 3 + MediaQuery.of(context).padding.top;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
      builder: (providerController) {
        ProviderDetailsContent detailsContent = providerController.providerDetailsContent!;
        ProviderData providerDetails = detailsContent.provider!;
        final bool showProBanner = Get.find<SplashController>().configModel.content?.isProFeatureActive == 1
            && Get.find<UserController>().userInfoModel?.subscribedPlan == null;
        final bool showRebooking = Get.find<AuthController>().isLoggedIn() && (Get.find<SplashController>().configModel.content?.isRebookingFeatureEnable ?? false);
        final double coverPhotoHeight = coverHeight(context);
        final double cardSeamOffset = coverPhotoHeight - _cardCoverOverlap;
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CustomImage(
                      image: providerDetails.coverImageFullPath ?? '',
                      placeholder: Images.placeholder,
                      width: context.width,
                      height: coverPhotoHeight,
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: cardSeamOffset),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(Dimensions.padding16, cardTopClearance, Dimensions.padding16, Dimensions.padding16),
                        decoration: BoxDecoration(
                          color: color ?? Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radius16)),
                        ),
                        child: Column(
                          children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              providerDetails.name ?? '',
                              style: context.heading.extraLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (providerDetails.isVerified ?? false) ...[
                            const SizedBox(width: Dimensions.padding6),
                            Image.asset(Images.verified, height: 15, width: 15),
                          ],
                        ],
                      ),
                      const SizedBox(height: Dimensions.padding8),

                      _ProviderStatsRow(
                        providerId: providerId,
                        providerDetails: providerDetails,
                      ),
                      const SizedBox(height: Dimensions.padding4),

                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (context) => ProviderAvailabilityWidget(
                              providerId: providerId,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(Images.locationMarker, width: 12, height: 12, colorFilter: ColorFilter.mode(Theme.of(context).hintColor, BlendMode.srcIn)),
                            const SizedBox(width: Dimensions.padding6),
                            Flexible(
                              child: Text(
                                providerDetails.address ?? "",
                                style: context.subHeading.defaultSize.regular.overrideWith(color: context.customThemeColors.secondaryTextColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.padding16),

                      _ProviderOfferCardsRow(
                        campaign: detailsContent.campaign,
                        proMemberPlan: detailsContent.proMemberPlan,
                        surfaceColor: color ?? Theme.of(context).cardColor,
                      ),

                      if (showProBanner) ...[
                        const ProviderPremiumTagWidget(),
                        const SizedBox(height: Dimensions.padding12),
                      ],

                      _ProviderInfoChipsRow(providerDetails: providerDetails),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                if (showRebooking) const EasyBookingCardWidget(),
              ],
            ),

            Positioned(
              top: cardSeamOffset - _avatarOverlapBelowSeam,
              child: _ProviderAvatarBadge(providerId: providerId, providerDetails: providerDetails),
            ),
          ],
        );
      },
    );
  }
}

class _ProviderAvatarBadge extends StatelessWidget {
  final String providerId;
  final ProviderData providerDetails;
  const _ProviderAvatarBadge({
    required this.providerId,
    required this.providerDetails,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = (providerDetails.serviceAvailability == 1)
        ? context.customThemeColors.success : context.customThemeColors.error;
    final Color statusBackgroundColor = (providerDetails.serviceAvailability == 1)
        ? const Color(0xFFEBFFEE) : const Color(0xFFF4CDCF);

    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => ProviderAvailabilityWidget(providerId: providerId),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Dimensions.radiusFull,
              ),
              child: CustomImage(
                height: 90,
                width: 90,
                fit: BoxFit.cover,
                image: providerDetails.logoFullPath ?? "",
                placeholder: Images.userPlaceHolder,
              ),
            ),

            Positioned(
              bottom: -10,
              child: Container(
                decoration: BoxDecoration(
                  color: statusBackgroundColor,
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.padding12,
                  vertical: Dimensions.padding6,
                ),
                child: Text(
                  (providerDetails.serviceAvailability == 1) ? "available".tr : "unavailable".tr,
                  style: context.body.small.overrideWith(color: statusColor).medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderStatsRow extends StatelessWidget {
  final String providerId;
  final ProviderData providerDetails;
  const _ProviderStatsRow({
    required this.providerId,
    required this.providerDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getReviewRatingScreen(providerId, ReviewSource.provider)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.starIcon,
                color: Theme.of(context).colorScheme.secondary,
                height: 15,
                fit: BoxFit.fitHeight,
              ),
              const SizedBox(width: Dimensions.padding3),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  providerDetails.rating?.toStringAsFixed(1) ?? '0.0',
                  style: context.subHeading.defaultSize,
                ),
              ),
              const SizedBox(width: Dimensions.padding4),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '(${providerDetails.ratingCount ?? 0} ${'reviews'.tr})',
                  style: context.heading.small.regular.overrideWith(color: context.customThemeColors.secondaryTextColor),
                ),
              ),
            ],
          ),
        ),

        Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding10)),

        Icon(Icons.build_rounded, size: 14, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: Dimensions.padding3),
        Text.rich(
          TextSpan(
            text: '${providerDetails.serviceCount ?? 0}',
            style: context.heading.small.medium,
            children: [
              TextSpan(
                text: ' ${'services'.tr}',
                style: context.heading.small.regular.overrideWith(color: context.customThemeColors.secondaryTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderOfferCardsRow extends StatelessWidget {
  final ProviderCampaignOffer? campaign;
  final ProviderProMemberOffer? proMemberPlan;
  final Color surfaceColor;

  const _ProviderOfferCardsRow({
    required this.campaign,
    required this.proMemberPlan,
    required this.surfaceColor,
  });

  static const double _rowHeight = 96;

  static String _discountLabel(double? discount) {
    final double value = discount ?? 0;
    final String amount = value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return '$amount% ${'off'.tr}';
  }

  @override
  Widget build(BuildContext context) {
    final ProviderCampaignOffer? campaignOffer = campaign;
    final ProviderProMemberOffer? proOffer = proMemberPlan;

    final List<Widget> cards = <Widget>[];

    if (proOffer != null) {
      cards.add(InkWell(
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        onTap: () => Get.toNamed(RouteHelper.getSubscriptionRoute()),
        child: _ProviderOfferCard(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.08),
          surfaceColor: surfaceColor,
          leading: const _ProviderProBadge(),
          title: proOffer.discount != null ? _discountLabel(proOffer.discount) : proOffer.planName,
          titleStyle: context.heading.large,
          subtitle: '${proOffer.planName} ${'and'.tr} ${'special_saving_for_pro_members'.tr}',
        ),
      ));
    }

    if (campaignOffer != null) {
      final bool hasName = campaignOffer.name.isNotEmpty;
      cards.add(_ProviderOfferCard(
        backgroundColor: context.customThemeColors.error.withValues(alpha: 0.10),
        surfaceColor: surfaceColor,
        perforated: true,
        leading: Image.asset(Images.couponHorizontalIcon, height: 14, width: 14),
        title: hasName ? campaignOffer.name : _discountLabel(campaignOffer.discount),
        titleStyle: hasName ? context.subHeading.large : context.heading.large,
        trailingLabel: hasName ? _discountLabel(campaignOffer.discount) : null,
        subtitle: _campaignSubtitle(campaignOffer),
      ));
    }

    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.padding12),
      child: SizedBox(
        height: _rowHeight,
        child: OverflowBox(
          minWidth: screenWidth,
          maxWidth: screenWidth,
          alignment: Alignment.center,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: cards.length,
            separatorBuilder: (context, index) => const SizedBox(width: Dimensions.padding12),
            itemBuilder: (context, index) => cards[index],
          ),
        ),
      ),
    );
  }

  String _campaignSubtitle(ProviderCampaignOffer offer) {
    final List<String> parts = <String>['${'on_selected_items_only'.tr}.'];

    if (offer.minPurchase != null) {
      parts.add('${'min_purchase'.tr} ${PriceConverter.convertPrice(offer.minPurchase)}.');
    }

    final String? validity = _validity(offer);
    if (validity != null) {
      parts.add('${'validity'.tr}: $validity.');
    }

    return parts.join(' ');
  }

  String? _validity(ProviderCampaignOffer offer) {
    final String? start = _formatDate(offer.startDate);
    final String? end = _formatDate(offer.endDate);

    if (start == null && end == null) {
      return null;
    }
    if (start == null || end == null) {
      return start ?? end;
    }
    return '$start - $end';
  }

  static String? _formatDate(String? value) {
    final DateTime? date = DateTime.tryParse(value ?? '');
    return date == null ? null : DateConverter.dateStringMonthYear(date.toLocal());
  }
}

class _ProviderOfferCard extends StatelessWidget {
  final Color backgroundColor;
  final Color surfaceColor;
  final Widget leading;
  final String title;
  final TextStyle titleStyle;
  final String? trailingLabel;
  final String subtitle;
  final bool perforated;
  const _ProviderOfferCard({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.leading,
    required this.title,
    required this.titleStyle,
    required this.subtitle,
    this.trailingLabel,
    this.perforated = false,
  });

  static const double _cardWidth = 220;
  static const double _horizontalPadding = Dimensions.padding12;

  @override
  Widget build(BuildContext context) {
    final String? trailing = trailingLabel;

    return Container(
      width: _cardWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: Dimensions.padding12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              leading,
              const SizedBox(width: Dimensions.padding8),
              Expanded(
                child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: Dimensions.padding8),
                Text(trailing,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.heading.large,
                ),
              ],
            ],
          ),

          if (perforated)
            _TicketPerforation(surfaceColor: surfaceColor, horizontalPadding: _horizontalPadding)
          else
            const SizedBox(height: Dimensions.padding12),

          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.body.small,
          ),
        ],
      ),
    );
  }
}

/// Dashed tear line with a half-circle notch bitten out of each card edge.
class _TicketPerforation extends StatelessWidget {
  final Color surfaceColor;
  final double horizontalPadding;
  const _TicketPerforation({required this.surfaceColor, required this.horizontalPadding});

  static const double _notchRadius = 7;
  static const double _height = Dimensions.padding20;

  @override
  Widget build(BuildContext context) {
    final Widget notch = Container(
      width: _notchRadius * 2,
      height: _notchRadius * 2,
      decoration: BoxDecoration(color: surfaceColor, shape: BoxShape.circle),
    );

    return SizedBox(
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomDivider(height: 2, dashWidth: 5, color: surfaceColor),
          Positioned(left: -(horizontalPadding + _notchRadius), child: notch),
          Positioned(right: -(horizontalPadding + _notchRadius), child: notch),
        ],
      ),
    );
  }
}

class _ProviderProBadge extends StatelessWidget {
  const _ProviderProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.padding8,
        vertical: Dimensions.padding4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: Dimensions.padding4,
        children: [
          Image.asset(Images.starFill, height: 14, width: 14),
          Text(
            'pro'.tr,
            style: context.subHeading.small.medium.overrideWith(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

class _ProviderInfoChipsRow extends StatelessWidget {
  final ProviderData providerDetails;
  const _ProviderInfoChipsRow({required this.providerDetails});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).hintColor.withValues(alpha: 0.2);

    final List<({String icon, String label})> chipsData = <({String icon, String label})>[
      if (providerDetails.isVerified ?? false) (
        icon: Images.verifiedByAdmin,
        label: '${'verified_provider_by'.tr} ${AppConstants.appName}',
      ),
      if (providerDetails.isCertificationAndLicenseAvailable ?? false) (
        icon: Images.certificationAvailable,
        label: 'certification_and_licenses_available'.tr,
      ),
    ];

    if (chipsData.isEmpty) {
      return const SizedBox.shrink();
    }

    if (chipsData.length == 1) {
      return _ProviderInfoSingleChip(
        icon: chipsData.single.icon,
        label: chipsData.single.label,
        borderColor: borderColor,
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            for (int index = 0; index < chipsData.length; index++) ...[
              if (index > 0) VerticalDivider(width: 1, thickness: 1, color: borderColor),
              Expanded(child: _ProviderInfoChip(icon: chipsData[index].icon, label: chipsData[index].label)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProviderInfoSingleChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color borderColor;
  const _ProviderInfoSingleChip({required this.icon, required this.label, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, height: 20, width: 20),
          const SizedBox(width: Dimensions.padding8),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.subHeading.small.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderInfoChip extends StatelessWidget {
  final String icon;
  final String label;
  const _ProviderInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding16, vertical: Dimensions.padding12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SvgPicture.asset(icon, height: 20, width: 20),
        const SizedBox(height: Dimensions.padding6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.subHeading.small.medium,
        ),
      ]),
    );
  }
}
