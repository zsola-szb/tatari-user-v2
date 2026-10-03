import 'package:tatarigigs_user/common/widgets/image_dialog.dart';
import 'package:tatarigigs_user/feature/booking/widget/common/booking_section_card.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class BookingPhotoEvidenceSection extends StatelessWidget {
  final List<String> photos;

  const BookingPhotoEvidenceSection({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

    return BookingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('completed_service_picture'.tr, style: context.heading.large),
          const SizedBox(height: Dimensions.padding12),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: photos.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: Dimensions.padding8),
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext _) => ImageDialog(
                    imageUrl: photos[index],
                    title: 'completed_service_picture'.tr,
                    subTitle: '',
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius8),
                  child: CustomImage(
                    image: photos[index],
                    height: 76,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
