import 'package:tatarigigs_user/util/core_export.dart';

class SelectedProviderChip extends StatelessWidget {
  final ProviderData? providerData;
  const SelectedProviderChip({super.key, this.providerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius6),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), width: 0.7),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.padding10),
      child: Center(child: Row(
        children: [

          ClipRRect( borderRadius: BorderRadius.circular(Dimensions.radiusFull),
            child: CustomImage(
              image: "${providerData?.logoFullPath}",
              height: 25, width: 25,),),
          const SizedBox(width: Dimensions.padding10,),
          Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 15,),
          Directionality(textDirection: TextDirection.ltr,
            child: Text( "${providerData?.rating ?? ""}", style: context.subHeading.defaultSize.overrideWith(fontWeight: AppWeight.medium),),
          )

        ],
      )),
    );
  }
}