import 'package:tatarigigs_user/util/core_export.dart';
import 'package:file_picker/file_picker.dart';


class ImageSize{

  static Future <double> getImageSizeFromXFile(XFile xFile)  async {
    int sizeInKB =  await xFile.length();
    double sizeInMB = sizeInKB / (1024 * 1024);
    return sizeInMB;
  }

  static Future <double> getMultipleImageSizeFromXFile(List<XFile>  xFiles)  async {

    double imageSize = 0.0;
    for (var element in xFiles) {
      imageSize = ( await element.length() / (1024 * 1024)) + imageSize;
    }
    return imageSize;
  }

  static Future <double> getMultipleImageSizeFromMultipart(List<MultipartBody>  multiParts)  async {

    double imageSize = 0.0;
    for (var element in multiParts) {
      imageSize = ( await element.file.length() / (1024 * 1024)) + imageSize;
    }
    return imageSize;
  }

  static Future<String> getFileSizeFromPlatformFileToString(PlatformFile platformFile)  async {

    int sizeOfTheFileInBytes =  await platformFile.length();
    String fileSize = "";

    if((sizeOfTheFileInBytes / (1024 * 1024)) > 1){
      fileSize = "${(sizeOfTheFileInBytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }else{
      fileSize = "${(sizeOfTheFileInBytes / 1024 ).toStringAsFixed(1)} KB";
    }
    return fileSize;
  }

  static Future<double> getFileSizeFromPlatformFileToDouble(PlatformFile platformFile)  async {
    return (await platformFile.length() / (1024 * 1024));
  }


  static Future<double> getMultipleFileSizeFromPlatformFiles(List<PlatformFile> platformFiles)  async {

    double fileSize = 0.0;
    for (var element in platformFiles) {
      fileSize  = (await element.length() / (1024 * 1024)) + fileSize;
    }
    return fileSize;
  }
}