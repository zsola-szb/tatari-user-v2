import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class ProviderAvailabilityWidget extends StatelessWidget {
  final String providerId;
  const ProviderAvailabilityWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (providerController){
      ProviderData providerDetails = providerController.providerDetailsContent!.provider!;
      return SizedBox( width: Dimensions.webMaxWidth/2,
        child: Padding(padding: const EdgeInsets.all(Dimensions.padding24),
          child: Column(  mainAxisSize: MainAxisSize.min, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                  child: CustomImage(height: 50, width: 50, fit: BoxFit.cover,
                      image: providerDetails.logoFullPath ?? "")),

              const SizedBox(width: Dimensions.padding10,),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text(providerDetails.name??'', style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),
                      maxLines: 1, overflow: TextOverflow.ellipsis),

                  const SizedBox(height: Dimensions.padding6),
                  Text(providerDetails.address ??'',
                    style: context.subHeading.small.overrideWith(color: Theme.of(context).secondaryHeaderColor),
                    maxLines: 2,overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.padding8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SizedBox(
                          height: 20,
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: Dimensions.fontSizeLarge),
                              Gaps.horizontalGapOf(5),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  providerDetails.rating!.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.padding6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(RouteHelper.getReviewRatingScreen(providerId, ReviewSource.provider)),
                          child: Text('${providerDetails.ratingCount} ${'reviews'.tr}', style: context.heading.defaultSize.copyWith(
                            color: Theme.of(context).secondaryHeaderColor,
                            decoration: TextDecoration.underline,
                          )),
                        ),
                      ],),

                    ],
                  ),
                ],),
              )
            ],),

            const SizedBox(height: Dimensions.padding8,),
            Divider(color: Theme.of(context).hintColor,),
            const SizedBox(height: Dimensions.padding8,),

            Text("availability".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),),
            const SizedBox(height: Dimensions.padding8,),
            Row(mainAxisAlignment: MainAxisAlignment.center , children: [

              Icon(Icons.schedule,size: Dimensions.fontSizeDefault, color:Theme.of(context).textTheme.bodySmall?.color ,),
              const SizedBox(width: Dimensions.padding6,),
              Text("currently_available".tr, style: context.body.defaultSize,),
            ],),


            const SizedBox(height: Dimensions.padding8,),
            Divider(color: Theme.of(context).hintColor,),
            const SizedBox(height: Dimensions.padding8,),

            Text("Monday - Sunday".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),),
            const SizedBox(height: Dimensions.padding8,),
            Text("09:00 - 23:59".tr, style: context.body.defaultSize,),

            const SizedBox(height: Dimensions.padding24,),

            Text("Monday - Sunday".tr, style: context.subHeading.large.overrideWith(fontWeight: AppWeight.medium),),
            const SizedBox(height: Dimensions.padding8,),
            Text("Day Off".tr, style: context.body.defaultSize,),


          ],),
        ),
      );
    });
  }
}
