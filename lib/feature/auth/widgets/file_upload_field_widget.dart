import 'package:tatarigigs_user/feature/auth/model/additional_field_model.dart';
import 'package:tatarigigs_user/helper/file_validation_helper.dart';
import 'package:tatarigigs_user/util/core_export.dart';
import 'package:get/get.dart';

class FileUploadFieldWidget extends StatelessWidget {
  const FileUploadFieldWidget({
    super.key,
    required this.fieldModel,
    required this.selectedFiles,
    required this.onFilesSelected,
  });

  final AdditionalFieldModel fieldModel;
  final List<XFile> selectedFiles;
  final ValueChanged<List<XFile>> onFilesSelected;

  static const _imageExtensions = AppConstants.allowedImageExtensions;

  String get _infoText => [
    if (fieldModel.allowedFileFormats?.isNotEmpty == true)
      fieldModel.fileFormatsDisplay.toUpperCase(),
    if (Get.find<SplashController>().configModel.content?.maxImageUploadSize != null)
      '${'less_than'.tr}: ${((Get.find<SplashController>().configModel.content?.maxImageUploadSize ?? 20971520) / (1000*1000)).toStringAsFixed(2)} ${'mb'.tr}',
  ].join(' ');

  Future<void> _pickFile(BuildContext context) async {
    if (selectedFiles.length >= (fieldModel.fileQuantity ?? 1)) {
      // showCustomSnackBar('${'max_file_limit_reached'.tr} ${fieldModel.fileQuantity}');
       return;
    }

    try {
      final List<String> allowedExtensions = fieldModel.allowedFileFormats ?? [];
      List<String> clearExtensionFormat = [];

      allowedExtensions.forEach((extension){
        if(extension == 'image'){
          clearExtensionFormat.addAll(AppConstants.allowedImageExtensions);
        }
        if(extension == 'pdf'){
          clearExtensionFormat.addAll(AppConstants.allowPdfFormat);
        }
        if(extension == 'document'){
          clearExtensionFormat.addAll(AppConstants.allowDocFormat);
        }
      });

      if (allowedExtensions.isEmpty) {
      //  showCustomSnackBar('no_file_formats_allowed'.tr);
        return;
      }
      final pickedFile = await FileValidationHelper.validateAndPickFile(
        allowedExtensions: clearExtensionFormat,
      );
      if (pickedFile != null) {
        final updated = List<XFile>.from(selectedFiles)..add(pickedFile);
        onFilesSelected(updated);
      }
    } catch (e) {
      assert(() {
        debugPrint('File pick error: $e');
        return true;
      }());
     // showCustomSnackBar('failed_to_pick_file'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewHeight = MediaQuery.sizeOf(context).width * 0.2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withAlpha(120),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldTitle(title: titleFormatedName(fieldModel.title), requiredMark: fieldModel.isRequired),
          const SizedBox(height: Dimensions.padding10),

          Text(
            _infoText,
            style: context.subHeading.extraSmall,
          ),

          if (selectedFiles.isNotEmpty) ...[
            const SizedBox(height: Dimensions.padding16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedFiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: Dimensions.padding10),
              itemBuilder: (context, index) {
                final file = selectedFiles[index];
                final ext = file.name.split('.').last.toLowerCase();
                final isImage = _imageExtensions.contains(ext);

                return isImage
                    ? _ImagePreview(
                  file: file,
                  previewWidth: double.infinity,
                  previewHeight: previewHeight,
                  onRemove: () {
                    final updated = List<XFile>.from(selectedFiles)..removeAt(index);
                    onFilesSelected(updated);
                  },
                )
                    : _FileRow(
                  file: file,
                  onRemove: () {
                    final updated = List<XFile>.from(selectedFiles)..removeAt(index);
                    onFilesSelected(updated);
                  },
                );
              },
            ),
          ],

          if (selectedFiles.length < (fieldModel.fileQuantity ?? 1))
            GestureDetector(
              onTap: () => _pickFile(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.padding20),
                child: Center(
                  child: _EmptyPlaceholder(
                    previewWidth: Get.width,
                    previewHeight: previewHeight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.file,
    required this.previewWidth,
    required this.previewHeight,
    required this.onRemove,
  });

  final XFile file;
  final double previewWidth;
  final double previewHeight;
  final VoidCallback onRemove;

  static const _borderRadius =
  BorderRadius.all(Radius.circular(Dimensions.padding16));

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1,
        dashPattern: const [5, 5],
        color: Theme.of(context).hintColor,
        radius: const Radius.circular(Dimensions.padding16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: _borderRadius,
            child: Image.file(
              File(file.path),
              width: previewWidth,
              height: previewHeight,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 5,
            right: 15,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.highlight_remove_outlined,
                color: Colors.red,
                size: 24,
              ),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}


class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.file,
    required this.onRemove,
  });

  final XFile file;
  final VoidCallback onRemove;

  String get _fileName => file.name;

  String _iconFor(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf'  => Images.pdfIcon,
      'doc'  => Images.docIcon,
      'docx' => Images.docIcon,
      'xls'  => Images.xlsIcon,
      'xlsx' => Images.xlsxIcon,
      'jpg'  => Images.jpgIcon,
      'jpeg' => Images.jpegIcon,
      'png'  => Images.pngIcon,
      'webp' => Images.webpIcon,
      _      => Images.image,
    };
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1,
        dashPattern: const [5, 5],
        color: Theme.of(context).hintColor,
        radius: const Radius.circular(Dimensions.padding10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.padding16,
          vertical: Dimensions.padding20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                spacing: Dimensions.padding10,
                children: [
                  Image.asset(_iconFor(_fileName), height: 30, width: 30),
                  Flexible(
                    child: Text(_fileName, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.highlight_remove_outlined,
                color: Colors.red,
                size: 24,
              ),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}


class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({
    required this.previewWidth,
    required this.previewHeight,
  });

  final double previewWidth;
  final double previewHeight;

  static const _borderRadius =
  BorderRadius.all(Radius.circular(Dimensions.padding16));

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1,
        dashPattern: const [5, 5],
        color: Theme.of(context).hintColor,
        radius: const Radius.circular(Dimensions.padding16),
      ),
      child: Container(
        width: previewWidth,
        height: previewHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: _borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.galleryIcon, scale: 4),
            const SizedBox(height: Dimensions.padding10),

            Text(
              'add_image'.tr,
              style: context.subHeading.small.overrideWith(
                fontWeight: AppWeight.medium,
                color: CustomThemeColors.light().info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}